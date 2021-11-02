---
layout: post
title: "Dashboard using Docker Desktop"
lang: docker
categories:
- DevOps
- Docker
- Context
- Dashboard
refs: 
- https://docs.docker.com/desktop/
- https://docs.docker.com/desktop/dashboard/
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11c-docker-desktop
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang dashboard menggunakan Docker Dekstop, Diantaranya sebagai berikut:

1. Docker desktop overview
2. Explore running containers and applications
3. Interact with containers and applications
4. Pull & Push the latest image from/to Docker Hub
5. Manage volumes

Ok langsung aja kita ke pembahasan pertama yaitu

## Docker desktop overview

Docker Desktop is an easy-to-install application for your Mac or Windows environment that enables you to build and share containerized applications and microservices. Docker Desktop includes [Docker Engine](https://docs.docker.com/engine/), Docker CLI client, [Docker Compose](https://docs.docker.com/compose/), [Docker Content Trust](https://docs.docker.com/engine/security/trust/), [Kubernetes](https://github.com/kubernetes/kubernetes/), and [Credential Helper](https://github.com/docker/docker-credential-helpers/).

**Notes** Professional use of Docker Desktop in large organizations (more than 250 employees or more than $10 million in annual revenue) requires users to have a paid Docker subscription. While the effective date of these terms is August 31, 2021, there is a grace period until January 31, 2022 for those that require a paid subscription. For more information, see [Docker Desktop License Agreement](https://docs.docker.com/subscription/#docker-desktop-license-agreement).

Some of the key features of Docker Desktop include:

1. Ability to containerize and share any application on any cloud platform, in multiple languages and frameworks
2. Easy installation and setup of a complete Docker development environment
3. Includes the latest version of Kubernetes
4. Automatic updates to keep you up to date and secure
5. On Windows, the ability to toggle between Linux and Windows Server environments to build applications
6. Fast and reliable performance with native Windows Hyper-V virtualization
7. Ability to work natively on Linux through WSL 2 on Windows machines
8. Volume mounting for code and data, including file change notifications and easy access to running containers on the localhost network
9. In-container development and debugging with supported IDEs

## Explore running containers and applications