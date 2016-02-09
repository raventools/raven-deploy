yum_repository "raven-pub" do
	description "Raven Pub Repo"
	gpgcheck false
	baseurl "http://raven-pub-repo.s3-website-us-east-1.amazonaws.com/"
end
