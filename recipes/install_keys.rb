
myusers = { "root" => "/root" }

if system("getent passwd jenkins")
	myusers["jenkins"] = Dir.home("jenkins")
end

myusers.each do |username, sshdir|

	raven_deploy_tarball "code-deploy-keys.tar" do
		bucket node[:raven_deploy][:keys_bucket]
		directory "#{sshdir}/.ssh"
	end

	bash "fix-ssh-permisions" do
		code <<-EOH
			chown -R #{username} #{sshdir}/.ssh
			chmod 0700 #{sshdir}/.ssh
			chmod 0600 #{sshdir}/.ssh/*
		EOH
	end
end
