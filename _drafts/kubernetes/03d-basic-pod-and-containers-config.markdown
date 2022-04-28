---
layout: post
title: "Basic Pods and Containers Configuration"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03d-basic-config-pod
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Basic configuration pada Pods and Containers. PodSpec adalah Specification supaya kita bisa meng-konfigurasi container yang akan kita sesuai dengan harapan kita contohnya seperti command apa yang akan di execute ketika container startup, port berapa yang kita mau expose ke luar, dan masih banyak lagi.

Ok karena materinya akan lumayan panjang kita akan bagi memjadi beberapa bagian diantaranya:

1. Using Labels in a Pods
2. Using Namespace
3. Using `image` & `imagePullPolicy` in containerSpec
4. Using `env`
5. Using Working directory in containerSpec
6. Using Entrypoin (`command` and `args`)
7. Using normal user or non-root to run container
8. Using `ports`
9. Using Resource request & limit

<!--more-->

Materi: 

1. Topic1
2. Topic2
    1. Topic 2.a
    2. Topic 2.b
3. Topic 3
4. Topic 4