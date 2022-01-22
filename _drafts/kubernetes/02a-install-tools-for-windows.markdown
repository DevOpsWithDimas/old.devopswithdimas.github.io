---
layout: post
title: "Install minikube for Windows 11/10 Users"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
- https://minikube.sigs.k8s.io/docs/start/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02a-install-minikube-windows
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas cara install minikube di Windows 10/11. Diantaranya:

1. What you’ll need?
2. Installing Container or virtual machine as backend minikube
3. Installing minikube binary
4. Installing kubernetes client
5. Create cluster using Virtualbox driver
6. Create cluster using Docker driver (alternative apple silicon)

Ok langsung aja kita bahas ke materi yang pertama

## What you’ll need?

Untuk menginstall minikube di Windows 10/11 kita membutuhkan:

1. `2 CPUs` or more
2. `2GB` of free memory
3. `20GB` of free disk space
4. Internet connection
5. Container or virtual machine manager, such as: [Docker](https://www.docker.com/products/docker-desktop), [Podman](https://podman.io), [VirtualBox](https://www.virtualbox.org), or [VMware Player](https://www.vmware.com/products/workstation-player.html)

Klo saya sendiri disini menggunakan Thinkbook 14" dengan specification seperti berikut:

![system-info]({{ page.image_path | prepend: site.baseurl }}/01-system-info.png)

## Installing Container or virtual machine as backend minikube

Untuk Windows 10/11 kita bisa menggunakan beberapa driver yaitu

1. Docker / Podman
2. Virtualbox
3. VMware player

Untuk proses installasi docker di Windows sudah pernah saya bahas di [artikel berikut]({% post_url docker/01-introduction/2021-04-11-02a-install-on-windows10-wls %})

Untuk proses installasi Virtualbox, simple kita tinggal download file `exe` pada official websitenya Oracle Virtualbox [disini](https://www.virtualbox.org/wiki/Downloads) kemudian kita install seperti biasa

Jika sudah terinstall maka tampilannya seperti berikut:

![virtualbox]({{ page.image_path | prepend: site.baseurl }}/02-virtualbox.png)

## Installing minikube binary

Untuk install minikube juga kita bisa menggunakan beberapa cara yaitu

1. binary download
2. chocolatey

Klo saya lebih suka menggunakan package manager Chocolatey, jadi pertama buat temen-temen yang belum install [Chocolatey](https://chocolatey.org/install) bisa install dulu jika sudah kita lanjutkan dengan perintah berikut:

{% highlight bash %}
choco install minikube
{% endhighlight %}

Jika sudah success, coba check di terminal dengan perintah seperti berikut:

{% highlight bash %}
minikube version
{% endhighlight %}

Hasilnya seperti berikut:

```bash
➜ ~  minikube version
minikube version: v1.24.0
commit: 76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b
```

## Installing kubernetes client

Untuk install kubernetes client / kubectl kita bisa menggunakan beberapa cara yaitu 

1. binary download
2. homebrew

Sama seperti sebelumnya kita bisa install menggunakan perintah berikut:

{% highlight bash %}
choco install kubernetes-cli kustomize
{% endhighlight %}

jika dijalankan maka hasilnya seperti berikut:

```bash
➜ ~  kubectl version --client
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.1", GitCommit:"86ec240af8cbd1b60bcc4c03c20da9b98005b92e", GitTreeState:"clean", BuildDate:"2021-12-16T11:41:01Z", GoVersion:"go1.17.5", Compiler:"gc", Platform:"windows/amd64"}
```