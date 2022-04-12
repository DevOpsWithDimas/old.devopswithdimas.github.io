---
layout: post
title: "Working with Pods"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/#working-with-pods
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03b-working-with-pods
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Working with pods in kubernetes cluster. Seperti yang telah kita bahas di artikel sebelumnya mekipun kita sebetulnnya akan jarang sekali membuat pods secara explicit tapi gak ada salahnya untuk kita bahas lebih lanjut.

Seperti biasa untuk pembahasan mengenai Working with pods ini kita akan bagi menjadi beberapa bagian diantaranya:

1. Pods and Controllers
2. Pod templates
3. Pod update and replacement
4. Resource sharing in pods
5. Pod networking
6. Privileged mode for containers
7. Static pods
8. Container probes

Ok langsung ja kita bahas materi yang pertama

<!--more-->

## Pods and Controllers

