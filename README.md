opsline-chef-client Cookbook
=========================
This cookbook was created to provide some additional facilities not available 
from the default chef-client cookbook. Some additions include logging and 
status files along with the ability to enable/disable chef-client at will.


The default recipe disables chef daemon and schedules chef runs from cron,
providing status file for monitoring. It also provides script to temporarily
disable (and enable back) the chef runs.

Cookbook also provides a recipe to un-register chef nodes from chef server
on shutdown.


Requirements
------------
* cron cookbook
* logrotate cookbook
* datadog cookbook


Attributes
----------
* `node['opsline-chef-client']['cron']`
  if true, setup cron job to run chef client
* `node['opsline-chef-client']['use_cron_d']`
  if true, cron will be created using cron_d resource
* `node['opsline-chef-client']['runs_per_hour']`
  number of chef client runs per hour
* `node['opsline-chef-client']['allowed_runtime']`
  number of seconds chef client is allowed to run. It will be killed after that.
* `node['opsline-chef-client']['log_file']`
  change location of chef client log
* `node['opsline-chef-client']['status_file']`
  change location of chef status file
* `node['opsline-chef-client']['json_attributes_file']`
  if set, chef clinet will run with -j option
* `node['opsline-chef-client']['logrotate']['enabled']`
  if true, logrotate will be configured to clean chef client log
* `node['opsline-chef-client']['logrotate']['days']`
  days to keep chef client log if logrotate is enabled
* `node['opsline-chef-client']['unregister_at_shutdown']`
  it true, setup service to unregister node from chef server on shutdown
* `node['opsline-chef-client']['delete_validation']`
  it true, validation file will be removed


Usage
-----
#### opsline-chef-client::default
Installs `/opt/chef/bin/run_chef_client` script.

If `node['opsline-chef-client']['cron']` is set to `true`, it
configures cron job that executes it configurable number of times per hour.

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

If `node['opsline-chef-client']['unregister_at_shutdown']` is set to `true`,
installs an init script that will execute when node is shutting down.
It will delete node and client objects from chef server.

If `node['opsline-chef-client']['delete_validation']` is set to `true`,
validation key will be removed from the node.

#### opsline-chef-client::datadog
Installs datadog agent and ChefStatus check.

The check will emit `chef.status` metric with the following values:
* 0: OK
* 1: error
* -1: plugin error

#### opsline-chef-client::cron
For compatibility only - uses default recipe.

#### opsline-chef-client::unregister_on_shutdown
For compatibility only - uses default recipe.

#### opsline-chef-client::disable_chef
Disables chef client. When you add this recipe,
chef client will not run anymore.
To enable back, execute `enable_chef` script manually


License and Authors
-------------------
* Author:: Radek Wierzbicki

```text
Copyright 2014, OpsLine, LLC.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
