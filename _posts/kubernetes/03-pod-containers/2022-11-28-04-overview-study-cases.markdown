---
layout: post
title: "Overview Study Cases: Pod and Containers"
date: 2022-11-28T22:03:44+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Pods
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03k-practice-part1
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, Setelah kita membahas secara mendetail terkait Pod and Container specification di Kubernetes sekarang saatnya kita lansung mencoba study cases dengan beberapa skenario yang sudah saya rangkum dari beberapa pengalaman saya dan juga beberapa referensi sertifikasi yang mengacu ke CKAD (Certified Kubernetes Application Developer) yaitu

<!--more-->

Me-migrasi, Meng-konfersi deployment aplikasi dari Convensional (UNIX systemd/daemon) menjadi Cloud Native berbasiskan Container. Adapun yang kita bahas yaitu

1. Monolith apps: Menggunakan framework PHP Laravel berbasis Web MVC.
2. Microservice apps: Menggunakan framework Springboot untuk backend kemudian Angular/React sebagai frontend.

Ok mungkin sekian dulu apa yang bisa saya sampaikan terkait pembahasan materi selanjutnya, semoga dengan adanya study cases ini temen-temen bisa lebih memahami dan meng-implementasikan apa yang telah saya sampaikan terkait materi Pod dan Container specification pada Kubernetes.