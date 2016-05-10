
newrelic_install_rpm = "newrelic-repo-5-3.noarch.rpm"
newrelic_install_url = "http://yum.newrelic.com/pub/newrelic/el5/x86_64/#{newrelic_install_rpm}"
rpm_path = "#{node[:raven_deploy][:attachments_dir]}/#{newrelic_install_rpm}"

# download installer
remote_file rpm_path do
	source newrelic_install_url
end

# install installer
rpm_package "newrelic_repo" do
	source rpm_path
end

# install agent
package "newrelic-php5"
package "newrelic-sysmond"

# configure daemon
template "/etc/newrelic/newrelic.cfg" do
	source "newrelic.cfg.erb"
	owner "root"
	mode 0644
	variables ({
			:key => node[:raven_deploy][:newrelic][:key]
			})
	notifies :reload, "service[httpd]", :delayed
end

# configure php agent
template "/etc/php.d/newrelic.ini" do
	source "newrelic.ini.erb"
	owner "root"
	mode 0644
	variables ({
			:appname => node[:raven_deploy][:newrelic][:appname],
			:key => node[:raven_deploy][:newrelic][:key]
			})
	notifies :reload, "service[httpd]", :delayed
end
# configure sysmon
template "/etc/newrelic/nrsysmond.cfg" do
	source "nrsysmond.cfg.erb"
	owner "root"
	mode 0644
	variables ({
			:key => node[:raven_deploy][:newrelic][:key]
			})
	notifies :restart, "service[newrelic-sysmond]", :delayed
end

# need service definition so we can run this by itself
service "httpd" do
	supports :reload => true
	action :nothing
end

service "newrelic-sysmond" do
	supports :restart => true
	action :restart
end
