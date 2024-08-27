This file setup k8s using the open stack module.
Firstly, use the initial_setup script to setup needed files on the master machine.
copy the keys to the authorized keys on all nodes
```sh
ansible all -m ping -i inventory.yaml
```
