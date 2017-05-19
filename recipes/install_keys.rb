raven_deploy_tarball "deploy-keys.tar" do
	bucket node[:raven_deploy][:keys_bucket]
	directory "/root/.ssh"
end
