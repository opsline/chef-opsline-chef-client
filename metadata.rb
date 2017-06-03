name             'opsline-chef-client'
maintainer       'Radek Wierzbicki'
maintainer_email 'radek@opsline.com'
license          'All rights reserved'
description      'Helper recipes for chef client'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.22.0'

depends 'cron'
depends 'logrotate'
depends 'datadog', '>= 2.2.0'
