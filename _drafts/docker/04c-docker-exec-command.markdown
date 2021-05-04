---
layout: post
title: "Run a command in a running container"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/commandline/exec/
youtube: 
comments: true
image_path: /resources/posts/docker/06e-docker-exec-command
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akam membahas tentang perintah `docker exec`. Diataranya:

1. Start bash session
2. Run Interactive command
3. Working with option args
4. Run External program provided by image

<!--more-->

Ok, pertama kita lihat dulu dokumentasinya dengan menggunakan perintah:

{% gist page.gist "04c-docker-exec-help.bash" %}

Seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 711ms.
➜ ~  docker exec -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]

Run a command in a running container

Options:
  -d, --detach               Detached mode: run command in the background
      --detach-keys string   Override the key sequence for detaching a
                             container
  -e, --env list             Set environment variables
      --env-file list        Read in a file of environment variables
  -i, --interactive          Keep STDIN open even if not attached
      --privileged           Give extended privileges to the command
  -t, --tty                  Allocate a pseudo-TTY
  -u, --user string          Username or UID (format:
                             <name|uid>[:<group|gid>])
  -w, --workdir string       Working directory inside the container
```