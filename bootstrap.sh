#!/bin/bash

apt-get update
apt-get install curl vim apt-transport-https git gnupg -y

echo -n "
192.168.20.10     k8s-master1.local k8s-master1
192.168.20.21     k8s-worker1.local k8s-worker1
192.168.20.22     k8s-worker2.local k8s-worker2
192.168.20.23     k8s-worker3.local k8s-worker3
192.168.20.24     k8s-worker4.local k8s-worker4
192.168.20.25     k8s-worker5.local k8s-worker5" >> /etc/hosts;


# Загружаем дополнительные модули ядра
echo "
br_netfilter
overlay
" > /etc/modules-load.d/k8s.conf
modprobe br_netfilter && modprobe overlay


echo -n "
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
" >/etc/sysctl.d/k8s.conf 
sysctl --system

# Установка Докера
echo "-------- Install Docker ---------"
apt-get install docker docker.io -y
systemctl enable docker

cat >/etc/docker/daemon.json<<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF
systemctl restart docker


# Установка Kubernetes
echo "-------- Install Kubernetes -------"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

echo -n "
deb https://apt.kubernetes.io/ kubernetes-xenial main
" >/etc/apt/sources.list.d/kubernetes.list
sysctl --system

apt-get update
apt-get install kubelet kubeadm kubectl -y

apt-mark hold kubelet kubeadm kubectl
