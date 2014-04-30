#
# Cookbook Name:: opsline-chef-client
# Recipe:: disable
#
# Copyright (C) 2014 Opsline
# 
# All rights reserved - Do Not Redistribute
#

execute 'disable_chef' do
  command '/opt/chef/bin/disable_chef'
  not_if 'test -e /var/log/chef/disabled'
end
