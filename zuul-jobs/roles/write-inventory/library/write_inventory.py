# Copyright 2018 Red Hat, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

import json

from ansible.module_utils.basic import AnsibleModule

# The list of variables we might include
VARS = [
    'ansible_python_interpreter',
    'ansible_connection',
    'ansible_host',
    'ansible_port',
    'ansible_user'
]


def run(dest, hostvars, groups, include, exclude, additional, per_host):
    children = {}
    for group, hostnames in groups.items():
        if group == 'all' or group == 'ungrouped':
            continue
        children[group] = {}
        children[group]['hosts'] = {}
        for host in hostnames:
            children[group]['hosts'][host] = None

    out_all = {}
    out = {
        'all': {
            'children': children,
            'hosts': out_all
        }
    }
    for host, hvars in hostvars.items():
        d = {}
        for v in VARS:
            if v not in hvars:
                continue
            if include is not None:
                if v not in include:
                    continue
            if exclude is not None:
                if v in exclude:
                    continue
            d[v] = hvars[v]
        out_all[host] = d
        if additional:
            for new_var_name, old_var_name in additional.items():
                old_var = hvars
                for part in old_var_name.split('.'):
                    old_var = old_var.get(part)
                    if old_var is None:
                        break
                else:
                    d[new_var_name] = old_var
        if per_host:
            if host in per_host:
                d.update(per_host[host])

    with open(dest, 'w') as f:
        f.write(json.dumps(out))


def ansible_main():
    module = AnsibleModule(
        argument_spec=dict(
            dest=dict(required=True, type='path'),
            hostvars=dict(required=True, type='raw'),
            groups=dict(required=True, type='raw'),
            include_hostvars=dict(type='list'),
            exclude_hostvars=dict(type='list'),
            additional_hostvars=dict(type='raw'),
            per_host_hostvars=dict(type='raw'),
        )
    )

    p = module.params

    dest = p.get('dest')
    hostvars = p.get('hostvars')
    groups = p.get('groups')
    include = p.get('include_hostvars')
    exclude = p.get('exclude_hostvars')
    additional = p.get('additional_hostvars', {})
    per_host = p.get('per_host_hostvars', {})

    run(dest, hostvars, groups, include, exclude, additional, per_host)

    module.exit_json(changed=True)


if __name__ == '__main__':
    ansible_main()
