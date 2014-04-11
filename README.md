opsline-hostname Cookbook
=========================
This cookbook provides helper recipes for chef client


Requirements
------------
None


Attributes
----------
* `node['opsline-chef-client']['cron']`
if true, setup cron job to run chef client
* `node['opsline-chef-client']['runs_per_hour']`
number of chef client runs per hour


Usage
-----
#### opsline-hostname::cron
Configure chef client cron

Installs `/opt/chef/bin/run_chef_client` script and configures cron job
that executes it configurable number of times per hour.

Every chef client run will create two files
* /var/log/chef/client.log
Log file containing INFO output of every run
* /var/log/chef/last_run_status
File will contain 'ok' if the last run suceeded and 'fail' if failed.
This can be used to configure nagios alerts to notify of chef client failures
as well as whether chef client runs on schedule (check file age)


License and Authors
-------------------
Authors: Radek Wierzbicki (OpsLine)
