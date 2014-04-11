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
fqdn_splay = Digest::MD5.new.hexdigest(node.fqdn).hex() % minute_interval

minutes = ''
(0..node['opsline-chef-client']['runs_per_hour']-1).each do |i|
  minutes += ((i * minute_interval) + fqdn_splay).to_s + ','
end
minutes.chop!

cookbook_file '/opt/chef/bin' do
  action :create
  source 'run_chef_client'
  owner 'root'
  group 'root'
  mode '744'
end

cron 'chef-client-cron' do
  action node['opsline-chef-client']['cron'] ? :create : :delete
  minute minutes
  user 'root'
  command '/opt/chef/bin >/dev/null 2>&1'
end
