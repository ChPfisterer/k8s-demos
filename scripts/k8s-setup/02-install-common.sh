# To lock the standard user ubuntu
echo "Lock user ubuntu"
sudo passwd -l ubuntu

echo "Update and upgrade"
sudo apt-get update && sudo apt-get upgrade -y

echo "Install Docker"
sudo apt-get install -y docker.io

echo "Setting systemd as cgroup driver"
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo sh -c "echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' >> /etc/apt/sources.list.d/kubernetes.list"

sudo sh -c "curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -"

sudo apt-get update

echo "Install Kubernetes"
sudo apt-get install -y kubeadm=1.19.2-00 kubelet=1.19.2-00 kubectl=1.19.2-00
sudo apt-mark hold kubelet kubeadm kubectl

echo "Enable network bridge"
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system

sudo reboot