---
layout: post
title: "Overview Pod and Container in Kubernetes"
date: 2022-04-04T03:53:03+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03-k8s-workloads
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, materi kali ini kita akan membahas tentang Pod dan Container pada Kubernetes (K8S). Mendifinisikan Pod dan Container adalah hal yang paling basic pada Orchestration Container System yang sering sekali dianggap remeh, karena kebanyakan orang2 sudah tidak lagi mendefined Pod dan Container secara explicit bisanya langsung menggunakan Controller seperti Deployment, Stateful, DaemonSet dan lain-lain.

<!--more-->

Adapun meteri yang akan kita bahas terkait Pod dan Container yaitu

1. What is Pod and Container?
2. Working with Pod and Container
3. Pod and Container spec
4. Pod lifecyle
5. Using InitContainer spec
6. Using Environment and Secret to Pod
7. Using Health check atau Container probe
8. Using Resource request and limit
9. Pod distruption

Mungkin sekian dulu yang bisa saya sampaikan mengenai beberapa hal yang perlu kita bahas di section kali ini, semoga temen-teman tertarik mengikuti karena ini adalah fundamental dari seluruh Orchestration Container System yang tidak hanya di implementasikan oleh Kubernetes tpi juga teknology sejenisnya.