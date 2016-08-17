use_inline_resources if defined?(use_inline_resources)

action :create do
	prefix = new_resource.prefix
	directory = new_resource.directory

	lockfile = "#{directory}/npm-shrinkwrap.json"

	if ! ::File.exists?(lockfile) then
		raise "could not find npm.lock in #{release_path}"
	end

	checksum = Digest::MD5.file(lockfile).hexdigest
	artifact = "npm/#{prefix}/#{prefix}-#{checksum}.tar"
	checksum_file = "#{directory}/.npm-md5sum"

	raven_deploy_tarball artifact do
		directory directory
		bucket "raven-deploy"
		not_if "grep #{checksum} #{checksum_file}"
	end

	file checksum_file do
		content checksum
	end
end

action :delete do
	uninstall_script = new_resource.uninstall_script
	raise "not implemented"
end
