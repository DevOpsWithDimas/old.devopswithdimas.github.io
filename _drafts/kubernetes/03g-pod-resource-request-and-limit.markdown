---
layout: post
title: "Configure Request and Limit of Resources (CPUs & Memory)"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/
- https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03h-pod-resource-request-and-limit
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita membahas tentang Resources Limit and Request pada suatu containers dalam Pod. Diantaranya:

1. What is Resource Request and Limit?
2. Install prerequisite, Before you begin
3. Specify a CPU request and a CPU limit
4. Specify a CPU request that is too big for your Nodes
5. If you do not specify a CPU limit?
6. Specify a memory request and a memory limit
7. Exceed a Container's memory limit 
8. Specify a memory request that is too big for your Nodes
9. If you do not specify a memory limit?
10. Motivation for requests and limits

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What is Resource Request and Limit?