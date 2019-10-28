# Packer kube image

Packer templates for kubernetes base OS images

## OS

* Debian 10

## Usage

Clone the repository:

`$ git clone https://github.com/dereknex/packer-kube-image.git && cd packer-kube-image`

Build a machine image from the template in the repository:

`$ packer build  debian.json`

Default username/password: `leo/leo_admin`

## Features

* Disable swap
* Use `containerd` as  CRI runtime
* `kubeadm`, `kubectl`, `kubelet` have installed