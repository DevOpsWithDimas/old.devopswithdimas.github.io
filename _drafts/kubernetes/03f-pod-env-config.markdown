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

Seperti yang temen-temen ketahui suatu Environtment Variable ini biasanya digunakan untuk meng-inject data kedalam Container yang bisa dilakukan secara dynamicly.