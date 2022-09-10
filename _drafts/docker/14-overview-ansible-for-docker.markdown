---
layout: post
title: "Overview Study cases: IT Automation Platform for Docker Operations"
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Ansible
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: study-cases-ansible
image_path: /resources/posts/docker/14-overview-ansible-for-docker
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, sebelumnya kita udah membahas tentang Multiple docker host di local menggunakan docker-machine. Seperti yang temen-temen ketahui docker-machine yang sudah deprecated dan juga biasanya hanya digunakan untuk Local Development. Sekarang kita akan meng-automate deployment Docker host di physical machine atau virtual machine menggunakan IT Automation Platform yaitu Red Hat Ansible.

Ok materi yang akan kita bahas di section kali ini tidak akan terlalu men-detail mengenai RedHat Ansible melainkan penggunaannya terkait Docker operation ya, jika temen-temen tertarik lebih detail mengenai IT Automation dengan RedHat Ansible nanti saya akan buatkan kelas tersendiri :)

Jadi materinya yang akan kita bahas yaitu

<!--more-->

1. What is IT Automation Platform?
2. What is RedHat Ansible?
3. How RedHat Ansible works compare with the other tools?
4. Setup Pre-Requirement to begin
    1. Create Virtual Machine
    2. Installing Ansible cli on local machine
5. Installing Docker engine using ansible role
6. Running container using ansible tasks
7. Execute docker-compose using ansible tasks

Ok mungkin sekian dulu yang saya bisa sampaikan terkait materi yang akan di pelajari mengenai IT Automation Platform with RedHat Ansible untuk Docker Operation, semoga temen-temen tertarik untuk mempelajarinnya lebih dalam lagi. See you next section!