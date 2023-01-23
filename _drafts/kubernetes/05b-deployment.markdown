---
layout: post
title: "Workload with Deployment"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/05b-deployment
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, materi sebelumnya kita sudah mencoba menggunakan Kubernetes workload resources dengan Object Deployment yang paling simple. Sekarang kita akan membahas yang lebih detail tentang Object Deployment. Karena pembahasan kali ini lumayan panjang jadi kita bagi2 jadi beberapa bagian diantaranya:

1. What is Deployment Object?
2. Create Deployment using yaml file
3. Writing a Deployment Spec
4. Deployment status
5. Updating a Deployment
6. Scalling a Deployment
7. Rolling back a Deployment
8. Clean up policy

Okay tanpa berlama-lama yuk langsung aja kita bahas materi yang pertama:

<!--more-->

## What is Deployment Object

Seperti yang telah saya bahas di materi sebelumnya, Deployment adalah salah satu Workload resources yang digunakan untuk me-manage Pod dan container yang paling cocok untuk aplikasi Stateless atau tidak menyimpan data. 

A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

![deployment-flow]({{ page.image_path | prepend: site.baseurl }}/deployment-flow.png)

**Note:** Do not manage ReplicaSets owned by a Deployment. Consider opening an issue in the main Kubernetes repository if your use case is not covered below.

The following are typical use cases for Deployments:

1. Create a Deployment to rollout a ReplicaSet. The ReplicaSet creates Pods in the background. Check the status of the rollout to see if it succeeds or not.
2. Declare the new state of the Pods by updating the PodTemplateSpec of the Deployment. A new ReplicaSet is created and the Deployment manages moving the Pods from the old ReplicaSet to the new one at a controlled rate. Each new ReplicaSet updates the revision of the Deployment.
3. Rollback to an earlier Deployment revision if the current state of the Deployment is not stable. Each rollback updates the revision of the Deployment.
4. Scale up the Deployment to facilitate more load.
5. Pause the rollout of a Deployment to apply multiple fixes to its PodTemplateSpec and then resume it to start a new rollout.
6. Use the status of the Deployment as an indicator that a rollout has stuck.
7. Clean up older ReplicaSets that you don't need anymore.

## Create Deployment using yaml file