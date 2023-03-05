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
5. Create cluster using Virtualbox driver
6. Create cluster using Docker driver (alternative apple silicon)

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
