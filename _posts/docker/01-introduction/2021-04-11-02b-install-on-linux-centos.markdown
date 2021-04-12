---
layout: post
title: "How to install Docker on Linux CentOS"
date: 2021-04-11T22:16:33+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://stackoverflow.com/a/63067436/6685789
- https://linuxhint.com/install_docker_ce_centos8/
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

{% gist page.gist "02b-install-dependency-docker.bash" %}


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

{% gist page.gist "02b-service-auto-startup.bash" %}

Ok di tahap ini install docker udah selesai, sekarang kita setting firewald untuk membuka port `2375/tcp` dengan cara berikut:

{% gist page.gist "02b-firewall-allow-access-from-outside.bash" %}

## Expose Docker Daemon

Dengan kita meng-expose docker-daemon kita akan di-ijinkan untuk membuat / build image dari external tools seperti 

1. [`maven-dockerfile-plugin`](https://github.com/spotify/dockerfile-maven)
2. dan lain-lain.

Edit file `/lib/systemd/system/docker.service` tambahkan `-H tcp://0.0.0.0:2375` seperti berikut:

{% gist page.gist "docker.service" %}

Setelah itu coba di restart service dockernya dengan perintah berikut:

{% gist page.gist "02b-service-restart.bash" %}

## Execute docker from normal user

Secara default hanya user `root` dan user yang memiliki group `docker` yang bisa meng-execute docker command, jika kita menggunakan normal user kita harus tambahkan user tersebut ke docker group dengan perintah berikut:

{% gist page.gist "02b-add-user-to-docker-user-group.bash" %}

## Testing

Seperti biasa, kita bisa coba test dengan menggunakan perintah seperti berikut:

{% gist page.gist "docker-info.bash" %}

Maka dijalankan maka hasilnya seperti berikut:

```bash
[dimasm93@dev01 ~]$ docker info
Client:
 Debug Mode: false

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 19.03.14
 Storage Driver: overlay2
  Backing Filesystem: xfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 7ad184331fa3e55e52b890ea95e65ba581ae3429
 runc version: dc9208a3303feef5b3839f4323d9beb36df0a9dd
 init version: fec3683
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 4.18.0-240.15.1.el8_3.x86_64
 Operating System: CentOS Linux 8
 OSType: linux
 Architecture: x86_64
 CPUs: 4
 Total Memory: 15.34GiB
 Name: dev01.dimas-maryanto.com
 ID: 5HY3:XYFW:AIWA:XFA6:6YO7:M6BT:5BVK:BCUN:CVUZ:V25A:AHNX:HBXC
 Docker Root Dir: /var/lib/docker
 Debug Mode: true
  File Descriptors: 24
  Goroutines: 38
  System Time: 2021-04-12T08:23:09.210620353+07:00
  EventsListeners: 0
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
```