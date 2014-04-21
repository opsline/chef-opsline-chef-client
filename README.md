opsline-chef-client Cookbook
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
#### opsline-chef-client::cron
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

The recipe also installs `disable_chef` and `enable_chef` scripts 
in `/opt/chef/bin`. When disable script creates `/var/log/chef/disabled` file
which prevents chef client from executing until that file is removed.
This is a good way to disable chef client runs temporarily.


#### opsline-chef-client::unregister_on_shutdown
Installs an init script that will execute when node is shutting down.
It will delete node and client objects from chef server.


License and Authors
-------------------
Authors: Radek Wierzbicki (OpsLine)
