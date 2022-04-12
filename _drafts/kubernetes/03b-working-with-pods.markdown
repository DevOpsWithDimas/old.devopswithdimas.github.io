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

Hai semuanya, di materi kali ini kita akan membahas Working with pods in kubernetes cluster. Seperti yang telah kita bahas di artikel sebelumnya mekipun kita sebetulnnya akan jarang sekali membuat pods secara explicit.

This is because Pods are designed as relatively ephemeral, disposable entities. When a Pod gets created (directly by you, or indirectly by a controller), the new Pod is scheduled to run on a Node in your cluster. The Pod remains on that node until the Pod finishes execution, the Pod object is deleted, the Pod is evicted for lack of resources, or the node fails.

Untuk pembahasan lebih lanjutnya, seperti biasa kita akan bagi menjadi beberapa bagian diantaranya:

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

You can use workload resources to create and manage multiple Pods for you. A controller for the resource handles replication and rollout and automatic healing in case of Pod failure. For example, if a Node fails, a controller notices that Pods on that Node have stopped working and creates a replacement Pod. The scheduler places the replacement Pod onto a healthy Node.

Here are some examples of workload resources that manage one or more Pods:

1. **Deployment**, managed replicated application on your cluster
2. **StatefulSet**, managed deployment and scalling of a set of Pods with durable storage and persisten identifiers for each Pod.
3. **DaemonSet**, Ensures a copy of a Pod is running accress a set of nodes in a cluster 