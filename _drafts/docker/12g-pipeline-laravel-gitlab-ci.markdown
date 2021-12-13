---
layout: post
title: "Pipeline: Laravel deploy with Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/ee/ci/examples/deployment/composer-npm-deploy.html
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12e-pipeline-laravel
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas Pipeline untuk Laravel application berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-27-10e-httpd-ssl-docker %}). Seperti biasa karena pembahasan kali akan lumayan panjang kita bagi-bagi menjadi beberapa bagian, Diantaranya

1. Build custome image to test, and build Laravel application
2. Build source-code to site resources with Gitlab CI
3. Add local caching/proxy to build with Gitlab CI
4. Build docker image with Gitlab CI
5. Test run containers

Ok langsung kita ke pembahasan yang pertama yaitu

## Build custome image to test, and build Laravel apps



## Build source-code to site resources

