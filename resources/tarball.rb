actions [:create, :delete]
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :directory, :kind_of => String, :default => "/tmp/deploy_keys"
attribute :bucket, :kind_of => String, :default => ""
attribute :install_script, :kind_of => String, :default => "install.sh"
attribute :uninstall_script, :kind_of => String, :default => "uninstall.sh"
