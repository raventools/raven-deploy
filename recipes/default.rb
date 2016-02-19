directory node[:raven_deploy][:keys_dir]
directory node[:raven_deploy][:attachments_dir]

#include_recipe "raven-deploy::fetch_data_bags"
include_recipe "apache2"
include_recipe "aws"
include_recipe "raven-deploy::install_keys"
include_recipe "raven-dev::gcc"
