actions [:checkout]
default_action :checkout

attribute :name, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String
attribute :owner, :kind_of => String
attribute :repository, :kind_of => String
attribute :revision, :kind_of => String, :default => "master"

attribute :docroot, :kind_of => String, :default => "public"
attribute :domains, :kind_of => Array, :default => ["localhost"]
attribute :port, :kind_of => Integer, :default => 80
