directory "/root/.aws"

{
	"/root" => "root",
	"/var/lib/jenkins" => "jenkins",
	"/hudson" => "jenkins"
}.each do |homedir,username|

	file "#{homedir}/.aws/credentials" do
		content <<-EOH
[default]
aws_access_key_id = #{node[:raven_deploy][:aws_key]}
aws_secret_access_key = #{node[:raven_deploy][:aws_secret]}
		EOH
		owner username
		only_if { ::File.exists?(homedir) }
	end

	file "#{homedir}/.aws/config" do
		content <<-EOH
[default]
region = #{node[:raven_deploy][:aws_region]}
output = json
		EOH
		owner username
		only_if { ::File.exists?(homedir) }
	end
end
