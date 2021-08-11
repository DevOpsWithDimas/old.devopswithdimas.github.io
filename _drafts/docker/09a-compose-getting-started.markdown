---
layout: post
title: "Get started with Docker Compose"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/compose/install/
- https://docs.docker.com/compose/completion/
youtube: 
comments: true
image_path: /resources/posts/docker/09a-compose-getting-started
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas untuk memulai menggunakan Docker compose diataranya:

1. Install Compose
2. Command-line completion (Optional for linux & mac)
3. Getting started

## Install docker compose

You can run Compose on macOS, Windows, and 64-bit Linux. Prerequisites:

1. **On desktop systems like Docker Desktop for Mac and Windows**, Docker Compose is included as part of those desktop installs.
2. **On Linux systems**, first install the Docker Engine for your OS as described on the Get Docker page, then come back here for instructions on installing Compose on Linux systems.

For installing docker-compose on linux

{% gist page.gist "09a-install-compose-linux.bash" %}

Setelah kita install kita bisa coba test, menggunakan perintah seperti berikut:

{% highlight bash %}
docker-compose -v
{% endhighlight %}

## Command-line completion

Compose comes with command completion for the bash and zsh shell.

### Using Bash

For Linux:

{% gist page.gist "09a-install-cli-completion-for-linux.bash" %}

For Mac:

{% gist page.gist "09a-install-cli-completion-for-mac.bash" %}

then add the following to your `~/.bash_profile`:

{% gist page.gist "09a-mac-bash-profile" %}

### Using Zsh

Make sure you have installed [oh-my-zsh](https://ohmyz.sh/) on your computer. Add `docker` and `docker-compose` to the plugins list in `~/.zshrc` to run autocompletion within the oh-my-zsh shell.

{% gist page.gist "09a-zshrc-docker-plugin" %}

## Getting started