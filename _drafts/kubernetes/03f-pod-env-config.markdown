---
layout: post
title: "Configure env (Environment Variables) in a Pods"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/
- https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03f-pod-env
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Environment Variables pada Pod Specification, diantaranya:

1. Basic Usage env-values
2. What is ConfigMap?
3. Using ConfigMap as Ref `envFrom`
4. What is Secret?
5. Using Secret as Ref to `envFrom`
6. Using `valueFrom` of ConfigMap or Secret
7. Motivation for using ConfigMap and Secret

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Basic Usage env-values

Seperti yang temen-temen ketahui suatu Environtment Variable ini biasanya digunakan untuk meng-inject data kedalam Container bertujuan untuk merubah behavior atau prilaku dari command yang di eksekusi oleh container runtime.

Pada meteri sebelumnya tentang Basic Pod and Container spesification pada section Environment Variable, kita mendefinikan env `POSTGRES_PASSWORD` ke Container image `postgres` bertujuan meng-override default password pada user `postgres` dalam database.

Sometime, penggunaan `env` pada containerSpec tidak hanya itu saja. Suatu environment variables bisa di gunakan bersamaan (suatu value dari env me-refer ke object yang berbeda) contohnya ketika membuat aplikasi bisnis (CRUD) yang terdiri dari web-server dan database saling berinteraksi kita bisa menggunan env yang sama seperti berikut:

{% gist page.gist "03f-pod-env-multiple.yaml" %}

Nah terlihat pada podSpec diatas, ada beberapa value dari env yang sebetulnya kita bisa generalisasi karena menggunakan value yang sama yaitu (`DB_NAME == POSTGRES_DB`, `POSTGRES_USER == DB_USERNAME` dan `POSTGRES_PASSWORD == DB_PASSWORD`). Disinilah kita bisa menggunakan salah satu object dari kubernetes untuk me-maintanance data tersebut yaitu `ConfigMap` dan `Secret`