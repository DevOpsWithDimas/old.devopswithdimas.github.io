---
layout: post
title: "How to install Docker on Mac OS"
date: 2021-04-13T04:49:21+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/docker-for-mac/install/
- https://docs.docker.com/docker-for-mac/apple-m1/
youtube: 
comments: true
image_path: /resources/posts/docker/02c-install-mac
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini, kita akan membahas bagaimana cara install Docker di MacOS. Adapun step by stepnya seperti berikut:

1. Download Docker Desktop
2. Installing
3. Configure

## Donwloading Docker Desktop

Untuk download temen-temen bisa ke website [official docker](https://hub.docker.com/editions/community/docker-ce-desktop-mac/)

1. Untuk Intel based [download disini](https://docs.docker.com/docker-for-mac/install/)
2. Untuk ARM based (Apple M1) [download disini](https://docs.docker.com/docker-for-mac/apple-m1/)

Ok setelah di download, sekarang kita akan install Docker Desktop dengan Intel based

## Install Docker Desktop

Docker Desktop adalah package dari `Docker Engine`, `Docker` CLI client, `Docker Compose`, `Notary`, `Kubernetes` dan `Credential Helper`. Jadi dengan docker desktop ini kita sudah dikasih tools yang lengkap untuk melakukan operasi pada Docker. Ok sekarang kita install

1. Untuk install di mac, Intel based caranya _straightforward_ dengan Double click `Docker.dmg` kemudian akan muncul dialog seperti berikut
  ![setup]({{ page.image_path | prepend: site.baseurl }}/01-mount.png)
2. Kemudian, kita tinggal pindahkan `Docker Desktop` ke folder `Applications` seperti berikut:
  ![copy-application]({{ page.image_path | prepend: site.baseurl }}/02-copy-application.png)
3. Lalu, akan muncul Security & Privacy Settings kita allow aja dengan input password pada mac kita seperti berikut:
  ![security-privacy]({{ page.image_path | prepend: site.baseurl }}/04-security-allow.png)
4. Finally, docker has been installed. Sekarang buka aplikasi `Docker Desktop` dari laucher dan nanti akan muncul pada topbar seperti berikut:
  ![docker-daemon]({{ page.image_path | prepend: site.baseurl }}/05-docker-topbar.png)

Setelah di install, kita akan configure setting seperti Autoload Startup, Resources, Docker Engine dan lain-lain.

## Configure

Untuk configure, disini saya menggunakan Macbook Pro 13 (2017) which is specificationnya `2 Core, 4 Thread Proccessor`, `8 GB Ram` dan `256 GB SSD` karena specifikasinya lumayan terbatas saya limit penggunaan virtualizationnya dan juga saya mau dockernya diload ketika laptop di hidupkan, berikut adalah configurasinya:

1. Buka `Docker Dashboard`, kemudian pilih `Preferences -> General`. Settingnya seperti berikut:
  ![general-settings]({{ page.image_path | prepend: site.baseurl }}/06-docker-general-settings.png)
2. Selanjutnya, kita limit resourcenya dengan settings seperti berikut pada `Preferences -> Resources -> Advances`:
  ![resources-settings]({{ page.image_path | prepend: site.baseurl }}/07-docker-resource-settings.png)
3. Dan yang terakhir, berikut adalah setting docker daemon pada tab `Preferences -> Docker Engine`:
  ![daemon-settings]({{ page.image_path | prepend: site.baseurl }}/08-docker-engine-settings.png)

Setelah itu, click `Apply & Restart`. Tahap selanjutnya kita test dengan perintah berikut pada Terminal

{% gist page.gist "docker-info.bash" %}

Maka jika di jalankan hasilnya seperti berikut:

```bash
➜  ~ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Build with BuildKit (Docker Inc., v0.5.1-docker)
  scan: Docker Scan (Docker Inc., v0.6.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.5
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: runc io.containerd.runc.v2 io.containerd.runtime.v1.linux
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 05f951a3781f4f2c1911b05e61c160e9c30eaa8e
 runc version: 12644e614e25b05da6fd08a38ffa0cfe1903fdec
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 5.10.25-linuxkit
 Operating System: Docker Desktop
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 1.942GiB
 Name: docker-desktop
 ID: 3O27:U7CY:ZFT7:MKCI:X7A4:AP6L:K5XP:ZIIH:XC7J:JAG3:ZPWS:A6BC
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 HTTP Proxy: http.docker.internal:3128
 HTTPS Proxy: http.docker.internal:3128
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
```

Dengan begitu, yang telah kita install & configure sudah betul, dan berjalan dengan baik.