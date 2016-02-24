name             'raven-deploy'
maintainer       'Sitening LLC'
maintainer_email 'phil@raventools.com'
license          'MIT'
description      'Installs/Configures raven-deploy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.2'

depends "build-essential"
depends "aws"
depends "s3_file"
depends "apache2"
depends "raven-dev"
depends "raven-php"
depends "yum"

recipe "raven-deploy::default", "set up deployment dependencies"
recipe "raven-deploy::install_aws_credentials", "install aws key pairs in ~/.aws/credentials"
recipe "raven-deploy::install_keys", "install application deploy keys"
recipe "raven-deploy::install_raven_repo", "install raven yum repo on images that don't have it by default"
recipe "raven-deploy::fetch_data_bags", "fetches chef data bags from s3"

attribute "raven_deploy",
    :display_name => "Raven Deploy",
    :type => "hash"

attribute "raven_deploy/aws_key",
    :display_name => "AWS Access Key ID",
    :description => "AWS Access Key ID",
    :required => "recommended",
    :type => "string",
    :recipes => ["raven-deploy::install_aws_credentials"]

attribute "raven_deploy/aws_secret",
    :display_name => "AWS Secret Key",
    :description => "AWS Secret Key",
    :required => "recommended",
    :type => "string",
    :recipes => ["raven-deploy::install_aws_credentials"]

attribute "raven_deploy/cache_dir",
    :display_name => "Cache Directory",
    :description => "Directory to store downloaded files",
    :required => "recommended",
    :type => "string",
    :recipes => ["raven-deploy::default"],
	:default => "/var/chef/cache"

