# CHANGELOG for opsline-chef-client

## 0.22.0
* unregister from opsworks chef automate (if detected)

## 0.21.0
* adding `disabled_file` attribute
* adding `chef.enabled` datadog metric

# 0.20.0
* Updated to work with logrotate-2.1.0

## 0.19.0
* depend on `datadog` cookbook `>= 2.2.0`
* fixing datadog chef status check error when status file does not exist

## 0.18.0
* adding `datadog` recipe which installs and enables `ChefStatus` plugin
* adding `allowed_runtime`
* adding `status_file` attribute
* refactoring tests; running test on Ubuntu 14.04

## 0.17.0
* fork bomb prevention

## 0.16.0
* adding ability to delete validation certificate (controlled with delete_validation attribute)
* fixing tests

## 0.15.0
* unregister_at_shutdown service will be correctly enabled on RHEL
* unregister_at_shutdown script timeout fix for RHEL

## 0.14.0
* adding check_chef script
* better status reporting from scripts

## 0.13.0
* adding json_attributes_file attribute to run chef client with `-j` option

## 0.12.0
* do better job disabling chef service

## 0.11.0
* unregister service back to init with proper update-rc.d commands
  to register only stop in runlevel 0
* chef log file name as attribute
* cron or cron_d
* logrotate

## 0.10.0
* unregister service switched from init to upstart

## 0.9.0
* unregister service switched from init to upstart

## 0.8.0
* disable/enable scripts will print messages
* unregister script enabled by attribute
* moving cron and unregister code to default (keeping recipes for compatibility)

## 0.7.0
* License change to Apache License
* Adding kitchen CI tests

## 0.6.0
* Updating documentation
* Removing enable_chef recipe (pointless)

## 0.5.0
* Using timeout command in unregister script

## 0.4.0
* Linking enable/disable scripts to /usr/local/bin
* Adding disable_chef and enable_chef recipes

## 0.3.0
* Adding init script to unregister node on shutdown.

## 0.2.0
* Adding enable/disable scripts.

## 0.1.0:
* Initial release of opsline-chef-client.
