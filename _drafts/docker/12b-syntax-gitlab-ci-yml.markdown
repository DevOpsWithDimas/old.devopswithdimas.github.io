---
layout: post
title: "The `.gitlab-ci.yml` file"
lang: docker
categories:
- DevOps
- Docker
- Context
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/14.4/ce/ci/yaml/gitlab_ci_yaml.html
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12b-syntax-gitlab-ci-yaml
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di artikel sebelumnya kita sudah men-setup suatu environment untuk continues integration menggunakan feature gitlab ci dengan bantuan docker executor. Nah jadi sebelum kita bahas tentang pipeline sekarang kita bahas dulu basic dari syntax `.gitlab-ci.yml` file ya. Diantaranya yaitu

1. Introduction
2. Basic usage of `.gitlab-ci.yml` file
3. Should i triggered to deploy manually or automatically?
4. Using CI/CD Variables
5. Using services
6. Extends / Merge job
7. Use cases to test, build, and publish docker images