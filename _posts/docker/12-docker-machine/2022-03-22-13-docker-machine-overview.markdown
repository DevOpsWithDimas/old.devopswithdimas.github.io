---
layout: post
title: "Overview of Docker machines"
date: 2022-03-22T04:36:37+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://docs.docker.com/machine/
- https://github.com/docker/machine/blob/docs/docs/overview.md
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/13-docker-machine
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, Setelah sebelumnya kita membahas Docker for Continues Integration (CI) sekarang kita akan membahas tentang Docker machine.

> Note: Docker machine sekarang statusnya sudah deprecated atau sudah tidak aktif lagi. Tetapi tenag kita masih bisa menggunakannya kok, karena docker belum menghapus binarynya.

Ya sebelum kita menggunakan Docker machine, kita bahas dulu 

1. What is Docker Machine?
2. Why should I use it?
3. What's the difference between Docker Engine and Docker Machine?

Ok langsung aja kita bahas materi yang pertama

## What is Docker Machine?

Docker Machine is a tool that lets you install Docker Engine on virtual hosts, and manage the hosts with `docker-machine` commands. You can use Machine to create Docker hosts on your local Mac or Windows box, on your company network, in your data center, or on cloud providers like AWS or Digital Ocean.

You can use Docker Machine to:

1. Install and run Docker on Mac or Windows
2. Provision and manage multiple remote Docker hosts
3. Provision Swarm clusters

Using `docker-machine` commands, you can start, inspect, stop, and restart a managed host, upgrade the Docker client and daemon, and configure a Docker client to talk to your host.

Point the Machine CLI at a running, managed host, and you can run `docker` commands directly on that host. For example, run `docker-machine env default` to point to a host called `default`, follow on-screen instructions to complete `env` setup, and run `docker ps`, `docker run hello-world`, and so forth.

## Why should I use it?

Machine is the best way to provision multiple remote Docker hosts on various flavors of Linux. 

![docker-machine-remote]({{ page.image_path | prepand: site.baseurl }}/01-provision-use-case.png)

Docker Engine runs natively on Linux systems. If you have a Linux box as your primary system, and want to run `docker` commands, all you need to do is download and install Docker Engine. However, if you want an efficient way to provision multiple Docker hosts on a network, in the cloud or even locally, you need Docker Machine.

Whether your primary system is Mac, Windows, or Linux, you can install Docker Machine on it and use `docker-machine` commands to provision and manage large numbers of Docker hosts. It automatically creates hosts, installs Docker Engine on them, then configures the docker clients. Each managed host ("machine") is the combination of a Docker host and a configured client.

## What's the difference between Docker Engine and Docker Machine?

When people say "Docker" they typically mean Docker Engine, the client-server application made up of the Docker daemon, a REST API that specifies interfaces for interacting with the daemon, and a command line interface (CLI) client that talks to the daemon (through the REST API wrapper). Docker Engine accepts docker commands from the CLI, such as `docker run <image>`, `docker ps` to list running containers, `docker images` to list images, and so on.

![docker-engine]({{ page.image_path | prepend: site.baseurl }}/02-engine.png)

**Docker Machine** is a tool for provisioning and managing your Dockerized hosts (hosts with Docker Engine on them). Typically, you install Docker Machine on your local system. Docker Machine has its own command line client docker-machine and the Docker Engine client, docker. You can use Machine to install Docker Engine on one or more virtual systems. These virtual systems can be local (as when you use Machine to install and run Docker Engine in VirtualBox on Mac or Windows) or remote (as when you use Machine to provision Dockerized hosts on cloud providers). The Dockerized hosts themselves can be thought of, and are sometimes referred to as, managed "machines".

![docker-machine]({{ page.image_path | prepend: site.baseurl }}/03-machine.png)