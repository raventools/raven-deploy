use_inline_resources if defined?(use_inline_resources)

action :create do
	local_file = "#{node[:raven_deploy][:attachments_dir]}/#{new_resource.name}"
	remote_file = new_resource.name

	aws_s3_file local_file do
		if node.attribute?("raven_deploy") and node[:raven_deploy].attribute?("aws_key") then
			aws_access_key_id node[:raven_deploy][:aws_key]
		end
		if node.attribute?("raven_deploy") and node[:raven_deploy].attribute?("aws_secret") then
			aws_secret_access_key node[:raven_deploy][:aws_secret]
		end
		remote_path remote_file
		bucket node[:raven_deploy][:attachments_bucket]
	end

	dpkg_package local_file do
		source local_file
	end
end

action :delete do
	raise "not implemented"
end
