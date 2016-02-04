name             'raven-deploy'
maintainer       'Sitening LLC'
maintainer_email 'phil@raventools.com'
license          'MIT'
description      'Installs/Configures raven-deploy'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends "s3_file"
depends "apache2"

recipe "raven-deploy::default", "set up deployment dependencies"
recipe "raven-deploy::install_aws_credentials", "install aws key pairs in ~/.aws/credentials"
recipe "raven-deploy::install_keys", "install application deploy keys"
