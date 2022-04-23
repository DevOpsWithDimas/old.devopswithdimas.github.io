---
layout: post
title: "Pod Lifecycle"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03c-pod-lifecycle
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Pod Lifecycle. Pods follow a defined lifecycle, starting in the `Pending` phase, moving through `Running` if at least one of its primary containers starts OK, and then through either the `Succeeded` or `Failed` phases depending on whether any container in the Pod terminated in failure.

Whilst a Pod is `running`, the kubelet is able to `restart` containers to handle some kind of faults. Within a Pod, Kubernetes tracks different container `states` and determines what action to take to make the Pod healthy again.

In the Kubernetes API, Pods have both a specification and an actual status. The status for a Pod object consists of a set of Pod conditions. You can also inject custom readiness information into the condition data for a Pod, if that is useful to your application.

Pods are only scheduled once in their lifetime. Once a Pod is scheduled (assigned) to a Node, the Pod runs on that Node until it stops or is terminated.

Ok untuk lebih detailnya kita akan bagi-bagi menjadi beberapa section yaitu:

1. Pod lifetime
2. Pod phase
3. Container states
4. Container restart policy
5. Container probes
6. Termination of Pods

Ok lansung aja kita bahas materi yang pertama

<!--more-->

## Pod lifetime

