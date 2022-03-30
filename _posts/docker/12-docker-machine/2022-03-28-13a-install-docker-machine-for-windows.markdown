---
layout: post
title: "Install docker-machine on Windows"
date: 2022-03-28T05:20:44+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
refs: 
- https://github.com/docker/machine/blob/docs/docs/install-machine.md
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/13a-docker-machine-windows
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Install docker-machine di OS Windows 10/11. Materi yang dibahas diantaranya:

1. Install `docker-machine` binary
2. Install VirtualBox as backend
3. Create and run a Docker host using VirtualBox provider
4. Troubleshooting

Ok langsung aja kita bahas materi yang pertama

## Install `docker-machine` binary

On OS X and Windows, Machine is installed along with other Docker products when you install the Docker Toolbox / Docker Desktop.

Note: in Docker Desktop version 20.xx drop `docker-machine` from bundle, kita bisa install secara terpisah menggunakan package manager

{% highlight powershell %}
choco install docker-machine
{% endhighlight %}

Otherwise, download one of the releases from the [docker/machine release](https://github.com/docker/machine/releases/) page directly.

## Install VirtualBox as backend

Docker machine membutuhkan backend atau driver untuk virtualization, Ada beberapa driver yang kita bisa gunakan yaitu

1. [Virtualbox (`virtualbox`)](https://github.com/docker/machine/tree/master/drivers/virtualbox)
master/drivers/vmwarefusion)
2. [HyperV (`hyperv`)](https://github.com/docker/machine/tree/master/drivers/hyperv)

Yang telah saya test dan juga work well yaitu `virtualbox` jadi kita akan menggunakan VirtualBox ya sebagai drivernya. Untuk menginstall virtualbox di Windows 10/11 kita juga bisa menggunakan Package manager atau download binary exe nya di [official website](https://www.virtualbox.org/wiki/Downloads) Oracle Virtualbox

{% highlight powershell %}
choco install virtualbox
{% endhighlight %}

Jika sudah ter-install pastikan di Virtualbox tersebut dapat membuat vm linux dengan baik. jika tidak nanti docker-machine akan error juga.

## Create and run a Docker host using VirtualBox provider

Machine lets you create Docker hosts on your computer, on cloud providers, and inside your own data center. It creates servers, installs Docker on them, then configures the Docker client to talk to them.

{% highlight powershell %}
docker-machine create -d virtualbox --virtualbox-no-vtx-check default
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker-machine create -d virtualbox --virtualbox-no-vtx-check default
Running pre-create checks...
Creating machine...
(default) Copying C:\Users\dimasm93\.docker\machine\cache\boot2docker.iso to C:\Users\dimasm93\.docker\machine\machines\default\boot2docker.iso...
(default) Creating VirtualBox VM...
(default) Creating SSH key...
(default) Starting the VM...
(default) Check network to re-create if needed...
(default) Windows might ask for the permission to configure a dhcp server. Sometimes, such confirmation window is minimized in the taskbar.
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
To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe env default

➜ ~  docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
default   -        virtualbox   Running   tcp://192.168.99.101:2376           v19.03.12
```

Dengan seperti itu kita sudah bisa membuat docker server yang jalan di atas Virtualbox dengan ip `192.168.99.101`

## Troubleshooting

Docker Machine tries to do the right thing in a variety of scenarios but sometimes things do not go according to plan. Here is a quick troubleshooting guide which may help you to resolve of the issues you may be seeing.

1. `docker-machine` hangs, A common issue with Docker Machine is that it will hang when attempting to start up the virtual machine. Since starting the machine is part of the `create` process, `create` is often where these types of errors show up. A hang could be due to a variety of factors, but the most common suspect is networking. Consider the following:
    1. Are you using a VPN? If so, try disconnecting and see if creation will succeed without the VPN. Some VPN software aggressively controls routes and you may need to manually add the route.
    2. Are you connected to a proxy server, corporate or otherwise? If so, take a look at the `--no-proxy` flag for `env` and at setting environment variables for the created Docker Engine.
    3. Are there a lot of host-only interfaces listed by the command `VBoxManage list hostonlyifs`? If so, this has sometimes been known to cause bugs. Consider removing the ones you are not using (`VBoxManage hostonlyif remove name`) and trying machine creation again.

2. Machine creation errors out before finishing, If you see messages such as `exit status 1` creating machines with VirtualBox, this frequently indicates that there is an issue with VirtualBox itself.