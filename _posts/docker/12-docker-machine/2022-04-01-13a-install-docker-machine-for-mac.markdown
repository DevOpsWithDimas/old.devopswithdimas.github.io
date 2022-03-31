---
layout: post
title: "Install docker-machine on MacOS"
date: 2022-04-01T05:50:03+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://github.com/docker/machine/blob/docs/docs/install-machine.md
- https://stackoverflow.com/a/69743478
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/13a-docker-machine-mac
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Install docker-machine di MacOS dengan architecture processor Intel, unfortunately saat ini karena `docker-machine` sudah deprecated jadi belum ada support untuk Apple silicon tpi tenang nanti kita bahas alternative lainnya ya. Materi yang dibahas kali ini diantaranya:

1. Install docker-machine binary
2. Install VirtualBox as backend
3. Create and run a Docker host using VirtualBox provider
4. Troubleshooting

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Install docker-machine binary

On OS X and Windows, Machine is installed along with other Docker products when you install the Docker Toolbox / Docker Desktop.

Note: in Docker Desktop version 20.xx drop `docker-machine` from bundle, kita bisa install secara terpisah menggunakan package manager

{% highlight bash %}
brew install docker-machine
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```bash
➜  ~ brew install docker-machine
Warning: docker-machine has been deprecated because it has an archived upstream repository!
==> Downloading https://ghcr.io/v2/homebrew/core/docker-machine/manifests/0.16.2
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/docker-machine/blobs/sha256:913
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sh
######################################################################## 100.0%
==> Reinstalling docker-machine
==> Pouring docker-machine--0.16.2.monterey.bottle.tar.gz
==> Caveats
zsh completions have been installed to:
  /usr/local/share/zsh/site-functions

To restart docker-machine after an upgrade:
  brew services restart docker-machine
Or, if you don''t want/need a background service you can just run:
  /usr/local/opt/docker-machine/bin/docker-machine start default
==> Summary
🍺  /usr/local/Cellar/docker-machine/0.16.2: 12 files, 27.4MB
==> Running `brew cleanup docker-machine`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`)

➜  ~ docker-machine -v
docker-machine version 0.16.2, build bd45ab13
```

Otherwise, download one of the releases from the [docker/machine release](https://github.com/docker/machine/releases/) page directly.

{% highlight bash %}
export DOCKER_MACHINE_VERSION=v0.16.2
curl -L https://github.com/docker/machine/releases/download/$DOCKER_MACHINE_VERSION/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
  chmod +x /usr/local/bin/docker-machine
{% endhighlight %}

## Install VirtualBox as backend

Docker machine membutuhkan backend atau driver untuk virtualization, Ada beberapa driver yang kita bisa gunakan yaitu

1. [Virtualbox (`virtualbox`)](https://github.com/docker/machine/tree/master/drivers/virtualbox)
2. [VMWare Fuction (`vmwarefusion`)](https://github.com/docker/machine/tree/master/drivers/vmwarefusion)

ang telah saya test dan juga work well yaitu `virtualbox` jadi kita akan menggunakan VirtualBox ya sebagai drivernya. Untuk menginstall virtualbox di MacOS kita bisa pake package manager seperti `brew`, `macport` dan lain-lain

{% highlight bash %}
brew install virtualbox
{% endhighlight %}

Jika kita jalankan maka hasilnya seperti berikut:

```bash
➜  ~ brew reinstall virtualbox
==> Caveats
virtualbox requires a kernel extension to work.
If the installation fails, retry after you enable it in:
  System Preferences → Security & Privacy → General

For more information, refer to vendor documentation or this Apple Technical Note:
  https://developer.apple.com/library/content/technotes/tn2459/_index.html

==> Downloading https://download.virtualbox.org/virtualbox/6.1.32/VirtualBox-6.1
Already downloaded: /Users/dimasm93/Library/Caches/Homebrew/downloads/27dcc52623cd4b30f7ff19214f02f8a6bdc4514593de31e2fe271f096d788190--VirtualBox-6.1.32-149290-OSX.dmg

==> Running installer for virtualbox; your password may be necessary.
Package installers may write to any location; options such as `--appdir` are ignored.
installer: Package name is Oracle VM VirtualBox
installer: choices changes file '/private/tmp/choices20220401-36013-1y7lv1t.xml' applied
installer: Installing at base path /
installer: The install was successful.
==> Changing ownership of paths required by virtualbox; your password may be nec
🍺  virtualbox was successfully installed!
```

Jika sudah ter-install pastikan di Virtualbox kita berikut Assesibility di menu Setting -> Security & Privasi seperti berikut:

![assesibility]({{ page.image_path | prepend: site.baseurl }}/01-grant-assesibility.png)

Kemudian kita berikut setting Network host-only di virtualboxnya dengan step seperti berikut:

1. Create a `vbox` folder in the `etc` directory with `sudo mkdir /etc/vbox`
2. Create a file `networks.conf` in the `vbox` folder with `sudo touch /etc/vbox/networks.conf`
3. Write inside file `network.conf` with `* 0.0.0.0/0 ::/0`

## Create and run a Docker host using VirtualBox provider

Machine lets you create Docker hosts on your computer, on cloud providers, and inside your own data center. It creates servers, installs Docker on them, then configures the Docker client to talk to them.

{% gist page.gist "13a-run-docker-machine.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜  ~ docker-machine create -d virtualbox default
Running pre-create checks...
Creating machine...
(default) Copying /Users/dimasm93/.docker/machine/cache/boot2docker.iso to /Users/dimasm93/.docker/machine/machines/default/boot2docker.iso...
(default) Creating VirtualBox VM...
(default) Creating SSH key...
(default) Starting the VM...
(default) Check network to re-create if needed...
(default) Found a new host-only adapter: "vboxnet4"
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
➜  ~ docker-machine env default
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.100:2376"
export DOCKER_CERT_PATH="/Users/dimasm93/.docker/machine/machines/default"
export DOCKER_MACHINE_NAME="default"
# Run this command to configure your shell:
# eval $(docker-machine env default)

➜  ~ docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
default   -        virtualbox   Running   tcp://192.168.99.100:2376           v19.03.12

➜  ~ eval $(docker-machine env default)
➜  ~ docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc., v0.8.1)
  compose: Docker Compose (Docker Inc., v2.3.3)
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
 ID: LLT3:F4SJ:NAJP:I5SF:A2PA:JS3Z:G5KJ:EAYU:7XFA:ATDL:V7EJ:FMBB
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

Dengan seperti itu kita sudah bisa membuat docker server yang jalan di atas Virtualbox dengan ip `192.168.99.100`

## Troubleshooting

Docker Machine tries to do the right thing in a variety of scenarios but sometimes things do not go according to plan. Here is a quick troubleshooting guide which may help you to resolve of the issues you may be seeing.

1. `docker-machine` hangs, A common issue with Docker Machine is that it will hang when attempting to start up the virtual machine. Since starting the machine is part of the `create` process, `create` is often where these types of errors show up. A hang could be due to a variety of factors, but the most common suspect is networking. Consider the following:
    1. Are you using a VPN? If so, try disconnecting and see if creation will succeed without the VPN. Some VPN software aggressively controls routes and you may need to manually add the route.
    2. Are you connected to a proxy server, corporate or otherwise? If so, take a look at the `--no-proxy` flag for `env` and at setting environment variables for the created Docker Engine.
    3. Are there a lot of host-only interfaces listed by the command `VBoxManage list hostonlyifs`? If so, this has sometimes been known to cause bugs. Consider removing the ones you are not using (`VBoxManage hostonlyif remove name`) and trying machine creation again.

2. Machine creation errors out before finishing, If you see messages such as `exit status 1` creating machines with VirtualBox, this frequently indicates that there is an issue with VirtualBox itself.