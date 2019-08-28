PACKAGES="
curl
dnsutils
ntp
sudo
apt-transport-https
ca-certificates
curl
gnupg2
software-properties-common
"
apt -y install $PACKAGES

cat > /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Setup required sysctl params, these persist across reboots.
cat > /etc/sysctl.d/99-kubernetes-cri.conf <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update

apt-get install -y  containerd.io kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
# Configure containerd
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
sed -i -e 's/systemd_cgroup = false/systemd_cgroup = true/g' /etc/containerd/config.toml
echo 'KUBELET_EXTRA_ARGS=--cgroup-driver=systemd' > /etc/default/kubelet
