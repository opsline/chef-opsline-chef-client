#
# Cookbook Name:: opsline-chef-client
# Recipe:: unregister_on_shutdown
#
# Author:: Radek Wierzbicki
#
# Copyright 2014, Opsline, LLC.
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
