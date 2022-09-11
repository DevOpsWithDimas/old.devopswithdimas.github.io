---
layout: post
title: "Getting started with Ansible role, tasks for docker"
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
refs: 
- https://docs.ansible.com/ansible/latest/collections/community/docker/index.html
- https://galaxy.ansible.com/dimmaryanto93/docker
youtube: 
comments: true
catalog_key: study-cases-ansible
image_path: /resources/posts/docker/14c-getting-started-ansible-docker-module
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, setelah sebelumnya kita menyiapkan environment seperti Ansible Controller node dan Managed node dengan Virtual Machine sekarang kita akan membahas beberapa IT Automation dengan meggunakan Ansible khususnya terkait dengan Docker operation yaitu

1. Install Docker engine with ansible role [dimmaryanto93.docker](https://galaxy.ansible.com/dimmaryanto93/docker)
2. Manage docker image using ansible [docker_image](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_image_module.html#ansible-collections-community-docker-docker-image-module) module
3. Running a container using ansible [docker_container](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html#ansible-collections-community-docker-docker-container-module) module
4. Execute a container using ansible [docker_container_exec](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_exec_module.html#ansible-collections-community-docker-docker-container-exec-module) module
5. Manage multi-container Docker applications with Docker Compose using ansible [docker_compose](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_module.html#ansible-collections-community-docker-docker-compose-module) module

Ok tanpa berlama-lama yuk lansung aja kita bahas materi yang pertama

<!--more-->

## Install Docker engine with ansible role

Setelah kita Setup Ansible Control dan Managed Nodes, sekarang kita akan meng-install docker engine pada Managed Node menggunakan ansible role yang telah saya buat dan publish di Ansible Galaxy repository berikut [dimmaryanto93.docker](https://galaxy.ansible.com/dimmaryanto93/docker)

Ok yang perlu di siapkan adalah Ansible playbook script seperti berikut:

1. Create file `requirement.yaml` pada Control Node, seperti berikut

    ```yaml
    collections:
        - ansible.posix
        - community.docker
    roles:
        - dimmaryanto93.docker
        - dimmaryanto93.docker_compose
    ```

2. Install dependency / ansible collections pada Control Node, seperti berikut

    ```bash
    ansible-galaxy collection install -r requirement.yaml
    ```

3. Install package / ansible role pada Control Node, seperti berikut

    ```bash
    ansible-galaxy role install -r requirement.yaml
    ```

4. Create file ansible playbook script dengan nama `site-docker.yaml` seperti berikut

    {% gist page.gist "14c-site-docker.yaml" %}

5. Kemudian jalankan ansible playbook script tersebut dengan perintah seperti berikut:

    ```bash
    ansible-playbook -i <path-to-inventory>/inventory <path-to-playbook-script>/site-docker.yaml
    ```

Jika dijalankan hasilnya seperti berikut:

```bash
devops/docker [master●] » ansible-galaxy collection install -r 11-ansible-docker/requirement.yaml
Starting galaxy collection install process
Nothing to do. All requested collections are already installed. If you want to reinstall them, consider using `--force`.

devops/docker [master●] » ansible-galaxy role install -r 11-ansible-docker/requirement.yaml
Starting galaxy role install process
[WARNING]: - dimmaryanto93.docker (master) is already installed - use --force
to change version to unspecified
[WARNING]: - dimmaryanto93.docker_compose (master) is already installed - use
--force to change version to unspecified

devops/docker [master●] » ansible-playbook -i 11-ansible-docker/inventory 11-ansible-docker/site-docker.yaml --list-tasks --list-hosts
playbook: 11-ansible-docker/site-docker.yaml

  play #1 (dockerd): dockerd	TAGS: []
    pattern: ['dockerd']
    hosts (1):
      192.168.88.201
    tasks:
      dimmaryanto93.docker : Install Dependencies for Ubuntu	TAGS: []
      dimmaryanto93.docker : Import python docker module	TAGS: []
      dimmaryanto93.docker : Add apt repository docker-ce for Ubuntu	TAGS: []
      dimmaryanto93.docker : Install dockerd	TAGS: []
      dimmaryanto93.docker : Start docker daemon	TAGS: []
      dimmaryanto93.docker : Post-Install docker, executeable non-root	TAGS: []
      dimmaryanto93.docker : Post-Install docker, config daemon.json	TAGS: []
      dimmaryanto93.docker_compose : Download docker-compose for linux	TAGS: []
      dimmaryanto93.docker_compose : Executeable on root user for docker-compose binary	TAGS: []

devops/docker [master●] » ansible-playbook -i 11-ansible-docker/inventory 11-ansible-docker/site-docker.yaml
PLAY [dockerd] *****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Install Dependencies for Ubuntu] ******************
ok: [192.168.88.201] => (item=apt-transport-https)
ok: [192.168.88.201] => (item=ca-certificates)
ok: [192.168.88.201] => (item=software-properties-common)
ok: [192.168.88.201] => (item=python3-pip)
ok: [192.168.88.201] => (item=virtualenv)
ok: [192.168.88.201] => (item=python3-setuptools)
ok: [192.168.88.201] => (item=gnupg)
ok: [192.168.88.201] => (item=lsb-release)

TASK [dimmaryanto93.docker : Import python docker module] **********************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Add apt repository docker-ce for Ubuntu] **********
included: /Users/dimasm93/.ansible/roles/dimmaryanto93.docker/tasks/package/debian/docker-ubuntu.yaml for 192.168.88.201

TASK [dimmaryanto93.docker : Add Docker GPG apt Key] ***************************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Add Docker Repository for Ubuntu] *****************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Install dockerd] **********************************
ok: [192.168.88.201] => (item=docker-ce)
ok: [192.168.88.201] => (item=docker-ce-cli)
ok: [192.168.88.201] => (item=containerd.io)

TASK [dimmaryanto93.docker : Start docker daemon] ******************************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Post-Install docker, executeable non-root] ********
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Post-Install docker, config daemon.json] **********
included: /Users/dimasm93/.ansible/roles/dimmaryanto93.docker/tasks/config/docker-daemon-conf.yaml for 192.168.88.201

TASK [dimmaryanto93.docker : Create Directory /etc/docker] *********************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Set docker daemon] ********************************
ok: [192.168.88.201]

TASK [dimmaryanto93.docker : Restart docker] ***********************************
changed: [192.168.88.201]

TASK [dimmaryanto93.docker : Log into private registry and force re-authorization] ***

TASK [dimmaryanto93.docker_compose : Download docker-compose for linux] ********
ok: [192.168.88.201]

TASK [dimmaryanto93.docker_compose : Executeable on root user for docker-compose binary] ***
ok: [192.168.88.201]

PLAY RECAP *********************************************************************
192.168.88.201             : ok=15   changed=1    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0
```

Nah jika sudah selesai dengan output seperti diatas, maka docker sudah ter-install pada Managed Node. Sekarang temen-temen bisa check dengan login ke host lalu coba check dengan perintah berikut:

```bash
devops/docker [master●] » ssh root@192.168.88.201
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-43-generic x86_64)

8 updates can be applied immediately.
8 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sun Sep 11 09:06:38 2022 from 192.168.88.208
root@ansible-docker:~# docker info
Client:
 Context:    default
 Debug Mode: false
 Plugins:
  app: Docker App (Docker Inc., v0.9.1-beta3)
  buildx: Docker Buildx (Docker Inc., v0.9.1-docker)
  scan: Docker Scan (Docker Inc., v0.17.0)

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 20.10.18
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 2
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 9cd3357b7fd7218e4aec3eae239db1f68a5a6ec6
 runc version: v1.1.4-0-g5fd4c4d
 init version: de40ad0
 Security Options:
  apparmor
  seccomp
   Profile: default
  cgroupns
 Kernel Version: 5.15.0-43-generic
 Operating System: Ubuntu 22.04.1 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.834GiB
 Name: ansible-docker
 ID: BLEB:CR2H:MNLX:A2SK:ZU2U:6P5V:NWUM:HEEM:MPVH:N64L:ZZHM:MKHD
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Registry: https://index.docker.io/v1/
 Labels:
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false
```

Nah jadi seperti itu ya untuk Install Docker Engine pada Linux menggunakan Ansible. Jadi nanti jika temen-temen ada server lagi yang ingin kita install Docker kita hanya perlu tambahkan host/ip address servernya pada `inventory` dan execute kembali script `ansible-playbook` 

## Manage docker image using ansible `docker_image` module

Setelah kita meng-install Docker engine pada Managed Host dengan menggunakan Ansible role, kita juga bisa menggunakan docker `module` yang di sediakan oleh community ansible khususnya pada [docker_image](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_image_module.html#ansible-collections-community-docker-docker-image-module) module yang biasanya digunakan untuk:

Manage docker images seperti 
1. Build docker image
2. Load or Pull an image
3. Tagging an image
4. Pushing an image to a registry
5. Archiving an image to a `.tar` file

Sebagai contoh misalnya saya mau pull docker image `nginx:mainline` di Managed node, kita bisa menggunakan `docker_image` module ini dengan script berikut:

{% gist page.gist "14c-docker-image-module.yaml" %}

Kemudian coba jalankan perintah `ansible-playbook` berikut:

{% highlight bash %}
ansible-playbook -i <path-to-inventory>/inventory <path-to-playbook>/site-docker-image-module.yaml
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
~ » ssh root@192.168.88.203
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-43-generic x86_64)
Last login: Sun Sep 11 11:42:26 2022 from 192.168.88.207

root@ansible-docker:~# docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE

root@ansible-docker:~# logout
Connection to 192.168.88.203 closed.

~ » cd Developer/dimas-maryanto.com/youtube/_projects/devops/docker
devops/docker [master●] » ansible-playbook -i 11-ansible-docker/inventory 11-ansible-docker/site-docker-image-module.yaml --list-tasks

playbook: 11-ansible-docker/site-docker-image-module.yaml

  play #1 (dockerd): dockerd	TAGS: []
    tasks:
      Pull nginx image	TAGS: []

devops/docker [master●] » ansible-playbook -i 11-ansible-docker/inventory 11-ansible-docker/site-docker-image-module.yaml

PLAY [dockerd] *****************************************************************

TASK [Pull nginx image] ********************************************************
changed: [192.168.88.203]

PLAY RECAP *********************************************************************
192.168.88.203             : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Jika sudah sekarang kita bisa check ke host tersebut apakah sudah ada docker image `nginx:mainline` seperti berikut:

```bash
devops/docker [master●] » ssh root@192.168.88.203
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-43-generic x86_64)
Last login: Sun Sep 11 11:48:05 2022 from 192.168.88.207
root@ansible-docker:~# docker images
REPOSITORY   TAG        IMAGE ID       CREATED       SIZE
nginx        mainline   2b7d6430f78d   2 weeks ago   142MB
```

Selain itu juga klo kita mau hapus, bisa update property `state=present` menjadi `state: absent` kemudian coba execute kembali `ansible-playbook` maka image `nginx:mainline` akan di hapus dari list docker image.

## Manage a container using ansible `docker_container` module

Selain kita bisa me-manage image dengan ansible module `docker_image` kita juga bisa me-manage containers dengan menggunakan ansible module `docker_container` seperti berikut:

1. Create a container
2. Running a container
3. Remove a container
4. Start/Restart a container
5. Stop a running container

Contohnya jika saya mau me-running container `nginx:mainline` dengan meng-expose port `80` serta restart container jika failed maka scriptnya seperti berikut:

{% gist page.gist "14c-docker-container-module.yaml" %}

Kemudian coba jalankan perintah `ansible-playbook` berikut:

{% highlight bash %}
ansible-playbook -i <path-to-inventory>/inventory <path-to-playbook>/site-docker-container-module.yaml
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
devops/docker [master] » curl 192.168.88.203
curl: (7) Failed to connect to 192.168.88.203 port 80 after 32 ms: Connection refused

devops/docker [master] » ansible-playbook -i 11-ansible-docker/inventory 11-ansible-docker/site-docker-container-module.yaml --list-tasks

playbook: 11-ansible-docker/site-docker-container-module.yaml

  play #1 (dockerd): dockerd	TAGS: []
    tasks:
      Run nginx image	TAGS: []

devops/docker [master] » ansible-playbook -i 11-ansible-docker/inventory 11-ansible-docker/site-docker-container-module.yaml

PLAY [dockerd] *****************************************************************

TASK [Run nginx image] *********************************************************
changed: [192.168.88.203]

PLAY RECAP *********************************************************************
192.168.88.203             : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

devops/docker [master] » curl 192.168.88.203 -v
*   Trying 192.168.88.203:80...
* Connected to 192.168.88.203 (192.168.88.203) port 80 (#0)
> GET / HTTP/1.1
> Host: 192.168.88.203
> User-Agent: curl/7.79.1
> Accept: */*
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.23.1
< Date: Sun, 11 Sep 2022 12:08:12 GMT
< Content-Type: text/html
< Content-Length: 615
< Last-Modified: Tue, 19 Jul 2022 14:05:27 GMT
< Connection: keep-alive
< ETag: "62d6ba27-267"
< Accept-Ranges: bytes
<
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
* Connection #0 to host 192.168.88.203 left intact
```