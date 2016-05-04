default[:raven_deploy][:aws_key] = nil
default[:raven_deploy][:aws_secret] = nil
default[:raven_deploy][:aws_region] = "us-east-1"

default[:raven_deploy][:keys_bucket] = "raven-deploy"
default[:raven_deploy][:keys_dir] = "/tmp/deploy"

default[:raven_deploy][:attachments_bucket] = "opsworks-attachments"
default[:raven_deploy][:attachments_dir] = "/tmp/attachments"

default[:raven_deploy][:cache_dir] = "/vagrant/cache"

default[:raven_deploy][:httpd_user] = "www-data"
default[:raven_deploy][:httpd_group] = "www-data"

default[:raven_deploy][:deploy_base_path] = "/home/webapps"
