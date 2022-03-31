---
layout: post
title: "Install docker-machine on Linux"
date: 2022-04-01T04:41:14+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://github.com/docker/machine/blob/docs/docs/install-machine.md
- https://stackoverflow.com/questions/70281938/docker-machine-unable-to-create-a-machine-on-macos-vboxmanage-returning-e-acces
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/13a-docker-machine-linux
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas Install docker-machine di OS Linux khususnya Ubuntu Desktop. Materi yang dibahas diantaranya:

1. Install docker-machine binary
2. Install VirtualBox as backend
3. Create and run a Docker host using VirtualBox provider
4. Troubleshooting

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Install docker-machine binary

If you want only Docker Machine, you can install the Machine binaries directly by following the instructions in the next section. 

You can find the latest versions of the binaries are on the [docker/machine release page](https://github.com/docker/machine/releases/) on GitHub. To install you need run this command:

{% gist page.gist "13a-install-docker-machine-linux.sh" %}

Jika di jalankan outputnya seperti berikut:

```bash
➜  ~ export DOCKER_MACHINE_VERSION=v0.16.2

➜  ~ curl -L https://github.com/docker/machine/releases/download/$DOCKER_MACHINE_VERSION/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   664  100   664    0     0   2177      0 --:--:-- --:--:-- --:--:--  2169
100 32.6M  100 32.6M    0     0  1951k      0  0:00:17  0:00:17 --:--:-- 1888k

➜  ~ docker-machine -v
docker-machine version 0.16.2, build bd45ab13
```

## Install VirtualBox as backend

Docker machine membutuhkan backend atau driver untuk virtualization, Ada beberapa driver yang kita bisa gunakan yaitu

1. [Virtualbox (`virtualbox`)](https://github.com/docker/machine/tree/master/drivers/virtualbox)
2. [VMware Workstation (`vmware`)](https://github.com/machine-drivers/docker-machine-driver-vmware)

Yang telah saya test dan juga work well yaitu `virtualbox` jadi kita akan menggunakan VirtualBox ya sebagai drivernya. Untuk menginstall Virtualbox kita bisa Download binary dari [official dokumentasi](https://www.virtualbox.org/wiki/Linux_Downloads) Virtualbox kemudian kita install sesuai dengan platform. Karena saya menggunakan Ubuntu Desktop `21.04` maka kita bisa menggunakan perintah seperti berikut:

{% highlight bash %}
dpkg -i virtualbox-xxx.xxx_Ubuntu_eoan_xxxx.deb
{% endhighlight %}

Setelah kita install kita perlu make sure, Virtualbox bisa menjalankan vm. Silahkan temen-temen buat saja 1 vm pake os Linux distronya boleh bebas. Jika ada problem seperti berikut:

```bash
Error creating machine: Error in driver during machine creation: Error setting up host only network on machine start: /usr/local/bin/VBoxManage hostonlyif ipconfig vboxnet0 --ip 192.168.99.1 --netmask 255.255.255.0 failed:
```

Solusinya coba 

1. find all the "host-only ethernet adapters" with `VBoxManage list hostonlyifs`
2. Remove the orphaned ones with `VBoxManage hostonlyif remove <networkName>`
3. Create a `vbox` folder in the `etc` directory with `sudo mkdir /etc/vbox`
4. Create a file `networks.conf` in the `vbox` folder with `sudo touch /etc/vbox/networks.conf`
5. Write inside file `network.conf` with `* 0.0.0.0/0 ::/0`

## Create and run a Docker host using VirtualBox provider

Machine lets you create Docker hosts on your computer, on cloud providers, and inside your own data center. It creates servers, installs Docker on them, then configures the Docker client to talk to them.

{% gist page.gist "13a-run-docker-machine.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜  ~ docker-machine create -d virtualbox --virtualbox-no-vtx-check default
Running pre-create checks...
Creating machine...
(default) Copying /home/dimasm93/.docker/machine/cache/boot2docker.iso to /home/dimasm93/.docker/machine/machines/default/boot2docker.iso...
(default) Creating VirtualBox VM...
(default) Creating SSH key...
(default) Starting the VM...
(default) Check network to re-create if needed...
(default) Waiting for an IP...
Waiting for machine to be running, this may take a few minutes...
Detecting operating system of created instance...
Waiting for SSH to be available...
Detecting the provisioner...
Provisioning with boot2docker...
Copying certs to the local machine directory...
Copying certs to the remote machine...
Setting Docker configuration on the remote daemon...
Checking connection to Docker...
Docker is up and running!
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env default

➜  ~ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
default   -        virtualbox   Running   tcp://192.168.99.101:2376           v19.03.12

➜  ~ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.101:2376"
export DOCKER_CERT_PATH="/home/dimasm93/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell: 
# eval $(docker-machine env default)

➜  ~ eval $(docker-machine env default)
➜  ~ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Docker Buildx (Docker Inc., v0.8.1-docker)
  scan: Docker Scan (Docker Inc., v0.17.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 19.03.12
 Storage Driver: overlay2
  Backing Filesystem: extfs
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
 Kernel Version: 4.19.130-boot2docker
 Operating System: Boot2Docker 19.03.12 (TCL 10.1)
 OSType: linux
 Architecture: x86_64
 CPUs: 1
 Total Memory: 985.4MiB
 Name: default
 ID: 5UNH:E23Y:NYJI:Z2F4:RVSK:P5OP:YZVI:7U5V:NNOU:4QU6:QXCB:YOQY
 Docker Root Dir: /mnt/sda1/var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
  provider=virtualbox
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
 Product License: Community Engine
```

Dengan seperti itu kita sudah bisa membuat docker server yang jalan di atas Virtualbox dengan ip `192.168.99.101`

## Troubleshooting

Docker Machine tries to do the right thing in a variety of scenarios but sometimes things do not go according to plan. Here is a quick troubleshooting guide which may help you to resolve of the issues you may be seeing.

1. `docker-machine` hangs, A common issue with Docker Machine is that it will hang when attempting to start up the virtual machine. Since starting the machine is part of the `create` process, `create` is often where these types of errors show up. A hang could be due to a variety of factors, but the most common suspect is networking. Consider the following:
    1. Are you using a VPN? If so, try disconnecting and see if creation will succeed without the VPN. Some VPN software aggressively controls routes and you may need to manually add the route.
    2. Are you connected to a proxy server, corporate or otherwise? If so, take a look at the `--no-proxy` flag for `env` and at setting environment variables for the created Docker Engine.
    3. Are there a lot of host-only interfaces listed by the command `VBoxManage list hostonlyifs`? If so, this has sometimes been known to cause bugs. Consider removing the ones you are not using (`VBoxManage hostonlyif remove name`) and trying machine creation again.

2. Machine creation errors out before finishing, If you see messages such as `exit status 1` creating machines with VirtualBox, this frequently indicates that there is an issue with VirtualBox itself.