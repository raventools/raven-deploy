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


# vagrant overrides the default data bag location. set it back
Chef::Config[:data_bag_path] = "/var/chef/data_bags"

# this is the default location, but for some reason it doesn't work unless it's set here
Chef::Config[:encrypted_data_bag_secret] = "/etc/chef/encrypted_data_bag_secret"

