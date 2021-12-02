---
layout: post
title: "Pipeline: spring-boot deploy with Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- Context
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12f-pipeline-springboot
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Gitlab CI untuk spring-boot berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-14-10c-compose-springboot-study-case %}). Jadi karena pembahasan lumayan panjang kita akan bagi menjadi beberapa bagian yaitu

1. Run unit test using Gitlab CI
2. Build jar archived to gitlab
3. Build docker image using archived artifact
4. Push the docker image after build