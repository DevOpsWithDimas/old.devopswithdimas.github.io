---
layout: post
title: "How to install Docker on Linux CentOS"
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
image_path: /resources/posts/docker/04b-install-linux-centos
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang, bagaimana install Docker di Linux CentOS Platform dengan menggunakan CentOS Repository, Ada pun tahapannya 

1. Setting Selinux
2. Add Repository Docker
3. Install Docker
4. Expose Docker Daemon `http://localhost:2375` without TLS

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

Untuk CentOS pada dasarnya memiliki container platform yang diwariskan dari RedHat Container Platform yaitu [podman](https://podman.io/), tetepi jika mau install Docker kita perlu tambahkan repository seperti berikut:

Kemudian kita tambahkan repository docker-ce untuk centos dengan perintah seperti berikut:

{% gist page.gist "02b-add-repository-docker-centos.bash" %}

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

Setelah kita menambahkan repository, kita install docker-ce package dengan perintah seperti berikut:

{% gist page.gist "02b-instal-docker-ce.bash" %}

Kemudian kita jalankan service dockernya dengan perintah seperti berikut:

```bash
systemctl enable --now docker
```

Ok di tahap ini install docker udah selesai, sekarang kita setting firewald untuk membuka port `2375/tcp` dengan cara berikut:

```bash
# Allows container to container communication, the solution to the problem
firewall-cmd --zone=public --add-masquerade --permanent

# Allow port 2375 expose to outside network
firewall-cmd --zone=public --add-port=2375/tcp --permanent

# reload the firewall
firewall-cmd --reload
```

## Expose Docker Daemon

Dengan kita meng-expose docker-daemon kita akan diijinkan untuk membuat / build image dari external tools seperti 

1. [`maven-dockerfile-plugin`](https://github.com/spotify/dockerfile-maven)
2. dan lain-lain.

Edit file `/lib/systemd/system/docker.service` tambahkan `-H tcp://0.0.0.0:2375` seperti berikut:

{% gist page.gist "docker.service" %}

Setelah itu coba di restart service dockernya dengan perintah berikut:

```sql
systemctl restart docker.service
```