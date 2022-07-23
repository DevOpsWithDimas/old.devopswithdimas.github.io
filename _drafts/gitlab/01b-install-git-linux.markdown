---
layout: post
title: "How to Install git on Linux"
lang: gitlab
authors:
- dimasm93
categories:
- git
- gitops
- gitlab
refs: 
- https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01a-install-git-linux
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, sebelum kita hand-on menggunakan Git SCM di Linux ada beberapa hal yang perlu kita siapkan. Diantaranya

1. Install Git SCM
2. Setup Terminal
3. Git initialization config

Ok tanpa berlama-lama. langsung saja kita bahas materi yang pertama:

<!--more-->

## Install Git SCM

There are several options for installing Git on Linux distribution:

1. Package manager, such as (apt, yum, zyper,etc)
2. Binary installer
3. Build from source

Untuk saya sendiri meng-install git menggunakan package manager. Karena saya di sini menggunakan Ubuntu Desktop v22.04 Unity. Untuk step-by-stepnya simple sekali, kita buka Terminal dan menggunakan command seperti berikut:

{% highlight bash %}
apt-get update && \
apt-get install git vim tmux -y
{% endhighlight %}