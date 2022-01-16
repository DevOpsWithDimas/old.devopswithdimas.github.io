---
layout: post
title: "Install minikube on Mac (Intel/Apple silicon)"
date: 2022-01-16T14:36:35+07:00
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02a-install-minikube-mac
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas cara install minikube di Mac Os diantaranya:

1. What you’ll need?
2. Installing Container or virtual machine as backend minikube
3. Installing minikube binary

Ok langsung aja kita bahas ke materi yang pertama

## What you’ll need?

Untuk menginstall minikube di Mac OS kita membutuhkan:

1. `2 CPUs` or more
2. `2GB` of free memory
3. `20GB` of free disk space
4. Internet connection
5. Container or virtual machine manager, such as: [Docker](https://www.docker.com/products/docker-desktop), [Parallels](https://www.parallels.com/), [Podman](https://podman.io), [VirtualBox](https://www.virtualbox.org), or [VMware Fusion](https://www.vmware.com/products/fusion/)

Klo saya sendiri disini masih menggunakan Macbook Pro 13" four thunderbold 2017 dengan specification seperti berikut:

![virtualbox]({{ page.image_path | prepend: site.baseurl }}/01-mac-system.png)

1. CPU: Intel core i5 dual core
2. Ram: `8Gb` 
3. Storage: SSD `256GB`

## Installing Container or virtual machine as backend minikube

Untuk Mac yang menggunakan architecture intel kita bisa menggunakan beberapa driver yaitu

1. [Docker]({% post_url docker/01-introduction/2021-04-13-02c-install-on-mac %}) / Podman
2. Virtualbox
3. VMware fusion
4. Parallels

Sedangkan Mac yang menggunakan architecture apple silicon bisa menggunakan beberapa driver yaitu

1. Docker / Podman
2. Parallels

Karena saya menggunakan intell, saya akan menginstal menggunakan Docker dan Virtualbox. 

Untuk proses installasi docker di mac sudah pernah saya bahas di [artikel berikut]({% post_url docker/01-introduction/2021-04-13-02c-install-on-mac %})

Untuk proses installasi Virtualbox, simple kita tinggal download file `dmg` pada official websitenya Oracle Virtualbox [disini](https://www.virtualbox.org/wiki/Downloads) kemudian kita tinggal Open and drag VirtualBox ke folder Application.

Jika sudah terinstall maka tampilannya seperti berikut:

![virtualbox]({{ page.image_path | prepend: site.baseurl }}/02-install-virtualbox.png)

## Installing minikube binary

Untuk install minikube juga kita bisa menggunakan beberapa cara yaitu

1. binary download
2. homebrew

Klo saya lebih suka menggunakan package manager homebrew, jadi pertama buat temen-temen yang belum install [homebrew](https://brew.sh/) bisa install dulu jika sudah kita lanjutkan dengan perintah berikut:

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
➜  ~ minikube version
minikube version: v1.24.0
commit: 76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b
```