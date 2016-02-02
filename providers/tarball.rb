use_inline_resources 

action :create do
	local_file = "#{node[:raven_deploy][:attachments_dir]}/#{new_resource.name}"
	remote_file = new_resource.name
	install_script = new_resource.install_script
	bucket = new_resource.bucket || node[:raven_deploy][:attachments_bucket]

	directory new_resource.directory do
		recursive true
	end

	s3_file local_file do
		if node.attribute?("raven_deploy") and node[:raven_deploy].attribute?("aws_key") then
			aws_access_key_id node[:raven_deploy][:aws_key]
		end
		if node.attribute?("raven_deploy") and node[:raven_deploy].attribute?("aws_secret") then
			aws_secret_access_key node[:raven_deploy][:aws_secret]
		end
		remote_path remote_file
		bucket bucket
		notifies :run, "bash[extract-#{new_resource.name}]", :immediately
	end

	bash "extract-#{new_resource.name}" do
		action :nothing
		cwd new_resource.directory
		code <<-EOH
		tar -xf #{local_file} --no-same-owner
		md5sum `tar tf #{local_file}` > .md5sum
		EOH
#		not_if "cd #{new_resource.directory} && md5sum -c #{new_resource.directory}/.md5sum"
		notifies :run, "bash[install-#{new_resource.name}]", :immediately
	end

	install_script_path = "#{new_resource.directory}/#{install_script}"
	bash "install-#{new_resource.name}" do
		action :nothing
		cwd new_resource.directory
		code <<-EOH
		#{install_script_path}
		EOH
		only_if { ::File.exists?(install_script_path) }
	end
end

action :delete do
	uninstall_script = new_resource.uninstall_script
	raise "not implemented"
end
