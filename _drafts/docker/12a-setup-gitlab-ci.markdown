---
layout: post
title: "Setup environment for CI using Gitlab & Nexus OSS"
lang: docker
categories:
- DevOps
- Docker
- Context
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.gitlab.com/runner/install/linux-repository.html
- https://about.gitlab.com/install/?version=ce
- https://docs.docker.com/ci-cd/best-practices/
- https://docs.gitlab.com/runner/executors/docker.html
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12a-setup-gitlab-ci
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas tentang Setup environment for Continues Integration (CI) menggunakan Gitlab CI dan Nexus OSS. Ok karena artikel ini akan lumayan panjang jadi kita akan bagi2 menjadi beberapa bagian yaitu 

1. Introduction
2. Arsitektur untuk Infra & Software yang digunakan
3. Setup & Konfigurasi software
    1. Install [gitlab-ce](https://about.gitlab.com/install/?version=ce)
    2. Install [gitlab-runner](https://docs.gitlab.com/runner/install/linux-repository.html)
    3. Install [nexus-oss]({% post_url docker/02-registries/2021-04-24-03c-install-nexus-oss %})
    4. Install [docker-ce]({% post_url docker/01-introduction/2021-04-11-02-system-requirement %})
    5. Configure gitlab-runner using docker executor
4. Testing Gitlab CI script

Ok langsung ja kita ke pembahasan pertama yaitu

## Introduction

Seperti yang saya mention sebelumnya bahwa Docker ini bisa digunakan di berbagai lingkungan contohnya Development, CI/CD, Testing, bahkan Production. 

Nah sebagai DevOps kita biasanya akan melakukan workflow 

(`Develop` -> `Build` -> `Test` -> `Deploy`) secara berulang-ulang dan terkadang masih harus dilakukan secara manual, Ini akan menyita waktu dan tenaga. Akan lebih mudah jika buatkan Automated / simplyfied workflow jika kita gambarkan seperti berikut sebagai best practicenya:

![docker deploy workflow](https://docs.docker.com/ci-cd/images/inner-outer-loop.png)

Ada 2 phase yaitu Inner loop dan Outer loop, 

Inner loop yaitu prosesnya ( `Code` -> `Build` -> `Run` -> `Test`) workflow ini biasanya digunakan untuk intensive development. 

Sedangkan untuk Outer loop yaitu prosesnya ( `Push changes` -> `CI build` -> `CI test` -> `Deploy` ) workflow ini biasanya dimana ketika development selesai atau kita mau deploy ke server testing, staging atau production

## Arsitektur Infra & Software

Untuk arsitektur untuk infrastructur dan Software yang kita gunakan seperti berikut:

![arch-infra]({{ page.image_path | prepend: site.baseur }}/arch-gitlab-ci.jpg)

Untuk minimum specification:

```yaml
vcs_repository:
    os: Linux Distro
        distro: Ubuntu Server
        vesion: '>= 20.04'
    hardware:
        cpu: 2 CPU
        memory: 8GB
        storage: 250GB
            partitions:
                - name: /
                  size: 75 GB
                - name: /var
                  size: '>= 150GB'
            type: LVM
    networks:
        - name: private ip
          ip4: 192.168.88.10/24
          gateway: 192.168.88.1
          dns: 
            - 8.8.8.8
            - 8.8.4.4
    firewall-cmd:
        - name: SSH
          port: 22/tcp
          policy: allow
        - name: Gitlab Repository
          port: 80/tcp, 443/tcp   
          policy: allow
    packages:
        - gitlab-ce
        - OpenSSH-Server       

docker_registry:
    os: Linux Distro
        distro: CentOS
        vesion: '>= 7.9'
    hardware:
        cpu: 2 CPU
        memory: 4GB
        storage: 150GB
            partitions:
                - name: /
                  size: 70 GB
                - name: /var
                  size: '>= 120GB'
            type: LVM
    networks:
        - name: private ip
          ip4: 192.168.88.9/24
          gateway: 192.168.88.1
          dns: 
            - 8.8.8.8
            - 8.8.4.4
    firewall-cmd:
        - name: SSH
          port: 22/tcp
          policy: allow
        - name: Nexus OSS
          port: 8081/tcp
          policy: allow
        - name: Docker registry
          port: 8086/tcp, 8087/tcp
          policy: allow
    packages:
        - OpenSSH-Server
        - 'oracle-jdk:8'
        - 'nexus-oss'

workers:
    os: Linux Distro
        distro: CentOS
        vesion: '>= 7.9'
    hardware:
        ## sesuaikan specifikasi hardwarenya dengan kebutuhan build
        ## karena ada beberapa bahasa pemograman membutuhkan lebih dari 4GB RAM dan jumlah cpu
        cpu: 2 CPU
        memory: 4GB
        storage: 50GB
            partitions:
                - name: /
                  size: 20 GB
                - name: /var
                  size: '>= 30GB'
            type: LVM
    networks:
        - name: private ip
          ip4: 192.168.88.8/24
          gateway: 192.168.88.1
          dns: 
            - 8.8.8.8
            - 8.8.4.4
    packages:
        - OpenSSH-Server
        - docker-ce
        - gitlab-runner
```

## Setup & Konfigurasi software