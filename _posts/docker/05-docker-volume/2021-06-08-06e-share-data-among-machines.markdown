---
layout: post
title: "Share data among machines"
date: 2021-06-08T05:18:06+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Volume
refs: 
- https://docs.docker.com/storage/volumes/
- https://github.com/vieux/docker-volume-sshfs
youtube: nIBzQZ4Vqqs
comments: true
catalog_key: docker-volume
image_path: /resources/posts/docker/06e-share-data-among-machines
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang share data berbeda machine. 

When building fault-tolerant applications, you might need to configure multiple replicas of the same service to have access to the same files.

![multiple-apps](https://docs.docker.com/storage/images/volumes-shared-storage.svg)

There are several ways to achieve this when developing your applications. One is to add logic to your application to store files on a cloud object storage system like Amazon S3. Another is to create volumes with a driver that supports writing files to an external storage system like NFS or Amazon S3.

Volume drivers allow you to abstract the underlying storage system from the application logic. For example, if your services use a volume with an NFS driver, you can update the services to use a different driver, as an example to store data in the cloud, without changing the application logic.

Ada beberapa driver yang kita bisa gunakan untuk share data among machine, diantaranya:

1. SSH
2. NFSv3
3. NFSv4
4. CIFS/Samba
5. dan beberapa plugin network lainnya.

This example assumes that you have two nodes, the first of which is a Docker host and can connect to the second using SSH. On the Docker host, install the `vieux/sshfs` plugin:

{% gist page.gist "06e-install-plugin.bash" %}

Create a volume using a volume driver, This example specifies a SSH password, but if the two hosts have shared keys configured, you can omit the password. Each volume driver may have zero or more configurable options, each of which is specified using an `-o` flag.

{% gist page.gist "06e-create-volume.bash" %}

Start a container which creates a volume using a volume driver. This example specifies a SSH password, but if the two hosts have shared keys configured, you can omit the password. Each volume driver may have zero or more configurable options. If the volume driver requires you to pass options, you must use the `--mount` flag to mount the volume, rather than `-v`.

{% gist page.gist "06e-start-container.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```bash
# login to your server volume
➜ ~  ssh dimasm93@192.168.88.100
dimasm93@192.168.88.100\'s password:

Last failed login: Tue Jun  8 04:59:33 WIB 2021 from 192.168.88.254 on ssh:notty
There was 1 failed login attempt since the last successful login.
Last login: Tue Jun  8 04:16:17 2021 from 192.168.88.254

➜  ~ ifconfig
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.88.100  netmask 255.255.255.0  broadcast 192.168.88.255
        inet6 fe80::670f:5a7e:d0f6:e5c7  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:13:91:87  txqueuelen 1000  (Ethernet)
        RX packets 6092  bytes 1106981 (1.0 MiB)
        RX errors 0  dropped 54  overruns 0  frame 0
        TX packets 2667  bytes 304464 (297.3 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

➜  ~ cat /etc/redhat-release
CentOS Linux release 7.8.2003 (Core)

➜  ~ sudo -i
[sudo] password for dimasm93:

[root@docker-vm ~]# useradd --create-home --password testing test
[root@docker-vm ~]# su test
[test@docker-vm ~]$ 

[root@docker-vm ~]# logout

# back to your host
dimasm93@MSI-z390-pro:~$ docker plugin install --grant-all-permissions vieux/sshfs DEBUG=1
latest: Pulling from vieux/sshfs
Digest: sha256:1d3c3e42c12138da5ef7873b97f7f32cf99fb6edde75fa4f0bcf9ed277855811
52d435ada6a4: Complete
Installed plugin vieux/sshfs

dimasm93@MSI-z390-pro:~$ docker plugin ls
ID             NAME                 DESCRIPTION               ENABLED
a9d3673157f2   vieux/sshfs:latest   sshFS plugin for Docker   true

dimasm93@MSI-z390-pro:~$ docker volume create --driver vieux/sshfs \
>   -o sshcmd=test@192.168.88.100:/home/test \
>   -o port=22 \
>   -o password=testing \
>   sshvolume
sshvolume

dimasm93@MSI-z390-pro:~$ docker volume ls
DRIVER               VOLUME NAME
vieux/sshfs:latest   sshvolume

dimasm93@MSI-z390-pro:~$ docker run --rm -it -u root --workdir /root \
>   --mount type=volume,volume-driver=vieux/sshfs,src=sshvolume,target=/root \
>   alpine ash
~ # ls
~ # echo "Hai ini dari docker container alpine" > halo.txt
~ # ls
halo.txt
~ # exit

## login ke host volume
dimasm93@MSI-z390-pro:~$ ssh test@192.168.88.100
test@192.168.88.100\'s password:
Last login: Tue Jun  8 05:08:37 2021

[test@docker-vm ~]$ ls
halo.txt

[test@docker-vm ~]$ cat halo.txt
Hai ini dari docker container alpine

[test@docker-vm ~]$ ll
total 4
-rw-r--r--. 1 test test 37 Jun  8 05:13 halo.txt
```