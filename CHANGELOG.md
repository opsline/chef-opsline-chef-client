# CHANGELOG for opsline-chef-client

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
