---
layout: post
title: "Docker Registry (Docker HUB)"
date: 2021-04-24T16:43:49+07:00
lang: docker
categories:
- DevOps
- Docker
- Registry
refs: 
- https://docs.docker.com/docker-hub/official_images/
- https://www.docker.com/products/docker-hub
youtube: EiviPmBPEJA
comments: true
catalog_key: docker-registry
image_path: /resources/posts/docker/03a-docker-hub
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

halo semuanya, di materi kali ini kita akan membahas tentang Docker Registry, The Registry is a stateless, highly scalable server side application that stores and lets you distribute Docker images. 
The Registry is open-source, under the permissive Apache license. Secara default, Docker Registry menggunakan [Docker Hub](hub.docker.com). Ok nah jadi sekarang kita akan membahas:

1. Apa itu Official Images
2. Apa itu Public Images
3. Docker Hub Repository (Public/Private repository)
4. How to Sign-up & Sign-in to [hub.docker.com](https://hub.docker.com)
5. How to Store your own images to [hub.docker.com](https://hub.docker.com)

<!--more-->

## Official Image

The Docker Official Images are a curated set of Docker repositories hosted on Docker Hub. They are designed to:

1. Provide essential base OS repositories (for example, ubuntu, centos) that serve as the starting point for the majority of users.
2. Provide drop-in solutions for popular programming language runtimes, data stores, and other services, similar to what a Platform as a Service (PAAS) would offer.
3. Exemplify Dockerfile best practices and provide clear documentation to serve as a reference for other Dockerfile authors.
4. Ensure that security updates are applied in a timely manner. This is particularly important as Official Images are some of the most popular on Docker Hub.

Docker, Inc. sponsors a dedicated team that is responsible for reviewing and publishing all content in the Official Images. This team works in collaboration with upstream software maintainers, security experts, and the broader Docker community. If you are new to Docker, we recommend that you use the Official Images in your projects. These images have clear documentation, promote best practices, and are designed for the most common use cases. Advanced users can review the Official Images as part of your Dockerfile learning process.

A common rationale for diverging from Official Images is to optimize for image size. For instance, many of the programming language stack images contain a complete build toolchain to support installation of modules that depend on optimized code. An advanced user could build a custom image with just the necessary pre-compiled libraries to save space.

Berikut adalah contoh official image, jika kita search di halaman [hub.docker.com](https://hub.docker.com/search?q=mysql&type=image)

![docker public image]({{ page.image_path | prepend: site.baseurl }}/official-images.png)

## Public docker images

Selain official docker image, di [hub.docker.com](https://hub.docker.com/search?q=mysql&type=image) ada juga public image yang kita bisa coba, Jadi public docker image ini adalah docker image yang di publish oleh semua orang di seluruh dunia, sebagai contoh klo temen-temen search image `mysql` maka yang tampil ada banyak sekali. biasanya public image diawali dengan `username/<image-name:tag>` seperti berikut:

![docker public image]({{ page.image_path | prepend: site.baseurl }}/public-images.png)

## Sign-up & Sign-in to registry

Dengan adanya image registry hub seperti Docker Hub, kita bisa berkolaborasi artinya image yang kita publish ke registry bisa digunakan juga oleh orang lain atau ke team (private repository). Nah untuk mempublish kita perlu daftar dulu ke [hub.docker.com](https://hub.docker.com/signup) jika belum punya account, jika sudah kita login dulu login dengan menggunakan perintah

{% gist page.gist "03a-docker-login.bash" %}

Jika di jalankan hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 514ms.
➜ ~ docker login -u dimmaryanto93
Password:
Login Succeeded
```

Selain menggunakan command berikut kita jika menggunakan Docker Desktop kita bisa login dari menu, `Docker Desktop` -> `Sign in / Create Docker ID` maka akan muncul seperti berikut:

![docker-login-form]({{ page.image_path | prepend: site.baseurl }}/docker-login.png)

## Store your image to Docker Hub

Untuk menyimpan image ke Docker Hub, kita bisa menyimpan as Public atau Private Repositories. Untuk public repository biasanya bisa digunakan oleh siapapun, sedangkan untuk private repository hanya yang diberikan akses saja. Nah di Docker Hub kita diberikan 1 Private Repository untuk setiap user dan unlimited public repositories. berikut adalah perbandingan Pricing

![pricing]({{ page.image_path | prepend: site.baseurl }}/pricing-docker-hub.png)

Untuk mempublish suatu image ke Docker Hub dari image yang telah tersedia atau yang kita build sendiri. kita harus menggunakan Docker ID sebagai identified dalam penamaan imagenya seperti `<your-username>/<image-name>:<tag>` Contoh implementasinya seperti berikut:

For Bash script:

{% gist page.gist "03a-publish-image.bash" %}

For Powershell script:

{% gist page.gist "03a-publish-image.ps1" %}

Jika dijalankan seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 507ms.

➜ ~ ✗  docker pull mysql:5.7
5.7: Pulling from library/mysql
f7ec5a41d630: Pull complete
9444bb562699: Pull complete
6a4207b96940: Pull complete
181cefd361ce: Pull complete
8a2090759d8a: Pull complete
15f235e0d7ee: Pull complete
d870539cd9db: Pull complete
cb7af63cbefa: Pull complete
151f1721bdbf: Pull complete
fcd19c3dd488: Pull complete
415af2aa5ddc: Pull complete
Digest: sha256:a655529fdfcbaf0ef28984d68a3e21778e061c886ff458b677391924f62fb457
Status: Downloaded newer image for mysql:5.7
docker.io/library/mysql:5.7

➜ ~  docker image tag mysql:5.7 dimmaryanto93/mysql:5.7

➜ ~  docker images
REPOSITORY            TAG       IMAGE ID       CREATED      SIZE
dimmaryanto93/mysql   5.7       87eca374c0ed   4 days ago   447MB
mysql                 5.7       87eca374c0ed   4 days ago   447MB

➜ ~  docker push dimmaryanto93/mysql:5.7
The push refers to repository [docker.io/dimmaryanto93/mysql]
065db6810608: Mounted from library/mysql
c72710eaafe9: Mounted from library/mysql
f06c93a4b5ba: Mounted from library/mysql
711202fdcd50: Mounted from library/mysql
1ce52ff7c16f: Mounted from library/mysql
2cb169012988: Mounted from library/mysql
2b1742830571: Mounted from library/mysql
7afbf38fd1da: Mounted from library/mysql
f68961560ec1: Mounted from library/mysql
76233144372b: Mounted from library/mysql
7e718b9c0c8c: Mounted from library/mysql
5.7: digest: sha256:9f768489d306402ea11243f1b96aeaa4696adb9ed7c1bb0318724759b9cbd1a6 size: 2621
```

Jika di check di website, hasilnya seperti berikut:

![docker publish image]({{ page.image_path | prepend: site.baseurl }}/docker-push-image.png)