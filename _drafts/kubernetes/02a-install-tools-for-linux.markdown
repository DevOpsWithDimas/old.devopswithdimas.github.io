---
layout: post
title: "Install minikube for Linux users"
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
image_path: /resources/posts/kubernetes/02a-install-minikube-linux
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas cara install minikube di Linux menggunakan Ubuntu. Diantaranya:

1. What you’ll need?
2. Installing Container or virtual machine as backend minikube
3. Installing minikube binary
4. Installing kubernetes client
5. Create cluster using Virtualbox driver
6. Create cluster using Docker driver (alternative)

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