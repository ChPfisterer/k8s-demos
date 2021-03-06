echo "Initialize Kubernetes"
sudo kubeadm init --kubernetes-version 1.19.2 --pod-network-cidr 10.244.0.0/16 | sudo tee /k8s-setup/config.out
sudo tail -2 /k8s-setup/config.out | sudo tee /k8s-setup/join.txt

echo "Create directory .kube"
mkdir -p $HOME/.kube

echo "Copy Kubernetes configuration"
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sudo chown $(id -u):$(id -g) $HOME/.kube/config

#echo "Install calico network interface"
#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

echo "Install flannel network interface"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.13.0/Documentation/kube-flannel.yml
#curl -sSL https://raw.githubusercontent.com/coreos/flannel/v0.13.0/Documentation/kube-flannel.yml | kubectl apply -f -

kubectl get nodes
