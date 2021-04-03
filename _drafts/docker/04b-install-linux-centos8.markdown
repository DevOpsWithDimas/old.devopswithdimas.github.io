---
layout: post
title: "Install Docker on Linux Centos 8"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://stackoverflow.com/a/63067436/6685789
- https://linuxhint.com/install_docker_ce_centos8/
- https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd
youtube: 
comments: true
image_path: /resources/posts/docker/04b-install-linux-centos8
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Docker di centos 8, belum sepenuhnya support oleh docker.io masih ada beberapa package yang belum compatible seperti versi dari `containerd.io > 1.2.0-3.el7` karena sebetulnya di centos memiliki containerization yang ikut dari turunanya Redhad yaitu [podman](https://podman.io/) dan ada beberapa problem lagi yaitu `firewalld` akan memblock comunication antar container, bagaimana cara menghandlenya. ok sekarang langsung ja kita install.

## Set selinux = `permissive`

Edit file `/etc/selinux/config` ganti `SELINUX=permissive` menjadi seperti berikut:

```config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=permissive
# SELINUXTYPE= can take one of these three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected. 
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
```

Kemudian restart / reboot servernya, setelah itu baru install dependency

## Install Dependency

Sebelum kita install docker-ce package kita install dulu dependencynya seperti berikut:

```bash
dnf install dnf-utils device-mapper-persistent-data lvm2 fuse-overlayfs wget
```

## Add docker-ce repository for centos

Kemudian kita tambahkan repository docker-ce untuk centos dengan perintah seperti berikut:

```bash
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```

hasilnya seperti berikut:

```bash
[root@dev01 ~]# ls /etc/yum.repos.d/docker-ce.repo
/etc/yum.repos.d/docker-ce.repo

[root@dev01 ~]# cat /etc/yum.repos.d/docker-ce.repo
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/centos/7/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/centos/gpg
```

## Install Docker CE

Setelah itu kita [Downloads](https://download.docker.com/linux/centos/7/x86_64/stable/Packages/) dan Install dulu package `containerd.io` dengan perintah berikut:

```bash
dnf install containerd.io-1.2.13-3.2.el7.x86_64
```

Setelah terinstall baru kita, install package `docker-ce`

```bash
dnf install docker-ce docker-ce-cli
```

## Start service docker

Kemudian kita jalankan service dockernya dengan perintah seperti berikut:

```bash
systemctl enable --now docker
```

Ok di tahap ini install docker udah selesai, sekarang kita setting supaya `DNS (Domain Names Server)` bisa dikenali routenya dengan cara disable firewald atau  dengan cara berikut:

```bash
# Allows container to container communication, the solution to the problem
firewall-cmd --zone=public --add-masquerade --permanent

# Allow port 2375 expose to outside network
firewall-cmd --zone=public --add-port=2375/tcp --permanent

# reload the firewall
firewall-cmd --reload
```
