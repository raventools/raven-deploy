directory "/root/.aws"

file "/root/.aws/credentials" do
	content <<-EOH
[default]
aws_access_key_id = #{node[:raven_deploy][:aws_key]}
aws_secret_access_key = #{node[:raven_deploy][:aws_secret]}
	EOH
end

file "/root/.aws/config" do
	content <<-EOH
[default]
region = #{node[:raven_deploy][:aws_region]}
output = json
	EOH
end
