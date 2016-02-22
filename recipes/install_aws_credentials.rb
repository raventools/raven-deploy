{
	"/root" => "root",
	"/var/lib/jenkins" => "jenkins",
	"/hudson" => "jenkins"
}.each do |homedir,username|

	directory("#{homedir}/.aws") {
		action :nothing
		owner username
		only_if { ::File.exists?(homedir) }
	}.run_action(:create)

	file("#{homedir}/.aws/credentials") {
		action :nothing
		content <<-EOH
[default]
aws_access_key_id = #{node[:raven_deploy][:aws_key]}
aws_secret_access_key = #{node[:raven_deploy][:aws_secret]}
		EOH
		owner username
		only_if { ::File.exists?(homedir) }
	}.run_action(:create)

	file("#{homedir}/.aws/config") {
		action :nothing
		content <<-EOH
[default]
region = #{node[:raven_deploy][:aws_region]}
output = json
		EOH
		owner username
		only_if { ::File.exists?(homedir) }
	}.run_action(:create)
end
