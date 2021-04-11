---
layout: post
title: "Docker Overview"
date: 2021-04-11T08:51:06+07:00
lang: docker
categories:
- DevOps
- Docker
refs: 
- https://docs.docker.com/get-started/overview/
youtube: 
comments: true
image_path: /resources/posts/docker/01a-docker-overview
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di artikel kali ini kita akan membahas tentang 
 
1. Apa itu Docker?
2. Manfaat menggunakan Docker Platform?
3. Docker Architecture
4. Istilah-istilah dalam Docker?
    - Daemon
    - Docker Client
    - Docker Registry
    - Images
    - Containers
    - Isolated workspace

## Docker Overview

Sebagai seorang Research and Development (RnD) dan sekaligus Software Engineer, tidak jarang berurusan dengan product brended sekelas IBM, Oracle dan lainnya. Misalnya karena kerjaan kita adalah mendevelop aplikasi. Aplikasi tersebut harus run di product IBM misalnya JBoss EAP kemudian Untuk database menggunakan product Microsoft MS-SQL Server.

Permasalahannya? sebenarnya product tersebut punya Environment / Spesifikasi masing-masing sebagai contohnya Microsoft SQL Server hanya bisa di running di env Microsoft Windows Server, Microsoft Azure, dan Linux Server sedangkan tidak semua Developer memiliki env tersebut. 

Solusinya ada beberapa cara mulai dari install ulang OS, Virtualization, dan Containerization. 

1. Cara yang paling sederhana adalah install ulang OS, cuman secara workflow gak terlalu enak karena harus adaptasi lagi dengan OS tersebut dan juga software-softwarenya.
2. Jadi dulu biasanya saya menggunakan Virtualbox untuk menginstall OS tertentu tpi secara development jadi kurang nyaman karena ada beberapa masalah dengan Driver Compatibility, limit resouces dan lain-lain.
3. Containerization, salah satunya yang saya sering gunakanan beberapa tahun ini yaitu dengan menggunakan Docker Platform.

## What is Docker

![docker-logo]({{ page.image_path | prepend: site.baseurl }}/logo.png)

> Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. 
By taking advantage of Docker’s methodologies for shipping, testing, and deploying code quickly, you can significantly reduce the delay between writing code and running it in production.

## The Docker platform

Docker bisa melakukan packaging dan me-running application di isolation envirotnment di atas Operation System nah itu di sebut container. Dengan isolation dan security, jadi bisa menjalakan banyak aplikasi dalam suatu host. Containers yaitu lightweight dan mengandung apapun yang dibutuhkan untuk menjalankan aplikasi. jadi kita gak perlu menginstall dependency dari software yang kita buat dalam containernya, Contohnya klo kita jalankan container `PostgreSQL Database` nah untuk editornya (`psql`) kita tidak perlu diinstall pada host kita. 

## What can I use Docker for?

Docker ini 3 s/d 4 tahun lalu, saya hanya gunakan docker hanya sebagai Development Env karena saya sering dan banyak sekali gonta-ganti software seperti database, web server dan lain-lain. Jadi karena storage agak kecil jadi begitu selesai project harus hapus software dulu, jadi agak ribet aja. Dengan docker ini menjadi solusi saya jadi begitu project yang saya kerjakan selesai jadi saya bisa aman untuk hapus dan install lagi dengan mudah, jadi kesimpulannya di laptop saya hanya install software yang betul-betul digunakan saja.

Sekarang docker ini makin terkenal, yang awalnya cuman sebagai support Development sekarang malahan dipake untuk Production. 
berikut adalah beberapa scenario kegunaan dari Docker:

1. Your developers write code locally and share their work with their colleagues using Docker containers.
2. They use Docker to push their applications into a test environment and execute automated and manual tests.
3. When developers find bugs, they can fix them in the development environment and redeploy them to the test environment for testing and validation.
4. When testing is complete, getting the fix to the customer is as simple as pushing the updated image to the production environment.


### Responsive deployment and scaling

Docker’s container-based platform allows for highly portable workloads. Docker containers can run on a developer’s local laptop, on physical or virtual machines in a data center, on cloud providers, or in a mixture of environments.

## Docker Architecture

Docker menggunakan _client-server architecture_. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker containers. The Docker client and daemon can run on the same system, or you can connect a Docker client to a remote Docker daemon. The Docker client and daemon communicate using a REST API, over UNIX sockets or a network interface. Another Docker client is Docker Compose, that lets you work with applications consisting of a set of containers.

![docker-architecture](https://docs.docker.com/engine/images/architecture.svg)

## Docker interfaces

Ketika docker di install pada host, kita di sediakan beberapa interfaces:

1. Docker Daemon (`dockerd`), yaitu Docker API dan untuk memanage Docker Objects seperti images, containers, networks, volumes.
2. Docker Client (`docker` dan `docker-compose`), yaitu Program Interface yang berkomunikasi dengan Docker Daemon  
3. Docker Registries, yaitu untuk menyimpan docker image (`push`) secara public dan private, selain itu juga kita mengambil image yang telah tersedia (`pull`).

## Docker Objects

Ketika kita menggunakan docker, kita akan menggunakan beberapa object diantaranya:

1. Docker Images, An image is a read-only template with instructions for creating a Docker container.
2. Docker Containers, A container is a runnable instance of an image.
3. Docker Volumes, A volume is object storage relateable with containers
4. Docker Networks, A network is object interaction between containers

