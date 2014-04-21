template '/opt/chef/bin/unregister_chef' do
  action :create
  source 'unregister_chef.erb'
  owner 'root'
  group 'root'
  mode 0750
  variables({
    'node_name' => node.name
  })
end

cookbook_file '/etc/init.d/unregister-chef' do
  action :create
  source 'unregister-chef-init'
  owner 'root'
  group 'root'
  mode 0754
end

service 'unregister-chef' do
  action :enable
end
