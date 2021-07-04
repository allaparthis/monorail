# Copyright 2016 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file or at
# https://developers.google.com/open-source/licenses/bsd

service: besearch
runtime: python27
api_version: 1
threadsafe: no

ifdef(`PROD', `
instance_class: F4
automatic_scaling:
  min_idle_instances: 1
  max_instances: 1
  max_pending_latency: 15s
')

ifdef(`STAGING', `
instance_class: F4
automatic_scaling:
  min_idle_instances: 1
  max_instances: 1
  max_pending_latency: 15s
')

ifdef(`DEMO', `
instance_class: F4
')

handlers:
- url: /_ah/warmup
  script: monorailapp.app
  login: admin

- url: /_backend/.*
  script: monorailapp.app

- url: /_ah/start
  script: monorailapp.app
  login: admin

- url: /_ah/stop
  script: monorailapp.app
  login: admin

ifdef(`PROD', `
inbound_services:
- warmup
')
ifdef(`STAGING', `
inbound_services:
- warmup
')

libraries:
- name: endpoints
  version: 1.0
- name: MySQLdb
  version: "latest"
- name: django
  version: 1.11

skip_files:
- ^(.*/)?#.*#$
- ^(.*/)?.*~$
- ^(.*/)?.*\.py[co]$
- ^(.*/)?.*/RCS/.*$
- ^(.*/)?\..*$
- node_modules/
