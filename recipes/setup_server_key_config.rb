
if !node[:raven_deploy].attribute?(:developer_shortname) then
    if !node.attribute?(:ec2) || !node[:ec2].attribute?(:instance_id) then
            raise "EC2 vars and developer short name not set"
    end
    server_key = node[:ec2][:instance_id]
else
    server_key = node[:raven_deploy][:developer_shortname]
end

config_path = node[:raven_deploy][:deploy_base_path]

directory config_path

config = {
	"server_key" => server_key
}

ruby_block "create global server_key config" do
    block do
        File.open("#{config_path}/server_key.json","w") do |f|
            f.write(JSON.pretty_generate(config))
        end
    end
end
