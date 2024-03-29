---
layout: post
title: "Setup Ansible Control and Managed Nodes"
date: 2022-09-11T12:14:02+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Ansible
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: study-cases-ansible
image_path: /resources/posts/docker/14c-install-ansible
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, sebelum kita mulai ada beberapa hal yang perlu kita siapkan yaitu Ansible CLI dan Text editor seperti VS Code, Vim dan Terminal. Adapun materi yang akan dibahas kali ini yaitu

1. Install Ansible CLI for MacOs users
2. Install Ansible CLI for Linux users
3. Install Ansible CLI for Windows users
4. Create Virtual machine for Managed node
5. Create ansible inventory and testing using ad-hoc commanline

Ok tanpa berlama-lama yukk langsung aja kita bahas materi yang pertama:

<!--more-->

## Install Ansible CLI on MacOs

Untuk menginstall Ansible CLI di MacOs ada beberapa cara yaitu

1. Use `pip` (package installer for Python)
2. Use homebrew
3. Use MacPort

Saya sendiri lebih prefer menggunakan homebrew, karena simple dengan menggunakan perintah seperti berikut:

{% highlight bash %}
brew install ansible
{% endhighlight %}

dan proses installisasi ansible selesai. Sekarang temen-temen bisa check dengan perintah seperti berikut:

```bash
~ » ansible --version
ansible [core 2.13.3]
  config file = None
  configured module search path = ['/Users/dimasm93/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/Cellar/ansible/6.3.0/libexec/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/dimasm93/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible
  python version = 3.10.6 (main, Aug 30 2022, 05:12:36) [Clang 13.1.6 (clang-1316.0.21.2.5)]
  jinja version = 3.1.2
  libyaml = True

~ » ansible-galaxy --version
ansible-galaxy [core 2.13.3]
  config file = None
  configured module search path = ['/Users/dimasm93/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/local/Cellar/ansible/6.3.0/libexec/lib/python3.10/site-packages/ansible
  ansible collection location = /Users/dimasm93/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/local/bin/ansible-galaxy
  python version = 3.10.6 (main, Aug 30 2022, 05:12:36) [Clang 13.1.6 (clang-1316.0.21.2.5)]
  jinja version = 3.1.2
  libyaml = True
```

## Install Ansible CLI on Linux users

Untuk menginstall Ansible CLI di Linux ada beberapa cara yaitu

1. Use `pip` (package installer for Python)
2. Use package manager
3. [Build from source](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-devel-from-github-with-pip)

Karena disini saya menggunakan Ubuntu Desktop v22.04 unity version, untuk menginstall Ansible CLI saya lebih sering menggunakan Package manager (`apt-get`) berikut perintahnya:

{% highlight bash %}
apt-get update && \
apt-get install ansible -y
{% endhighlight %}

dan proses installisasi ansible selesai. Sekarang temen-temen bisa check dengan perintah seperti berikut:

```bash
dimasm93@DESKTOP-TQ4SI15:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/dimasm93/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.4 (main, Jun 29 2022, 12:14:53) [GCC 11.2.0]

dimasm93@DESKTOP-TQ4SI15:~$ ansible-galaxy --version
ansible-galaxy 2.10.8
  config file = None
  configured module search path = ['/home/dimasm93/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible-galaxy
  python version = 3.10.4 (main, Jun 29 2022, 12:14:53) [GCC 11.2.0]

dimasm93@DESKTOP-TQ4SI15:~$ ansible-playbook --version
ansible-playbook 2.10.8
  config file = None
  configured module search path = ['/home/dimasm93/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible-playbook
  python version = 3.10.4 (main, Jun 29 2022, 12:14:53) [GCC 11.2.0]
```

## Install Ansible CLI for Windows users

Untuk menginstall Ansible CLI di Windows kita membutuhkan Windows SubSystem Linux (WSL2). Karena saya sudah bahas install WSL kita bisa lanjut saja untuk install Distro WSLnya. Temen-temen bisa pasang [Ubuntu 22.04 LTS di Microsoft Store](https://apps.microsoft.com/store/detail/ubuntu-22041-lts/9PN20MSR04DW?hl=en-id&gl=id)

Kemudian temen-temen jalankan Ubuntu 22.04 LTS dari Windows Terminal dan kemudian lakukan installasi seperti pada Linux sebelumnya. Jika sudah temen-temen bisa check dengan perintah berikut:

{% highlight bash %}
ansible --version 
ansible-playbook --version
ansible-galaxy --version
{% endhighlight %}

Jika dijalankan seperti berikut:

![wsl-ansible-console]({{ page.image_path | prepend: site.baseurl }}/wsl-ansible-console.png)

## Create Virtual machine for Managed node

Setelah kita menginstal Ansible dari Controled Node sekarang kita akan setup untuk Managed Node atau remote host. Untuk Managed Node ini bisa menggunakan Physical atau Virtual machine seperti

1. Proxmox
2. VMware
3. VirtualBox
4. Parallels
5. Cloud provider based on VM (GCP, AWS, Alicloud)

Untuk saya sendiri, akan menggunakan Proxmox yang ada di infrastructure network saya (on-premise), setelah kita tentukan vendor untuk Virtualization sekarang kita siapkan juga System Operation Linux Server. temen-temen biasa pake distro

1. [Ubuntu Server](https://ubuntu.com/download/server)
2. [CentOS](https://www.centos.org/download/)
3. [RedHat Enterpice Linux Server](https://www.redhat.com/en/store/red-hat-enterprise-linux-server)
4. [Debian](https://www.debian.org/)
5. dan lain-lain

klo saya sendiri lebih prefer menggunakan CentOS atau Ubuntu server, Ok langsung ja sekarang kita akan buat Virtual Machine menggunakan Proxmox seperti berikut:

![system-info-summary]({{ page.image_path | prepend: site.baseurl }}/08-summary.png)

Setelah membuat Virtual Machine di proxmox, sekarang kita Install OS nya menggunakan Ubuntu Server v20.04 LTS dengan configurasi seperti berikut:

```yaml
OS:
  distribution: Ubuntu Server
  version: 20.04 LTS
Network:
  static:
    subnet: '192.168.88.0/24'
    ip: '192.168.88.201'
    gateway: '192.168.88.1'
DISKs:
  lvm:
    lv-root:
      partision: /
      size: 25G
    lv-var:
      partision: /var
      size: 45G
  swap:
    partision: swap
    size: 4G
```

Setelah selesai proses installasi OS, Install beberapa package seperti `openssh-server`, `vim`, `curl` dengan perintah berikut:

{% highlight bash %}
apt-get update && \
apt-get upgrade -y && \
apt-get install -y openssh-server vim curl network-manager sshpass && \
systemctl enable --now ssh
{% endhighlight %}

Kemudian edit file `/etc/ssh/sshd_config` untuk property `PermiteRootLogin` menjadi `Yes` kemudian jalankan perintah berikut 

{% highlight bash %}
systemctl restart ssh
{% endhighlight %}

Jika sudah sekarang temen-temen bisa coba test remote ke server tersebut dengan menggunakan SSH protocol seperti berikut:

{% highlight bash %}
ssh root@192.168.88.201
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
~ » ssh root@192.168.88.201
The authenticity of host '192.168.88.201 (192.168.88.201)' can't be established.
ED25519 key fingerprint is SHA256:K0RdErApR0x306KHGs6gqTMliDR6r7PlXEnofn817Vc.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: docker-ansible
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.88.201' (ED25519) to the list of known hosts.

Last login: Sat Sep 10 08:46:10 2022 from 192.168.88.208
[root@docker-ansible ~]$
```

Dan untuk selanjutnya kita bisa upload private key ssh kita ke server dengan perintah seperti berikut:

{% highlight bash %}
ssh-copy-id root@192.168.88.201
{% endhighlight %}

Jika dijalankan seperti berikut:

```bash
~ » ssh-copy-id -f root@192.168.88.201
root@192.168.88.201''s password:

Number of key(s) added:        1

Now try logging into the machine, with:   "ssh 'root@192.168.88.201'"
and check to make sure that only the key(s) you wanted were added.

~ » ssh root@192.168.88.201
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-43-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun Sep 11 06:48:14 AM UTC 2022

  System load:  0.0                Processes:              118
  Usage of /:   26.0% of 24.44GB   Users logged in:        1
  Memory usage: 5%                 IPv4 address for ens18: 192.168.88.201
  Swap usage:   0%


8 updates can be applied immediately.
8 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable


Last login: Sun Sep 11 06:45:17 2022 from 192.168.88.208
```

Ok sudah bisa, temen-temen bisa lanjutkan ke tahap selanjutnya.

## Create ansible inventory and testing using ad-hoc commanline

Ansible works against multiple managed nodes or “hosts” in your infrastructure at the same time, using a list or group of lists known as inventory. Once your inventory is defined, you use patterns to select the hosts or groups you want Ansible to run against. 

The default location for inventory is a file called `/etc/ansible/hosts`. You can specify a different inventory file at the command line using the `-i <path>` option. Syntax used `.ini` format seperti berikut:

{% highlight ini %}
[group_name]
domain.example.com ansible_variable_name=value
{% endhighlight %}

Jadi jika kita translate ke Virtual Machine yang sudah kita buat maka seperti berikut:

```ini
[dockerd]
192.168.88.201  ansible_user=root ansible_port=22
```

Simpanlah dengan nama `inventory`, setelah itu kita akan coba test dengan menjalankan command ping ke google dengan perintah seperti berikut:

{% highlight bash %}
ansible dockerd -m ping -i <path-to-inventory>/inventory
{% endhighlight %}

Jika di jalankan seperti berikut

```bash
devops/docker [main] » ansible dockerd -i 11-ansible-docker/inventory -m ping
192.168.88.201 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/libexec/platform-python"
    },
    "changed": false,
    "ping": "pong"
}
```

Jika mengeluarkan output seperti berikut, maka kita udah bisa menggunakan ansible dengan ad-hoc commandline menggunakan module [ping](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ping_module.html)