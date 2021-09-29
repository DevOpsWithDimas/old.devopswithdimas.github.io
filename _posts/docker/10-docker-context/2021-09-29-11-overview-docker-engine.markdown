---
layout: post
title: "Overview of Docker Engine"
date: 2021-09-29T18:34:41+07:00
lang: docker
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11-docker-engine
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Docker Engine. 

Docker Engine is an open source containerization technology for building and containerizing your applications. Docker Engine acts as a client-server application with:

1. A server with a long-running daemon process `dockerd`.
2. APIs which specify interfaces that programs can use to talk to and instruct the Docker daemon.
3. A command line interface (CLI) client `docker`.

The CLI uses [Docker APIs](https://docs.docker.com/engine/api/) to control or interact with the Docker daemon through scripting or direct CLI commands. Many other Docker applications use the underlying API and CLI. The daemon creates and manage Docker objects, such as images, containers, networks, and volumes.

Kalo temen-temen masih inget tentang arsitektur dari Docker seperti berikut:

![docker arch](https://docs.docker.com/engine/images/architecture.svg)

Docker is written in the [Go programming language](https://golang.org/) and takes advantage of several features of the Linux kernel to deliver its functionality. Docker uses a technology called `namespaces` to provide the isolated workspace called the container. When you run a container, Docker creates a set of namespaces for that container.

These namespaces provide a layer of isolation. Each aspect of a container runs in a separate namespace and its access is limited to that namespace.

Nah jadi setelah kita berbicara tentang Docker arsitekturnya client-server, selanjutnya kita akan membahas tentang Docker Context.