actions [:create, :delete]
default_action :create

attribute :prefix, :kind_of => String, :name_attribute => true
attribute :directory, :kind_of => String
