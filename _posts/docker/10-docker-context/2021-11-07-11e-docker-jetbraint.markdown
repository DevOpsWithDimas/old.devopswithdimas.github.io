---
layout: post
title: "Using Docker on Jetbraint IDE"
date: 2021-11-07T19:14:40+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Context
- Dashboard
refs: 
- https://www.docker.com/what-docker
- https://www.jetbrains.com/help/idea/docker.html
- https://plugins.jetbrains.com/plugin/7724-docker?_ga=2.163087548.1667072148.1636275769-1635107743.1636275769
youtube: bS_fW8-knvo
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11e-docker-jetbraint
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Manage service dan application pada Docker menggunakan IntelliJ IDEA. Diantaranya yang akan kita bahas yaitu

1. Introduction
2. Enable Docker support to IntelliJ IDEA
3. Managing docker images
4. Running containers
5. Interation to container

Ok langsung aja kita ke pembahasan yang pertama

## Introduction

Jetbraint [IntelliJ IDEA](https://www.jetbrains.com/idea/) adalah salah satu Integrated Development Environment (IDE) favorite saya selama ini, biasanya saya gunakan untuk Coding, Database, dan lain-lain.

## Enable Docker support to IntelliI IDEA

Untuk meng-aktifkan Docker support di IntelliJ IDEA kita perlu install plugin [docker](https://plugins.jetbrains.com/plugin/7724-docker?_ga=2.204595344.1667072148.1636275769-1635107743.1636275769) dari marketplace Jetbraint, by default jika temen-temen menggunakan Ultimate Edition plugin docker tersebut sudah ter-install di IntelliJ IDEA, sedangkan untuk community edition temen-temen perlu install secara manual di **Menu -> Settings -> Plugins -> Marketplace** seperti berikut

![marketplace-docker]({{ page.image_path | prepend: site.baseurl }}/01-marketplace-docker.png)

Setelah ter-install, kita akan configure supaya docker dan IntelliJ IDEA terintegrasi, kita masuk ke **Menu -> Settings -> Build, Execution, dan Deployment -> Docker** seperti berikut:

![marketplace-docker]({{ page.image_path | prepend: site.baseurl }}/02-jetbraint-docker-settings.png)

Jika di IDEA temen-temen belum ada konfigurasi tersebut, bisa klik `+` untuk menambahkan Docker server baru, Kemudian konfigurasi sesuai dengen kebutuhan contohnya connection lewat ssh, atau lewat tcp dan lain-lain. Jika sudah OK nanti di bawah akan ada connection statusnya seperti gambar tersebut `Connection successful` dan yang terkahir kita bisa `Apply` konfigurasinya. Maka jika buka tab `Services` hasilnya seperti berikut:

![jetbraint-services]({{ page.image_path | prepend: site.baseurl }}/03-jetbraint-services-docker.png)

## Managing images

Images are distributed via the Docker registry. [Docker Hub](https://hub.docker.com/) is the default public registry with all of the most common images: various Linux flavors, database management systems, web servers, runtime environments, and so on. There are other public and private Docker registries, and you can also deploy your own registry server.

1. Configure a docker registry
    ![config-docker-registry]({{ page.image_path | prepend: site.baseurl }}/04-manage-image-config-registry.png)
2. Pull an image from docker registry
    ![manage-image-pull]({{ page.image_path | prepend: site.baseurl }}/05-manage-image-pull.png)
3. Build an image from a Dockerfile
4. Push an image to a Docker registry
    ![manage-image-push]({{ page.image_path | prepend: site.baseurl }}/06-manage-image-push.png)

## Running containers

Docker containers are runtime instances of the corresponding images. IntelliJ IDEA uses run configurations to execute the commands that build Docker images and run containers. There are three types of Docker run configurations:

1. Docker Image: Created automatically when you run a container from an existing image. You can run it from a locally existing Docker image that you either pulled or built previously.
    ![run-from-image]({{ page.image_path | prepend: site.baseurl }}/07-run-container-from-image.png)

2. Dockerfile: Created automatically when you run a container from a Dockerfile. This configuration builds an image from the Dockerfile, and then derives a container from this image.

3. Docker-compose: Created automatically when you run a multi-container Docker application from a Docker Compose file.
    ![run-from-compose-files]({{ page.image_path | prepend: site.baseurl }}/08-run-container-from-compose.png)

## Interation to container

Created containers are listed in the Services tool window. By default, the Services tool window displays all containers, including those that are not running. To hide stopped containers from the list, click The Filter button in the toolbar, select Docker, and then click Stopped Containers to remove the checkbox.

When you select a container, you can view the following tabs by default:

1. **Build Log**, Shows the deployment log produced by the corresponding Docker run configuration while building the image for the container.
    ![interaction-build-logs]({{ page.image_path | prepend: site.baseurl }}/09a-container-interaction-build-log.png)
2. **Log**, Shows the log messages from the container's standard output streams: `STDOUT` and `STDERR`.
    ![interaction-logs]({{ page.image_path | prepend: site.baseurl }}/09b-container-interaction-log.png)
3. **Properties**, Shows the name and ID of the container, and the ID of the corresponding image.
    ![interaction-properties]({{ page.image_path | prepend: site.baseurl }}/09c-container-interaction-properties.png)
4. **Environment Variables**, Shows the environment variables configured for the container.
    ![interaction-env-vars]({{ page.image_path | prepend: site.baseurl }}/09d-container-interaction-env-variables.png)
5. **Port Bindings**, Show the port bindings configured for this container.
    ![interaction-port-binding]({{ page.image_path | prepend: site.baseurl }}/09e-container-interaction-port-binding.png)
6. **Volume Bindings**, Show the volume bindings configured for this container.
    ![interaction-volume-binding]({{ page.image_path | prepend: site.baseurl }}/09f-container-interaction-volume-binding.png)
7. **Files**, Browse the files inside a running container.
    ![interaction-files]({{ page.image_path | prepend: site.baseurl }}/09g-container-interaction-files.png)
8. **Execute a command inside a running container**
    ![interaction-exec]({{ page.image_path | prepend: site.baseurl }}/10-container-interaction-exec.png)