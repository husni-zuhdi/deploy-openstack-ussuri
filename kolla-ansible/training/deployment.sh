#!/bin/bash
cd ~/workspace
ansible all -i multinode -m ping
kolla-ansible -i multinode bootstrap-servers
kolla-ansible -i multinode prechecks
kolla-ansible -i multinode deploy
kolla-ansible -i multinode post-deploy