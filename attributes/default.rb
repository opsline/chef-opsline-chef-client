default['opsline-chef-client']['cron'] = true
default['opsline-chef-client']['use_cron_d'] = false
default['opsline-chef-client']['runs_per_hour'] = 2
default['opsline-chef-client']['logrotate']['enabled'] = true
default['opsline-chef-client']['logrotate']['days'] = 30
default['opsline-chef-client']['log_file'] = '/var/log/chef/client.log'
default['opsline-chef-client']['json_attributes_file'] = nil
default['opsline-chef-client']['unregister_at_shutdown'] = false
