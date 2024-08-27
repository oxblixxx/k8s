Upload logs to a static webserver

This uploads logs to a static server using SSH.  The server must have
been previously added to the inventory; this can be done with the
:zuul:role:`add-fileserver` role; see that role's documentation for a
description of the site_logs secret in this example post-run playbook:

.. code-block:: yaml

   - hosts: localhost
     roles:
       - role: add-fileserver
         fileserver: "{{ site_logs }}"

   - hosts: "{{ site_logs.fqdn }}"
     gather_facts: False
     roles:
       - role: upload-logs
         zuul_log_url: "http://logs.example.org"

**Role Variables**

.. zuul:rolevar:: zuul_log_url

   Base URL where logs are to be found.

.. zuul:rolevar:: zuul_logserver_root
   :default: /srv/static/logs

   The root path to the logs on the logserver.

.. zuul:rolevar:: zuul_log_compress
   :default: false

   When enabled, the console logs Zuul produces will be compressed
   before uploading. You may need additional configuration for your web
   server to view these files.

.. zuul:rolevar:: zuul_log_verbose
   :default: false

   The synchronize task in this role outputs a lot of information.  By
   default, no_log is set to avoid overwhelming a reader of the logs.
   Set this to true to disable that behavior if it becomes necessary
   to debug this role.

.. zuul:rolevar:: zuul_site_upload_logs
   :default: true

   Controls when logs are uploaded. true, the default, means always upload
   logs. false means never upload logs. 'failure' means to only upload logs
   when the job has failed.

   .. note:: Intended to be set by admins via site-variables.

.. zuul:rolevar:: zuul_log_path_shard_build
   :default: False

   This var is consumed by set-zuul-log-path-fact which upload-logs
   calls into. If you set this you will get log paths prefixed with the
   first three characters of the build uuid. This will improve log file
   sharding.

   More details can be found at
   :zuul:rolevar:`set-zuul-log-path-fact.zuul_log_path_shard_build`.
