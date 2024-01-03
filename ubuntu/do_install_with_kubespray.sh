
# ip 환경변수 설정 
echo 'export IP=192.168.35.132' >> ~/.bashrc
source ~/.bashrc

#  선행 작업 1 -> 이거는 인터랙티브한 부분이 있어서 ssh_host_config 먼저 수행  
cd ~


# k8s installation via kubespray

git clone -b release-2.20 https://github.com/kubernetes-sigs/kubespray.git
cd kubespray
pip install -r requirements.txt

echo "export PATH=${HOME}/.local/bin:${PATH}" | sudo tee ${HOME}/.bashrc > /dev/null
export PATH=${HOME}/.local/bin:${PATH}
source ${HOME}/.bashrc

# 공홈에서 만들라는 디랙토리
cp -rfp inventory/sample inventory/mycluster

#클러스터에 포함 시킬 호스트 주소들 입력 ... 아래의 hosts.yml 로 자동 생성됨. 
declare -a IPS=(${IP})
CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}


# use docker container runtime
sed -i "s/docker_version: '20.10'/docker_version: 'latest'/g" roles/container-engine/docker/defaults/main.yml
sed -i "s/docker_containerd_version: 1.6.4/docker_containerd_version: latest/g" roles/download/defaults/main.yml
sed -i "s/container_manager: containerd/container_manager: docker/g" inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
sed -i "s/# container_manager: containerd/container_manager: docker/g" inventory/mycluster/group_vars/all/etcd.yml
sed -i "s/host_architecture }}]/host_architecture }} signed-by=\/etc\/apt\/keyrings\/docker.gpg]/g" roles/container-engine/docker/vars/ubuntu.yml
sed -i "s/# docker_cgroup_driver: systemd/docker_cgroup_driver: systemd/g" inventory/mycluster/group_vars/all/docker.yml
sed -i "s/etcd_deployment_type: host/etcd_deployment_type: docker/g" inventory/mycluster/group_vars/all/etcd.yml
sed -i "s/# docker_storage_options: -s overlay2/docker_storage_options: -s overlay2/g" inventory/mycluster/group_vars/all/docker.yml

# CNI 설정 -> 플라넬 
sed -i "s/kube_proxy_mode: ipvs/kube_proxy_mode: iptables/g" roles/kubespray-defaults/defaults/main.yaml
sed -i "s/kube_proxy_mode: ipvs/kube_proxy_mode: iptables/g" inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml


# enable dashboard / disable dashboard login / change dashboard service as nodeport
sed -i "s/# dashboard_enabled: false/dashboard_enabled: true/g" inventory/mycluster/group_vars/k8s_cluster/addons.yml
sed -i "s/dashboard_skip_login: false/dashboard_skip_login: true/g" roles/kubernetes-apps/ansible/defaults/main.yml
sed -i'' -r -e "/targetPort: 8443/a\  type: NodePort" roles/kubernetes-apps/ansible/templates/dashboard.yml.j2

# enable helm
sed -i "s/helm_enabled: false/helm_enabled: true/g" inventory/mycluster/group_vars/k8s_cluster/addons.yml

# disable nodelocaldns
sed -i "s/enable_nodelocaldns: true/enable_nodelocaldns: false/g" inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml
