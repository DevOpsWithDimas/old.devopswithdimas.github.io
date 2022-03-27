---
layout: post
title: "Install docker-machine on Windows"
lang: docker
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

