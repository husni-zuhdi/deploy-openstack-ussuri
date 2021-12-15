#!/bin/bash/
echo "Install dependencies"
sudo apt install python3-dev libffi-dev gcc libssl-dev python3-venv
echo "Create adn activate virtual environment"
python3 -m venv /home/ubuntu/kolla-env
source /home/ubuntu/kolla-env/bin/activate
echo "Install python modules"
pip install -U pip
pip install ansible==2.7.16 PyMySQL kolla-ansible==9.0.1
echo "Install kolla-ansible"
sudo mkdir -p /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp -r /home/ubuntu/kolla-env/share/kolla-ansible/etc_examples/kolla /etc/
cp /home/ubuntu/kolla-env/share/kolla-ansible/ansible/inventory/multinode ~/workspace/
cd ~/workspace
echo "Generate kolla password"
kolla-genpwd
echo "Set multinode file in ~/workspace/multinode"
mkdir ~/workspace/backup
sed "5 c\controller" multinode > ~/workspace/backup/multinode1
cp ~/workspace/backup/multinode1 ~/workspace/multinode
sed "15 c\controller" multinode > ~/workspace/backup/multinode2
cp ~/workspace/backup/multinode2 ~/workspace/multinode
sed "19 c\compute" multinode > ~/workspace/backup/multinode3
cp ~/workspace/backup/multinode3 ~/workspace/multinode
sed "22 c\controller" multinode > ~/workspace/backup/multinode4
cp ~/workspace/backup/multinode4 ~/workspace/multinode
sed "30 c\controller" multinode > ~/workspace/backup/multinode5
cp ~/workspace/backup/multinode5 ~/workspace/multinode
# Delete unesecarry lines
sed -e '6d;7d;16d' ~/workspace/multinode
echo "Set globals.yml in /etc/kolla/globals.yml"
mkdir /etc/kolla/backup
sed '31 c\kolla_base_distro: "ubuntu"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml1
cp /etc/kolla/backup/globals.yml1 /etc/kolla/globals.yml
sed '34 c\kolla_install_type: "binary"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml2
cp /etc/kolla/backup/globals.yml2 /etc/kolla/globals.yml
sed '37 c\openstack_release: "ussuri"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml3
cp /etc/kolla/backup/globals.yml3 /etc/kolla/globals.yml
sed '53 c\kolla_internal_vip_address: "172.31.20.0"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml4
cp /etc/kolla/backup/globals.yml4 /etc/kolla/globals.yml
sed '64 c\kolla_external_vip_address: "{{ kolla_internal_vip_address }}"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml5
cp /etc/kolla/backup/globals.yml5 /etc/kolla/globals.yml
sed '124 c\network_interface: "ens5"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml6
cp /etc/kolla/backup/globals.yml6 /etc/kolla/globals.yml
sed '154 c\neutron_external_interface: "ens5"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml7
cp /etc/kolla/backup/globals.yml7 /etc/kolla/globals.yml
sed '158 c\neutron_plugin_agent: "openvswitch"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml8
cp /etc/kolla/backup/globals.yml8 /etc/kolla/globals.yml
sed '275 c\enable_openstack_core: "yes"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml9
cp /etc/kolla/backup/globals.yml9 /etc/kolla/globals.yml
sed '281 c\enable_haproxy: "yes"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml10
cp /etc/kolla/backup/globals.yml10 /etc/kolla/globals.yml
sed '301 c\enable_cinder: "yes"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml11
cp /etc/kolla/backup/globals.yml11 /etc/kolla/globals.yml
sed '373 c\enable_neutron_provider_networks: "yes"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml12
cp /etc/kolla/backup/globals.yml12 /etc/kolla/globals.yml
sed '562 c\nova_compute_virt_type: "kvm"' /etc/kolla/globals.yml > /etc/kolla/backup/globals.yml13
cp /etc/kolla/backup/globals.yml13 /etc/kolla/globals.yml