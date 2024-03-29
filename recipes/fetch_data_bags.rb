IS_VAGRANT = `grep -q '^vagrant:' /etc/passwd >/dev/null&& echo '1'`

if IS_VAGRANT == '1'
	chef_gem "aws-sdk-sso" do
		action :nothing 
		source 'https://rubygems.org/'
	end.run_action(:install)
	chef_gem("aws-sdk") { action :nothing }.run_action(:install)

	require 'aws-sdk'
	require 'fileutils'
	FileUtils.mkdir_p "/etc/chef"

	# https://github.com/aws/aws-sdk-core-ruby/issues/166
	::Aws.use_bundled_cert!

	begin
		puts "attempting to load from instance role\n";
		# try w/o creds first, assuming instance role on ec2
		s3 = ::Aws::S3::Client.new(region:"us-east-1")
	rescue
		puts "loading from instance role failed. use inputs\n";
		# fall back to using provided creds (vagrant)
		s3 = ::Aws::S3::Client.new(
			:region => "us-east-1",
			:credentials => ::Aws::Credentials.new(
				node[:raven_deploy][:aws_key],
				node[:raven_deploy][:aws_secret]
			)
		)
	end

	secret_path = "/etc/chef/encrypted_data_bag_secret"
	if not ::File.exists?(secret_path)
		s3.get_object(
			response_target: secret_path,
			bucket: node[:raven_deploy][:keys_bucket],
			key: ".chef/encrypted_data_bag_secret"
		)
	end

	data_bags_path = "/var/chef"
	s3.list_objects(
		bucket: node[:raven_deploy][:keys_bucket],
		prefix: "data_bags/"
	).contents.each do |o|

		target_path = "#{data_bags_path}/#{o.key}"
		obj_dir = ::File.dirname(target_path)

		if not ::File.exists?(obj_dir) 
			::Dir.mkdir(obj_dir)
		end

		s3.get_object(
			key: o.key,
			bucket: node[:raven_deploy][:keys_bucket],
			response_target: target_path
		)
	end
else
	execute "fetch_data_bags" do
		command <<-EOH
		# Fetch .chef/encrypted_data_bag_secret
		mkdir -pm 0755 /etc/chef
		aws s3 cp s3://#{node[:raven_deploy][:keys_bucket]}/.chef/encrypted_data_bag_secret /etc/chef/encrypted_data_bag_secret
		chmod 0644 /etc/chef/encrypted_data_bag_secret

		# Fetch data_bags
		mkdir -pm 0755 /var/chef/data_bags
		aws s3 sync s3://#{node[:raven_deploy][:keys_bucket]}/data_bags/ /var/chef/data_bags/
		EOH
	end
end

# vagrant overrides the default data bag location. set it back
Chef::Config[:data_bag_path] = "/var/chef/data_bags"

# this is the default location, but for some reason it doesn't work unless it's set here
Chef::Config[:encrypted_data_bag_secret] = "/etc/chef/encrypted_data_bag_secret"

