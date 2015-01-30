#
# Cookbook Name:: opsline-chef-client
# Recipe:: default
#
# Author:: Radek Wierzbicki
#
# Copyright 2014, OpsLine, LLC.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'digest'


# scripts
template '/opt/chef/bin/run_chef_client' do
  action :create
  source 'run_chef_client.erb'
  owner 'root'
  group 'root'
  mode '0744'
  variables({
    :log_file => node['opsline-chef-client']['log_file'],
    :json_attributes_file => node['opsline-chef-client']['json_attributes_file']
  })
end
cookbook_file '/opt/chef/bin/disable_chef' do
  action :create
  source 'disable_chef'
  owner 'root'
  group 'root'
  mode '0744'
end
link '/usr/local/bin/disable_chef' do
  to '/opt/chef/bin/disable_chef'
end
cookbook_file '/opt/chef/bin/enable_chef' do
  action :create
  source 'enable_chef'
  owner 'root'
  group 'root'
  mode '0744'
end
link '/usr/local/bin/enable_chef' do
  to '/opt/chef/bin/enable_chef'
end
cookbook_file '/opt/chef/bin/check_chef' do
  action :create
  source 'check_chef'
  owner 'root'
  group 'root'
  mode '0744'
end
link '/usr/local/bin/check_chef' do
  to '/opt/chef/bin/check_chef'
end


# directories
directory '/var/log/chef' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end


# cron (depends on attribute)
minute_interval = (60 / node['opsline-chef-client']['runs_per_hour'])
node_splay = Digest::MD5.new.hexdigest(node.hostname).hex() % minute_interval
minutes = ''
(0..node['opsline-chef-client']['runs_per_hour']-1).each do |i|
  minutes += ((i * minute_interval) + node_splay).to_s + ','
end
minutes.chop!
if node['opsline-chef-client']['use_cron_d']
  cron 'chef-client-cron' do
    action :delete
  end
  cron_d 'chef-client-cron' do
    action node['opsline-chef-client']['cron'] ? :create : :delete
    minute minutes
    user 'root'
    command '/opt/chef/bin/run_chef_client >/dev/null 2>&1'
  end
else
  cron_d 'chef-client-cron' do
    action :delete
  end
  cron 'chef-client-cron' do
    action node['opsline-chef-client']['cron'] ? :create : :delete
    minute minutes
    user 'root'
    command '/opt/chef/bin/run_chef_client >/dev/null 2>&1'
  end
end
# disable chef-client service if cron enabled
if node['opsline-chef-client']['cron']
  if File.exists?('/etc/init/chef-client.conf')
    service 'chef-client' do
      provider Chef::Provider::Service::Upstart
      action [:disable, :stop]
    end
  elsif File.exists?('/etc/init.d/chef-client')
    service 'chef-client' do
      supports :status => true, :restart => true
      action [:disable, :stop]
    end
  end
end


# logrotate
logrotate_app 'chef-client' do
  cookbook 'logrotate'
  path '/var/log/chef/*.log'
  options ['copytruncate', 'missingok', 'compress', 'notifempty', 'delaycompress']
  frequency 'daily'
  rotate node['opsline-chef-client']['logrotate']['days']
  enable node['opsline-chef-client']['logrotate']['enabled'] ? :create : :delete
end


# unregister chef at shutdown if enabled
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
  action node['opsline-chef-client']['unregister_at_shutdown'] ? :create : :delete
  source 'unregister-chef-init'
  owner 'root'
  group 'root'
  mode 0754
end
case node['platform_family']
when 'debian'
  if node['opsline-chef-client']['unregister_at_shutdown']
    execute 'update_rc_d_unregister_chef_remove_if_6' do
      action :run
      command 'update-rc.d -f unregister-chef remove'
      user 'root'
      timeout 15
      only_if 'test -f /etc/rc6.d/K20unregister-chef -o -f /etc/rc2.d/K80unregister-chef'
    end
    execute 'update_rc_d_unregister_chef_stop_0' do
      action :run
      command 'update-rc.d -f unregister-chef stop 20 0 .'
      user 'root'
      timeout 15
      not_if 'test -f /etc/rc0.d/K20unregister-chef'
    end
  else
    execute 'update_rc_d_unregister_chef_remove' do
      action :run
      command 'update-rc.d -f unregister-chef remove'
      user 'root'
      timeout 15
      only_if 'test -f /etc/rc0.d/K20unregister-chef'
    end
  end
when 'rhel', 'fedora'
  if node['opsline-chef-client']['unregister_at_shutdown']
    execute 'chkconfig_unregister_chef_on' do
      action :run
      command 'chkconfig --level 0 unregister-chef off'
      user 'root'
      timeout 15
      not_if 'test -f /etc/rc.d/rc0.d/K10unregister-chef'
    end
  else
    execute 'chkconfig_unregister_chef_delete' do
      action :run
      command 'chkconfig --del unregister-chef'
      user 'root'
      timeout 15
      only_if 'test -f /etc/rc.d/rc0.d/K10unregister-chef'
    end
  end
end

# temporary fix
file '/etc/init/chef-unregister.conf' do
  action :delete
end
