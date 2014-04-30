#
# Cookbook Name:: opsline-chef-client
# Recipe:: disable
#
# Copyright (C) 2014 Opsline
# 
# All rights reserved - Do Not Redistribute
#

execute 'enable_chef' do
  command '/opt/chef/bin/enable_chef'
  only_if 'test -e /var/log/chef/disabled'
end
