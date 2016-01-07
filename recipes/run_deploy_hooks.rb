require 'pp'
include_recipe "raven-deploy"

node[:deploy].each do |name,app|
	
	release_path = app[:absolute_document_root]
	before_symlink_file = "#{release_path}/deploy/before_symlink.rb"

	if File.exists?(before_symlink_file) then
		callback = File.read before_symlink_file
		eval(callback)
	end

end
