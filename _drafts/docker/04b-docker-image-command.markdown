---
layout: post
title: "Management Docker Images"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/commandline/image/
- https://docs.docker.com/engine/reference/commandline/images/
youtube: 
comments: true
image_path: /resources/posts/docker/06a-docker-image-command
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Docker Image. Diantaranya yaitu 

1. Pull image from registry
2. Push image from registry
3. Image Versioning
4. Menampilkan Informasi Docker image
5. Backup & Restore image

<!--more-->

Untuk perintah management docker image, kita bisa lihat menggunakan

{% gist page.gist "04b-docker-image-help.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 514ms.
➜ ~  docker image --help

Usage:  docker image COMMAND

Manage images

Commands:
  build       Build an image from a Dockerfile
  history     Show the history of an image
  import      Import the contents from a tarball to create a filesystem image
  inspect     Display detailed information on one or more images
  load        Load an image from a tar archive or STDIN
  ls          List images
  prune       Remove unused images
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rm          Remove one or more images
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

Run 'docker image COMMAND --help' for more information on a command.
```