---
layout: post
title: "Setup environment for CI using Gitlab & Nexus OSS"
date: 2021-11-21T14:16:22+07:00
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
- https://docs.gitlab.com/runner/install/linux-repository.html
- https://about.gitlab.com/install/?version=ce
- https://docs.docker.com/ci-cd/best-practices/
- https://docs.gitlab.com/runner/executors/docker.html
youtube: SdzdkL3gXx0
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
        memory: 4GB
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

Setelah kita bahas architecturenya jadi langsung aja kita lakukan installasi semua software/component yang kita butuhkan sesuai dengan masing-masing host/vm/server tersebut.

1. **Basic configuration**, pertama yang perlu kita lakukan adalah base configuration diantaranya
  1. Update latest version dari operation system itu sendiri
  2. Set selinux/appArmor disable or permissive
2. **Install gitlab self hosted**, untuk menginstall gitlab pada vm/server on premise kita bisa ikuti tutorial dari official website gitlab [seperti berikut](https://about.gitlab.com/install/?version=ce)
3. **Install docker Linux**, Untuk install docker di server pada dasarnya sama dengan artikel sebelumnya ya, [baca disini]({% post_url docker/01-introduction/2021-04-11-02-system-requirement %})
4. **Install gitlab-runner**, untuk menginstall gitlab-runner pada vm/server on premise kita bisa ikutin tutorial dari official website gitlab [seperti berikut](https://docs.gitlab.com/runner/install/linux-repository.html)
5. **Install Sonatype nexus-oss**, untuk menginstall nexus-oss kita juga udah pernah bahas di artikel sebelumnya, [baca disini]({% post_url docker/02-registries/2021-04-24-03c-install-nexus-oss %}) 

Setelah semua component selesai kita install, sekarang kita configurasi untuk gitlab & gitlab-runner menggunakan docker executor. Jadi untuk me-register gitlab runner dalam gitlab kita perlu pilih scopenya yaitu 

1. Registered as Global
2. Registered by group
3. Registered by project

Pilih yang mana? ini tergantung dari kebutuhan ada yang ingin semua project pake gitlab runner brati kita register sebagai Global (Menu `Admin -> Runners`), ada yang per project (Menu `Your project -> Settings -> CI/CD -> Runners`) jadi kita pilih by project. Karena disini saya mau general kita pilih yang Global. yang kita perlukan adalah `URL` dan `Registration token` seperti berikut:

![gitlab-runner-register]({{ page.image_path | prepend: site.baseurl }}/gitlab-runner-register.png)

Sekarang kita register, gitlab runner agent ke gitlab dengan menggunakan perintah berikut:

{% highlight bash %}
export GITLAB_URL=http://<gitlab-host-ip>:<gitlab-host-port>;
export GITLAB_RUNNER_TOKEN=<token-here>;

sudo gitlab-runner register \
-r=${GITLAB_RUNNER_TOKEN} \
--name=gitlab-runner-docker-executor \
--non-interactive \
--url=${GITLAB_URL} \
--clone-url=${GITLAB_URL} \
--executor="docker" \
--docker-image="alpine:latest" \
--docker-disable-entrypoint-overwrite=false \
--docker-oom-kill-disable=false \
--env="DOCKER_TLS_CERTDIR=" \
--docker-privileged=true \
--tag-list="docker"
{% endhighlight %}

Jika sudah, maka hasilnya seperti berikut:

![gitlab-runner-registered]({{ page.image_path | prepend: site.baseurl}}/gitlab-runner-registered.png)

## Testing Gitlab CI script

Setelah semua software/component tersebut terinstall dan terkonfigurasi dengan benar, sekarang kita lakukan test untuk membuat repository dan menggunakan feature gitlab ci.

1. Buat repository git di gitlab yang telah kita install
2. Buat file `.gitlab-ci.yaml` seperti berikut
  {% gist page.gist "12a-test-print-env.gitlab-ci.yaml" %}
3. Setelah itu commit & push
4. Kemudian kita check pipeline maka hasilnya seperti berikut

![gitlab-ci pipeline]({{ page.image_path | prepend: site.baseurl }}/gitlab-ci-test-pipeline.png)

Dan jika kita mau lihat jobnya, kita bisa click button pada column `stage`. maka seperti berikut tampilannya

![gitlab-ci job]({{ page.image_path | prepend: site.baseurl }}/gitlab-ci-test-job.png)

Dan yang terakhir kalo kita mau lihat lebih detailnya lagi. kita klik pada button `script` maka hasilnya seperti berikut:

![gitlab-ci job-details]({{ page.image_path | prepend: site.baseurl }}/gitlab-ci-test-job-details.png)