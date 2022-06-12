---
layout: post
title: "Configure liveness, readiness, and startup probes"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03g-container-probe
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih detail tentang Container probe diantaranya Liveness, Readiness and Startup Probes dalam suatu Pod Specification. Diantaranya:

1. What the different between liveness, readiness and startup probe?
2. When should you use liveness probe?
3. Configure liveness probe in a Pod
4. When should you use readiness probe?
5. Configure readiness probe in a Pod
6. When should you use startup probe?
7. Configure startup probe in a Pod
8. Motivation for using Container Probe

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What the different between liveness, readiness and startup probe?

