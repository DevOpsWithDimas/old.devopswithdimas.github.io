---
layout: post
title: "Getting started with Ansible role, tasks for docker"
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
refs: 
- https://docs.ansible.com/ansible/latest/collections/community/docker/index.html
youtube: 
comments: true
catalog_key: study-cases-ansible
image_path: /resources/posts/docker/14c-ansible-for-docker-operation
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, setelah sebelumnya kita menyiapkan environment seperti Ansible Controller node dan Managed node dengan Virtual Machine sekarang kita akan membahas beberapa IT Automation dengan meggunakan Ansible khususnya terkait dengan Docker operation yaitu

1. Install Docker engine dengan ansible-role
2. Manage docker image using ansible [docker_image](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_image_module.html#ansible-collections-community-docker-docker-image-module) module
3. Log into a Docker registry using ansible [docker_login](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_login_module.html#ansible-collections-community-docker-docker-login-module) module
4. Running a container using ansible [docker_container](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_module.html#ansible-collections-community-docker-docker-container-module) module
5. Execute a container using ansible [docker_container_exec](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_container_exec_module.html#ansible-collections-community-docker-docker-container-exec-module) module
6. Manage Docker volumes using ansible [docker_volume](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_volume_module.html#ansible-collections-community-docker-docker-volume-module) module
7. Manage multi-container Docker applications with Docker Compose using ansible [docker_compose](https://docs.ansible.com/ansible/latest/collections/community/docker/docker_compose_module.html#ansible-collections-community-docker-docker-compose-module) module

Ok tanpa berlama-lama yuk lansung aja kita bahas materi yang pertama

<!--more-->

Materi: 

1. Topic1
2. Topic2
    1. Topic 2.a
    2. Topic 2.b
3. Topic 3
4. Topic 4