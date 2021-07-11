---
layout: post
title: "Study Kasus: Build specific docker image by programming languages"
date: 2021-06-27T14:10:15+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 8daiyW8p-0Y
comments: true
image_path: /resources/posts/docker/08-buid-by-language
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, setelah kita mempelajari materi dasar `docker build` command kita langsung aja ke Studi Kasus yang nantinya temen-temen akan hadapi ketika menjadi DevOps (Development & Operations).

Jadi menggunakan docker, tidak hanya menggunakan image yang sudah dibuat oleh orang lain, tetapi biasanya kita akan membuat docker image sendiri dengan spesifikasi tertentu, Contohnya berdasarkan bahasa pemograman. 

Dalam build docker image menggunakan bahasa pemograman biasanya memiliki purpose tertentu contohnya jika kita familiar dengan teknologi bahasa pemograman di backend seperti Java, PHP, ruby, atau python. 
Biasanya bahasa pemograman tersebut digunakan untuk membuat Web Applications atau Web Service (REST API) nah jadi kita akan buat Web Application atau Web Service tersebut menjadi suatu Containerization (Docker image). 
Maka dari itu kali ini kita akan membahas best practice membuat image berdasarkan bahasa pemograman atau istilah kerennya. Mengconversi traditional apps/service menjadi Containerization

Contoh kasusnya yang akan kita bahas diantaranya:

1. Java Web yang di deploy dengan Apache Tomcat
2. SpringBoot Web Application / Web Service (REST API)
3. Angular (Front-End Application) di Deploy dengan Nginx Web Server
4. React (Front-End Application) di Deploy dengan Httpd/Apache2
5. PHP Native
6. PHP Framework such as LARAVEL Framework, Codeignitor, etc... 