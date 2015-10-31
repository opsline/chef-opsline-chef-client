#
# Cookbook Name:: opsline-chef-client
# Recipe:: datadog
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

include_recipe 'datadog::dd-agent'

cookbook_file '/etc/dd-agent/checks.d/chef_status.py' do
  source 'datadog_chef_status.py'
  owner 'root'
  group 'root'
  mode 0644
  action :create
  notifies :restart, 'service[datadog-agent]', :delayed
end

datadog_monitor 'chef_status' do
  cookbook 'opsline-chef-client'
  init_config({
    'status_file' => node['opsline-chef-client']['status_file']
  })
  action :add
end
