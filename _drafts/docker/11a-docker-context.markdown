---
layout: post
title: "Docker Context"
lang: docker
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/context/working-with-contexts/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/04g-docker-context
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang akses Docker Daemon dengan menggunakan Docker Context. Pembahasan kali ini meliputi:

1. Connect Docker Daemon via unix socket, ssh, http connection
2. Management Docker Context
3. Export & Import Docker Context

<!--more-->

A single Docker CLI can have multiple contexts. Each context contains all of the endpoint and security information required to manage a different cluster or node. The `docker context` command makes it easy to configure these contexts and switch between them.