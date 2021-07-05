# Copyright 2019 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file or at
# https://developers.google.com/open-source/licenses/bsd

service: api
runtime: python27
api_version: 1
threadsafe: no

define(`_VERSION', `syscmd(`echo $_VERSION')')

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

ifdef(`DEV', `
instance_class: F4
automatic_scaling:
  min_idle_instances: 1
  max_instances: 1
  max_pending_latency: 15s
')

handlers:
- url: /prpc/.*
  script: monorailapp.app
  secure: always
- url: /_ah/warmup
  script: monorailapp.app
  login: admin

inbound_services:
ifdef(`PROD', `
- warmup
')
ifdef(`STAGING', `
- warmup
')

libraries:
- name: endpoints
  version: 1.0
- name: grpcio
  version: 1.0.0
- name: MySQLdb
  version: "latest"
- name: ssl  # needed for google.auth.transport
  version: "2.7.11"

includes:
- gae_ts_mon

env_variables:
  VERSION_ID: '_VERSION'

skip_files:
- ^(.*/)?#.*#$
- ^(.*/)?.*~$
- ^(.*/)?.*\.py[co]$
- ^(.*/)?.*/RCS/.*$
- ^(.*/)?\..*$
- node_modules/
- static/
- schema/
- doc/
- tools/
- venv/
