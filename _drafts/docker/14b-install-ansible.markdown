---
layout: post
title: "How to Install RedHat Ansible"
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

Hai semuanya, sebelum kita mulai ada beberapa hal yang perlu kita siapkan yaitu Ansible CLI dan Text editor seperti VS Code, Vim dan Terminal.

Ansible is an agentless automation tool that you install on a single host (referred to as the control node). From the control node, Ansible can manage an entire fleet of machines and other devices (referred to as managed nodes) remotely with SSH, Powershell remoting, and numerous other transports, all from a simple command-line interface with no databases or daemons required.

For your control node (the machine that runs Ansible), you can use nearly any UNIX-like machine with Python 3.8 or newer installed. This includes Red Hat, Debian, Ubuntu, macOS, BSDs, and Windows under a Windows Subsystem for Linux (WSL) distribution. Windows without WSL is not natively supported as a control node;

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

## Install Ansible CLI on Windows users