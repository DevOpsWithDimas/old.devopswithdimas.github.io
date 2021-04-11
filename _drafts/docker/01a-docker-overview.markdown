---
layout: post
title: "Docker Overview"
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