#
# Cookbook Name:: opsline-chef-client
# Recipe:: cron
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

minute_interval = (60 / node['opsline-chef-client']['runs_per_hour'])
node_splay = Digest::MD5.new.hexdigest(node.hostname).hex() % minute_interval

minutes = ''
(0..node['opsline-chef-client']['runs_per_hour']-1).each do |i|
  minutes += ((i * minute_interval) + node_splay).to_s + ','
end
minutes.chop!

cookbook_file '/opt/chef/bin/run_chef_client' do
  action :create
  source 'run_chef_client'
  owner 'root'
  group 'root'
  mode '0744'
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

service 'chef-client' do
  supports :status => true, :restart => true
  action [:disable, :stop]
end

directory '/var/log/chef' do
  action :create
  owner 'root'
  group 'root'
  mode '0755'
end

cron 'chef-client-cron' do
  action node['opsline-chef-client']['cron'] ? :create : :delete
  minute minutes
  user 'root'
  command '/opt/chef/bin/run_chef_client >/dev/null 2>&1'
end
