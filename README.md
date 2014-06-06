opsline-chef-client Cookbook
=========================
The opsline-chef-client cookbook configures chef client to run from cron.

The cron recipe is different than chef-client::cron in a way that it wraps
chef-client with a script that creates log and status files. It also 
provides script to temporarily disable (and enable back) the chef runs.

Additionally, it provides a recipe to un-register chef node from chef server
on shutdown.


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

The minute value of cron is calculated based on the hostname, which will
make it different for every node to splay the execution time.

Every chef client run will create two files
* /var/log/chef/client.log
Log file containing INFO output of every run
* /var/log/chef/last_run_status
File will contain 'ok' if the last run suceeded and 'fail' if failed.
This can be used to configure nagios alerts to notify of chef client failures
as well as whether chef client runs on schedule (check file age)

The recipe also installs `disable_chef` and `enable_chef` scripts 
in `/opt/chef/bin` with links in /usr/local/bin.
Disable script creates `/var/log/chef/disabled` file which prevents chef
client from executing until that file is removed.
The script does not remove a cron entry. Cron entry should stay in place. 
This is a good way to disable chef client runs temporarily.
Enable script removes the `/var/log/chef/disabled` file so that
chef client can run again from cron.


#### opsline-chef-client::unregister_on_shutdown
Installs an init script that will execute when node is shutting down.
It will delete node and client objects from chef server.


#### opsline-chef-client::disable_chef
Disables chef client. When you add this recipe,
chef client will not run anymore.
To enable back, execute `enable_chef` script manually


License and Authors
-------------------
Authors: Radek Wierzbicki (OpsLine)
