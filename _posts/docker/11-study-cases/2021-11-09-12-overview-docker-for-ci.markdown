---
layout: post
title: "Overview of Study Cases using docker for CI"
date: 2021-11-09T06:35:27+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.docker.com/
youtube: ZMGTlTy7Gv0
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12-overview-docker-for-ci
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, pada materi study kasus kali ini kita akan membahas **Continues Integration** atau yang lebih di kenal CI dengan menggunakan Docker. Seperti yang kita tau ya Docker ini tidak hanya untuk development saja tapi bisa juga di terapkan pada lingkugan **Continues Integration**, **Integration Testing**, **Continues Delivery** bahkan **Production**. 

Jadi kali ini kita akan implementasi untuk Continues Ingration dan Integration Testing dulu ya menggunakan tool Docker berserta Gitlab CI.

Untuk implementasinya, nanti kita akan membahas

1. Setup CI environment menggunakan Gitlab CI
2. Build pipeline for Java Web application
3. Build pipeline for Laravel application
4. Build pipeline for Spring Boot application
5. Build pipeline for Angular application