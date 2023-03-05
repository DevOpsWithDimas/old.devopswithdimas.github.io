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
image_path: /resources/posts/kubernetes/02a-install-minikube-mac
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas membuat kubernetes cluster di local/learning environment menggunakan minikube di Mac OS (Apple silicon Based)

1. What you’ll need?
2. Installing Container or virtual machine as backend minikube
3. Installing minikube binary
4. Installing kubernetes client
5. Create cluster using Virtualbox driver
6. Create cluster using Docker driver (alternative apple silicon)

Ok langsung aja kita bahas ke materi yang pertama

<!--more-->

## What you’ll need?

Untuk menginstall minikube di Mac OS kita membutuhkan:

1. `2 CPUs` or more
2. `2GB` of free memory
3. `20GB` of free disk space
4. Internet connection
5. Container or virtual machine manager, such as: [Docker](https://www.docker.com/products/docker-desktop), [Parallels](https://www.parallels.com/), [Podman](https://podman.io), [VirtualBox](https://www.virtualbox.org), or [VMware Fusion](https://www.vmware.com/products/fusion/)

Klo saya sendiri disini masih menggunakan Macbook Pro 13" four thunderbold 2017 dengan specification seperti berikut:

![system properties]({{ page.image_path | prepend: site.baseurl }}/01-mac-system.png)

Untuk Mac yang menggunakan architecture intel kita bisa menggunakan beberapa driver yaitu

1. [Docker]({% post_url docker/01-introduction/2021-04-13-02c-install-on-mac %}) / Podman
2. Virtualbox
3. VMware fusion
4. Parallels
5. Hyperkit

Sedangkan Mac yang menggunakan architecture apple silicon bisa menggunakan beberapa driver yaitu

1. Docker / Podman
2. Parallels

Karena saya menggunakan intel, saya akan menginstal menggunakan Docker dan Virtualbox. 

Untuk proses installasi docker di mac sudah pernah saya bahas di [artikel berikut]({% post_url docker/01-introduction/2021-04-13-02c-install-on-mac %})

Untuk proses installasi Virtualbox, simple kita tinggal download file `dmg` pada official websitenya Oracle Virtualbox [disini](https://www.virtualbox.org/wiki/Downloads) kemudian kita tinggal Open and drag VirtualBox ke folder Application.

Jika sudah terinstall maka tampilannya seperti berikut:

![virtualbox]({{ page.image_path | prepend: site.baseurl }}/02-install-virtualbox.png)