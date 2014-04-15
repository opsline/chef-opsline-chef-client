#
# Cookbook Name:: opsline-chef-client
# Recipe:: cron
#
# Copyright (C) 2014 Opsline
# 
# All rights reserved - Do Not Redistribute
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
  mode '744'
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
