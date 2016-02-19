chef_gem("aws-sdk") { action :nothing }.run_action(:install)

require 'aws-sdk'

begin
	# try w/o creds first, assuming instance role on ec2
	s3 = ::Aws::S3::Client.new(
		:region => "us-east-1"
	)
rescue
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
