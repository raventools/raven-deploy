name             'raven-deploy'
maintainer       'Sitening LLC'
maintainer_email 'phil@raventools.com'
license          'MIT'
description      'Installs/Configures raven-deploy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends "aws"
depends "apache2"
depends "raven-dev"
depends "yum"

recipe "raven-deploy::default", "set up deployment dependencies"
recipe "raven-deploy::install_aws_credentials", "install aws key pairs in ~/.aws/credentials"
recipe "raven-deploy::install_keys", "install application deploy keys"
recipe "raven-deploy::install_raven_repo", "install raven yum repo on images that don't have it by default"
