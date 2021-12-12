---
layout: post
title: "Pipeline: Angular deploy with Gitlab CI"
lang: docker
categories:
- DevOps
- Docker
- ci
- Study-Cases
- Gitlab-CI
refs: 
- https://docs.docker.com/
youtube: 
comments: true
catalog_key: study-cases-docker-ci
image_path: /resources/posts/docker/12f-pipeline-angular
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di Study Kasus kali ini kita akan membahas pipeline untuk Angular application berdasarkan source-code [berikut]({% post_url docker/09-study-cases/2021-09-26-10d-compose-angular-study-case %}). Seperti biasa karena pembahasan artikel kali ini akan lumayan panjang maka kita akan bagi-bagi menjadi beberapa bagian, Diantaranya:

1. Build source-code to html, js, css resouces using Gitlab CI
2. Add cache/proxy npm using Nexus OSS to Gitlab CI
3. Build docker image using Gitlab CI
4. Testing run containers

Ok lansung aja kita ke materi yang pertama

## Build source-code to html, js, css Resouces

Dalam deployment angular application, pada dasarnya kita harus melakukan compilasi dari Typescript menjadi static resource web seperti `html`, `js` dan `css`. Untuk workflownya 

1. Install dependency menggunakan `npm`
2. Build source-code menggunakan `ng build`
3. Copy hasil build ke web server seperti nginx atau apache httpd

Tahap pertama kita build dulu menggunakan Gitlab CI, OK langsung aja berikut adalah file `.gitlab-ci.yml`:

{% gist page.gist "12f-gitlab-ci.build-ng.yml" %}

Setelah itu, kita coba commit menggunakan perintah 

`git commit -m 'init project'` 

Kemudian coba buat repository baru, misalnya buat dengan nama `udemy-angular` dan yang terakhir coba buat tags dan push sourcenya. 

kemudian coba check status pipelinenya seperti berikut:

![pipeline-status]({{ page.image_path | prepend: site.baseurl }}/01-build-ng-pipeline.png)