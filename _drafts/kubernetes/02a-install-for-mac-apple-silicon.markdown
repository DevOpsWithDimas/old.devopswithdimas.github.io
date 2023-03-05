---
layout: post
title: "Install minikube on Mac (Apple silicon Chip)"
lang: k8s
date: 2022-01-16T14:37:35+07:00
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/
- https://formulae.brew.sh/formula/kubernetes-cli
- https://minikube.sigs.k8s.io/docs/start/
- https://formulae.brew.sh/formula/minikube
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02a-install-minikube-mac-arms
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas membuat kubernetes cluster di local/learning environment menggunakan minikube di Mac OS (Apple silicon Based)

1. What you’ll need?
2. Installing Container or virtual machine as backend minikube
3. Installing minikube binary & kubernetes client
4. Create cluster using qemu driver
5. Create cluster using Docker driver (apple silicon)

Ok langsung aja kita bahas ke materi yang pertama

<!--more-->

## What you’ll need?

Untuk membuat sebuah cluster kubernetes di minikube kita membutuhkan specifikasi minimal seperti berikut

1. `2 CPUs` or more
2. `2GB` of free memory
3. `20GB` of free disk space
4. Internet connection

Klo saya sendiri disini masih menggunakan Mac Mini M2 Pro dengan specifikasi seperti berikut

![system properties]({{ page.image_path | prepend: site.baseurl }}/01-mac-system.png)

Driver minikube yang kita bisa gunanakan untuk membuat cluster kubernetes di apple silicon chip based yaitu

1. Docker / Podman
2. [Parallels](https://www.parallels.com/)
3. [qemu](https://www.qemu.org/)

## Installing Container or virtual-machine as backend minikube

Okey setelah beberapa kebutuhan dari system requirement terpenuhi, sekarang kita bisa install container runtime atau virtual-machine sebagai driver dari minikube. 

Untuk temen-temen yang ingin menggunakan driver `docker` bisa install docker-desktop yang version `apple silicon` dari official docker website [disini](https://docs.docker.com/desktop/install/mac-install/)

Untuk temen-temen yang ingin menggunakan driver `qemu` sebagai virtual-machine engine di minikube bisa menggunakan package manager seperti [homebrew](https://brew.sh/) Untuk installasinya menggunakan perintah berikut:

{% highlight bash %}
brew install qemu socket_vmnet
{% endhighlight %}

The QEMU driver has two networking options: `socket_vmnet` and `builtin`. `socket_vmnet` will give you full minikube networking functionality, such as the service and tunnel commands. On the other hand, the `builtin` network is not a dedicated network and therefore commands such as service and tunnel are not available. `socket_vmnet` can be installed via brew or from source

Setelah di install, temen-temen jalankan service `socket_vmnet dengan perintah berikut:

{% highlight bash %}
brew services start socket_vmnet
{% endhighlight %}

Jika outputnya seperti berikut:

```bash
~ » sudo brew services start socket_vmnet
Warning: Taking root:admin ownership of some socket_vmnet paths:
  /opt/homebrew/Cellar/socket_vmnet/1.1.1/bin
  /opt/homebrew/Cellar/socket_vmnet/1.1.1/bin/socket_vmnet
  /opt/homebrew/opt/socket_vmnet
  /opt/homebrew/opt/socket_vmnet/bin
==> Successfully started `socket_vmnet` (label: homebrew.mxcl.socket_vmnet)

~ » sudo brew services info socket_vmnet
socket_vmnet (homebrew.mxcl.socket_vmnet)
Running: ✔
Loaded: ✔
Schedulable: ✘
User: root
PID: 17832
```

Your ready to go. Tapi jiga ada error temen-temen bisa stop servicenya, kemudian uninstall dan coba install dari source-code seperti yang di [dokumentasi berikut](https://minikube.sigs.k8s.io/docs/drivers/qemu/#known-issues)

## Installing minikube & kubernetes client

Untuk install minikube juga kita bisa menggunakan beberapa cara yaitu

1. binary download
2. homebrew

Klo saya lebih suka menggunakan package manager homebrew, sekarang temen-temen bisa install dengan menggunakan perintah berikut:

{% highlight bash %}
brew install minikube
{% endhighlight %}

If which minikube fails after installation via brew, you may have to remove the old minikube links and link the newly installed binary:

{% highlight bash %}
brew unlink minikube
brew link minikube
{% endhighlight %}

Jika sudah success, coba check di terminal dengan perintah seperti berikut:

{% highlight bash %}
minikube version
{% endhighlight %}

Hasilnya seperti berikut:

```bash
~ » minikube version
minikube version: v1.29.0
commit: ddac20b4b34a9c8c857fc602203b6ba2679794d3
```

Untuk installasi kubernetes client, You must use a kubectl version that is within one minor version difference of your cluster. For example, a v1.23 client can communicate with v1.22, v1.23, and v1.24 control planes. Using the latest compatible version of kubectl helps avoid unforeseen issues.

Untuk install kubernetes client / kubectl kita bisa menggunakan beberapa cara yaitu 

1. binary download
2. homebrew

Sama seperti sebelumnya kita bisa install menggunakan homebrew dengan menjalankan perintah berikut:

{% highlight bash %}
brew install kubernetes-cli kustomize
{% endhighlight %}

jika dijalankan maka hasilnya seperti berikut:

```bash
~ » kubectl version --client --output json
{
  "clientVersion": {
    "major": "1",
    "minor": "26",
    "gitVersion": "v1.26.2",
    "gitCommit": "fc04e732bb3e7198d2fa44efa5457c7c6f8c0f5b",
    "gitTreeState": "clean",
    "buildDate": "2023-02-22T13:32:21Z",
    "goVersion": "go1.20.1",
    "compiler": "gc",
    "platform": "darwin/arm64"
  },
  "kustomizeVersion": "v4.5.7"
}
```

## Create cluster using qemu driver

Setelah semua depedency, tools di install, sekarang kita akan membuat kubernetes cluster di minikube dengan menggunakan `qemu` driver. Sekarang kita akan config dulu default value pada `minikube config` command seperti berikut:

{% highlight bash %}
minikube config set kubernetes-version 1.26.0 && \
minikube config set insecure-registry "192.168.88.50:8086" && \
minikube config set container-runtime containerd && \
minikube config set disable-driver-mounts true && \
minikube config set vm-driver qemu2 && \
minikube config set driver qemu2
{% endhighlight %}

Jika dijalankan outputnya seperti berikut:

```bash 
~ » minikube config set kubernetes-version 1.26.0 && \
minikube config set insecure-registry "192.168.88.50:8086" && \
minikube config set container-runtime containerd && \
minikube config set disable-driver-mounts true && \
minikube config set driver qemu2
❗  These changes will take effect upon a minikube delete and then a minikube start
❗  These changes will take effect upon a minikube delete and then a minikube start
❗  These changes will take effect upon a minikube delete and then a minikube start

~ » minikube config view
- driver: qemu2
- insecure-registry: 192.168.88.50:8086
- kubernetes-version: 1.26.0
- container-runtime: containerd
- disable-driver-mounts: true
```

Nah sekarang temen-temen bisa buat clusternya dengan menggunakan perintah `minikube start` seperti berikut:

{% highlight bash %}
minikube start --memory 2G --cpus 2 --nodes 2 --insecure-registry "192.168.88.50:8086"
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
~ » minikube start --memory 2G --cpus 2 --nodes 2 --insecure-registry "192.168.88.50:8086"
😄  minikube v1.29.0 on Darwin 13.2.1 (arm64)
✨  Using the qemu2 driver based on user configuration
🌐  Automatically selected the socket_vmnet network
👍  Starting control plane node minikube in cluster minikube
💾  Downloading Kubernetes v1.26.0 preload ...
    > preloaded-images-k8s-v18-v1...:  357.35 MiB / 357.35 MiB  100.00% 6.40 Mi
🔥  Creating qemu2 VM (CPUs=2, Memory=2048MB, Disk=20000MB) ...
📦  Preparing Kubernetes v1.26.0 on containerd 1.6.15 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring CNI (Container Networking Interface) ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🔎  Verifying Kubernetes components...

👍  Starting worker node minikube-m02 in cluster minikube
🔥  Creating qemu2 VM (CPUs=2, Memory=2048MB, Disk=20000MB) ...
🌐  Found network options:
    ▪ NO_PROXY=192.168.105.19
📦  Preparing Kubernetes v1.26.0 on containerd 1.6.15 ...
    ▪ env NO_PROXY=192.168.105.19
🔎  Verifying Kubernetes components...
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

~ » kubectl get node
NAME           STATUS   ROLES           AGE    VERSION
minikube       Ready    control-plane   105s   v1.26.0
minikube-m02   Ready    <none>          63s    v1.26.0

~ » kubectl get pod -A
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-787d4945fb-4kxjc           1/1     Running   0          101s
kube-system   etcd-minikube                      1/1     Running   0          114s
kube-system   kindnet-4kk2g                      1/1     Running   0          74s
kube-system   kindnet-dk58l                      1/1     Running   0          100s
kube-system   kube-apiserver-minikube            1/1     Running   0          115s
kube-system   kube-controller-manager-minikube   1/1     Running   0          113s
kube-system   kube-proxy-7rpd4                   1/1     Running   0          100s
kube-system   kube-proxy-qxd6m                   1/1     Running   0          74s
kube-system   kube-scheduler-minikube            1/1     Running   0          114s
kube-system   storage-provisioner                1/1     Running   0          113s

~ » kubectl create deploy webapp1 --image nginx:mainline --port 80
deployment.apps/webapp1 created
~ » kubectl create deploy webapp2 --image httpd:latest --port 80
deployment.apps/webapp2 created
~ » kubectl expose deploy/webapp2 --port 80
service/webapp2 exposed
~ » kubectl get pod

~ » kubectl get pod
NAME                       READY   STATUS    RESTARTS   AGE
webapp1-57858cffbf-42cpm   1/1     Running   0          43s
webapp2-cf4d9c9bd-mxbd8    1/1     Running   0          27s

~ » kubectl exec deploy/webapp1 -- curl http://webapp2
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    45  100    45    0     0   7500      0 --:--:-- --:--:-- --:--:--  7500
<html><body><h1>It works!</h1></body></html>
```