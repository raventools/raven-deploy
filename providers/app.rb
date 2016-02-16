use_inline_resources if defined?(use_inline_resources)

action :checkout do

	# application options
	name = new_resource.name
	app_path = new_resource.path
	repository = new_resource.repository
	revision = new_resource.revision

	# vhost-specific options
	docroot = new_resource.docroot
	domains = new_resource.domains
	port = new_resource.port

	if repository.nil? then
		
		# we're on vagrant, so run deploy callbacks
		callback_path = "#{app_path}/deploy/before_symlink.rb"
		if ::File.exists?(callback_path) then
			release_path = app_path
			eval(::File.read(callback_path))
		end

	else

		# we got a repo, so let's deploy it
		key_path = "/root/.ssh/#{name}-deploy.key"
		wrapper_path = "/tmp/#{name}-deploy.sh"
		file wrapper_path do
			content "/usr/bin/env ssh -o 'StrictHostKeyChecking=no' -i '#{key_path}' $1 $2"
			mode 0700
			owner "root"
		end

		deploy app_path do
			provider Chef::Provider::Deploy::Revision
			repo repository
			revision revision
			ssh_wrapper wrapper_path
			symlink_before_migrate		({})
			symlinks					({})
			purge_before_symlink		([])
			create_dirs_before_symlink	([])
		end
	
	end

	unless docroot.nil? then

		# this shouldn't be necessary since apache2::default is being included,
		# but it doesn't work without it
		service "apache2" do
			service_name "httpd"
		end

		# if docroot is a relative path, append it to app_path
		if docroot[0] != "/" then
			docroot = "#{app_path}/current/#{docroot}"
		end
		
		web_app name do
			docroot docroot
			server_name domains.first
			unless domains[1, domains.size].empty?
				server_aliases domains[1, domains.size]
			end
			port port || 80
		end

		apache_module "php5" do
			identifier "php5_module"
			conf true
			filename "libphp5.so"
		end

	end
end
