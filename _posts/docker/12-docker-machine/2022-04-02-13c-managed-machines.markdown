---
layout: post
title: "Managing a machines in docker-machine"
date: 2022-04-02T13:19:04+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://github.com/docker/machine/blob/docs/docs/drivers/virtualbox.md
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/12c-manage-virtual-machines
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang manage a machines in docker-machine. Seperti biasa kita akan bagi-bagi menjadi beberapa bagian yaitu

1. Start and stop machines
2. Create and drop machines
3. Interaction with a machine

Ok yuk langsung aja kita bahas materi yang pertama

<!--more-->

## Start and stop machines

If you are finished using a host for the time being, you can stop it with `docker-machine stop` and later start it again with `docker-machine start`.

{% highlight bash %}
docker-machine stop default
docker-machine start default
{% endhighlight %}

## Create and drop machines

Create machines locally using VirtualBox. This driver requires VirtualBox `5+` to be installed on your host. Using VirtualBox `4.3+` should work but will give you a warning. Older versions will refuse to work.

{% highlight bash %}
docker-machine create --driver=virtualbox vbox-test
{% endhighlight %}

In another way, you can customize your machine like memory, cpus count, insecure-registries etc. The options:

-   `--virtualbox-memory`: Size of memory for the host in MB.
-   `--virtualbox-cpu-count`: Number of CPUs to use to create the VM. Defaults to single CPU.
-   `--virtualbox-disk-size`: Size of disk for the host in MB.
-   `--virtualbox-no-vtx-check`: Disable checking for the availability of hardware virtualization before the vm is started

For more detail you can see at documentation:

{% highlight bash %}
docker-machine create --help
{% endhighlight %}

Jika di jalankan seperti berikut:

```powershell
➜ ~  docker-machine create -h
Usage: docker-machine create [OPTIONS] [arg...]

Create a machine

Description:
   Run 'C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe create --driver name --help' to include the create flags for that driver in the help text.

Options:

   --driver, -d "virtualbox"                                                                         Driver to create machine with. [$MACHINE_DRIVER]
   --engine-env [--engine-env option --engine-env option]                                            Specify environment variables to set in the engine
   --engine-insecure-registry [--engine-insecure-registry option --engine-insecure-registry option]  Specify insecure registries to allow with the created engine
   --engine-install-url "https://get.docker.com"                                                     Custom URL to use for engine installation [$MACHINE_DOCKER_INSTALL_URL]
   --engine-label [--engine-label option --engine-label option]                                      Specify labels for the created engine
   --engine-opt [--engine-opt option --engine-opt option]                                            Specify arbitrary flags to include with the created engine in the form flag=value
   --engine-registry-mirror [--engine-registry-mirror option --engine-registry-mirror option]        Specify registry mirrors to use [$ENGINE_REGISTRY_MIRROR]
   --engine-storage-driver                                                                           Specify a storage driver to use with the engine
   --swarm                                                                                           Configure Machine to join a Swarm cluster
   --swarm-addr                                                                                      addr to advertise for Swarm (default: detect and use the machine IP)
   --swarm-discovery                                                                                 Discovery service to use with Swarm
   --swarm-experimental                                                                              Enable Swarm experimental features
   --swarm-host "tcp://0.0.0.0:3376"                                                                 ip/socket to listen on for Swarm master
   --swarm-image "swarm:latest"                                                                      Specify Docker image to use for Swarm [$MACHINE_SWARM_IMAGE]
   --swarm-join-opt [--swarm-join-opt option --swarm-join-opt option]                                Define arbitrary flags for Swarm join
   --swarm-master                                                                                    Configure Machine to be a Swarm master
   --swarm-opt [--swarm-opt option --swarm-opt option]                                               Define arbitrary flags for Swarm master
   --swarm-strategy "spread"                                                                         Define a default scheduling strategy for Swarm
   --tls-san [--tls-san option --tls-san option]                                                     Support extra SANs for TLS certs
   --virtualbox-boot2docker-url                                                                      The URL of the boot2docker image. Defaults to the latest available version [$VIRTUALBOX_BOOT2DOCKER_URL]
   --virtualbox-cpu-count "1"                                                                        number of CPUs for the machine (-1 to use the number of CPUs available) [$VIRTUALBOX_CPU_COUNT]
   --virtualbox-disk-size "20000"                                                                    Size of disk for host in MB [$VIRTUALBOX_DISK_SIZE]
   --virtualbox-host-dns-resolver                                                                    Use the host DNS resolver [$VIRTUALBOX_HOST_DNS_RESOLVER]
   --virtualbox-hostonly-cidr "192.168.99.1/24"                                                      Specify the Host Only CIDR [$VIRTUALBOX_HOSTONLY_CIDR]
   --virtualbox-hostonly-nicpromisc "deny"                                                           Specify the Host Only Network Adapter Promiscuous Mode [$VIRTUALBOX_HOSTONLY_NIC_PROMISC]
   --virtualbox-hostonly-nictype "82540EM"                                                           Specify the Host Only Network Adapter Type [$VIRTUALBOX_HOSTONLY_NIC_TYPE]
   --virtualbox-hostonly-no-dhcp                                                                     Disable the Host Only DHCP Server [$VIRTUALBOX_HOSTONLY_NO_DHCP]
   --virtualbox-import-boot2docker-vm                                                                The name of a Boot2Docker VM to import [$VIRTUALBOX_BOOT2DOCKER_IMPORT_VM]
   --virtualbox-memory "1024"                                                                        Size of memory for host in MB [$VIRTUALBOX_MEMORY_SIZE]
   --virtualbox-nat-nictype "82540EM"                                                                Specify the Network Adapter Type [$VIRTUALBOX_NAT_NICTYPE]
   --virtualbox-no-dns-proxy                                                                         Disable proxying all DNS requests to the host [$VIRTUALBOX_NO_DNS_PROXY]
   --virtualbox-no-share                                                                             Disable the mount of your home directory [$VIRTUALBOX_NO_SHARE]
   --virtualbox-no-vtx-check                                                                         Disable checking for the availability of hardware virtualization before the vm is started [$VIRTUALBOX_NO_VTX_CHECK]
   --virtualbox-share-folder                                                                         Mount the specified directory instead of the default home location. Format: dir:name [$VIRTUALBOX_SHARE_FOLDER]
   --virtualbox-ui-type "headless"                                                                   Specify the UI Type: (gui|sdl|headless|separate) [$VIRTUALBOX_UI_TYPE]
```

Selain kita bisa membuat machine, setelah kita gunakan kita juga bisa hapus machinenya dengan menggunakan perintah 

{% highlight bash %}
docker-machine rm -y <machine-name> ...
{% endhighlight %}

## Interaction with a machine

Untuk berinteraksi dengan machine dalam docker-machine, ada beberapa command di antaranya:

1. `ls`, List machines
2. `inspect`, information about a machine as JSON.
3. `ip`, Get the IP address of one or more machines.
4. `env`, Set environment variables to dictate that `docker` should run a command against a particular machine.
5. `active`, See which machine is "active" (a machine is considered active if the `DOCKER_HOST` environment variable points to it).
6. `ssh`, Log into or run a command on a machine using SSH.
7. `scp`, Copy files from your local host to a machine, from machine to machine, or from a machine to your local host using `scp`.
8. `kill`, Kill (abruptly force stop) a machine
9. `mount`, Mount or unmount a directory from a machine with SSHFS.

Berikut contoh penggunaanya:

```powershell
➜ ~  docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
default   -        virtualbox   Running   tcp://192.168.99.102:2376           v19.03.12

➜ ~ ✗  docker-machine env default
$Env:DOCKER_TLS_VERIFY = "1"
$Env:DOCKER_HOST = "tcp://192.168.99.102:2376"
$Env:DOCKER_CERT_PATH = "C:\Users\dimasm93\.docker\machine\machines\default"
$Env:DOCKER_MACHINE_NAME = "default"
$Env:COMPOSE_CONVERT_WINDOWS_PATHS = "true"
# Run this command to configure your shell:
# & "C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe" env default | Invoke-Expression

➜ ~  & "C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe" env default | Invoke-Expression

➜ ~  docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER      ERRORS
default   *        virtualbox   Running   tcp://192.168.99.102:2376           v19.03.12

➜ ~  docker-machine active
default

➜ ~  docker-machine env --unset
Remove-Item Env:\\DOCKER_TLS_VERIFY
Remove-Item Env:\\DOCKER_HOST
Remove-Item Env:\\DOCKER_CERT_PATH
Remove-Item Env:\\DOCKER_MACHINE_NAME
# Run this command to configure your shell:
# & "C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe" env --unset | Invoke-Expression

➜ ~  & "C:\ProgramData\chocolatey\lib\docker-machine\bin\docker-machine.exe" env --unset | Invoke-Expression

➜ ~  docker-machine ssh default
   ( '>')
  /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
 (/-_--_-\)           www.tinycorelinux.net

docker@default:~$
docker@default:~$ logout
exit status 130

➜ ~  docker-machine kill default
Killing "default"...
Machine "default" was killed.

➜ ~  docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL   SWARM   DOCKER    ERRORS
default   -        virtualbox   Stopped                 Unknown
```