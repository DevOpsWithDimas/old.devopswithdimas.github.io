---
layout: post
title: "Compose file for multiple git projects"
date: 2021-09-26T14:44:07+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Study-Cases
refs: 
- https://docs.docker.com/
- https://git-scm.com/book/en/v2/Git-Tools-Submodules
youtube: 
comments: true
catalog_key: study-cases-compose-files
image_path: /resources/posts/docker/10e-compose-using-multiple-git-projects
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, pada materi study kasus kali ini kita akan membahas tentang Multiple git project dalam menggunakan docker compose. Diantaranya kita akan bahas

1. Introduction
2. Solution 1 (Using separate compose file per project)
3. Solution 2 (Copy all the git projects to new git repo)
4. Solution 3 (Using git submodule)

Ok langsung aja kita ke pembahasan yang pertama

## Introduction

Jaman sekarang itu hampir semua aplikasi menggunakan arsitektur micro-services, artinya semua service di pecah-pecah menjadi beberapa module. Dengan begitu biasanya setiap module akan di buatkan project gitnya seperti

1. backend
    1. backend-1
    2. backend-2
    3. backend-n
2. api-gateway
3. frontend
4. mobile-android
5. mobile-ios

Yang jadi pertanyaan sebagai seorang DevOps bagaimana kita deploy jika kita menggunakan compose file?

Ok kita simak beberapa solusi berikut

## Solusi 1 (Using separate compose file per project)

