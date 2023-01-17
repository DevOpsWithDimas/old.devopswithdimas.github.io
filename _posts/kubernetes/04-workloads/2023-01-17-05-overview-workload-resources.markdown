---
layout: post
title: "Overview Kubernetes Worloads"
date: 2023-01-17T19:45:16+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/controllers/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/05-overview-kubernetes-workloads
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, setelah kita membahas tentang Pod and Container specification, dan juga study cases selanjutnya kita akan bahas Kubernetes Workload Resources atau kebanyakan orang menggunakan istilah Kubernetes Resource Controller API.

Pada Kubernetes Workload Resources ini, sangat berguna sekali untuk memange object pod dalam suatu kubernetes cluster seperti Update pod specification, handle replications (scaling up & down), Stateless & Stateful workload, Handle cronjob dan lain-lain.

Adapun yang kita akan bahas terkait Workload Resources diantaranya:

<!--more-->

1. Deployment
2. ReplicaSet
3. StatefulSet
4. DaemonSets
5. Jobs & CronJob
6. ReplicationController

Okay mungkin sekian dulu apa yang bisa saya sampaikan terkait materi yang akan di bahas pada section Kubernetes Workload Resources, semoga temen-temen tertarik mempelajarinya dan mendapatkan benefit terkait feature yang ditawarkan oleh Kubernetes Workload ini. See you next post!!!