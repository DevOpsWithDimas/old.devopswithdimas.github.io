---
layout: post
title: "Overview of Kubernetes Workloads"
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
catalog_key: workloads
image_path: /resources/posts/kubernetes/03-k8s-workloads
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya di materi kali ini kita akan membahas lebih detail tentang Kubernetes Workloads. Untuk pembahasannya kita akan bagi menjadi beberapa section yaitu

1. What is Kubernetes Workloads?
2. Build-in Workloads resources in Kubernetes?

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## What is Kubernetes Workloads?

A workload is an application running on Kubernetes. Whether your workload is a single component or several that work together, on Kubernetes you run it inside a set of [pods](https://kubernetes.io/docs/concepts/workloads/pods). In Kubernetes, a Pod represents a set of running containers on your cluster.

Kubernetes pods have a [defined lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/). For example, once a pod is running in your cluster then a critical fault on the node where that pod is running means that all the pods on that node fail. Kubernetes treats that level of failure as final: you would need to create a new Pod to recover, even if the node later becomes healthy.

However, to make life considerably easier, you don't need to manage each Pod directly. Instead, you can use workload resources that manage a set of pods on your behalf. These resources configure controllers that make sure the right number of the right kind of pod are running, to match the state you specified.

## Build-in Workloads resources in Kubernetes

Kubernetes provides several built-in workload resources:

1. [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) and [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/) (replacing the legacy resource ReplicationController). Deployment is a good fit for managing a stateless application workload on your cluster, where any Pod in the Deployment is interchangeable and can be replaced if needed.
2. [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/) lets you run one or more related Pods that do track state somehow. For example, if your workload records data persistently, you can run a StatefulSet that matches each Pod with a [PersistentVolume](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). Your code, running in the Pods for that StatefulSet, can replicate data to other Pods in the same StatefulSet to improve overall resilience.
3. [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/) defines Pods that provide node-local facilities. These might be fundamental to the operation of your cluster, such as a networking helper tool, or be part of an add-on. Every time you add a node to your cluster that matches the specification in a DaemonSet, the control plane schedules a Pod for that DaemonSet onto the new node.
4. [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) and [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/) define tasks that run to completion and then stop. Jobs represent one-off tasks, whereas `CronJobs` recur according to a schedule.

In the wider Kubernetes ecosystem, you can find third-party workload resources that provide additional behaviors. Using a [custom resource definition](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/), you can add in a third-party workload resource if you want a specific behavior that's not part of Kubernetes' core. For example, if you wanted to run a group of `Pods` for your application but stop work unless all the `Pods` are available (perhaps for some high-throughput distributed task), then you can implement or install an extension that does provide that feature.
