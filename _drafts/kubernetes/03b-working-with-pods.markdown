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

Hai semuanya, di materi kali ini kita akan membahas Working with pods in kubernetes cluster. Seperti yang telah kita bahas di artikel sebelumnya mekipun kita sebetulnnya akan jarang sekali membuat pods secara explicit tpi tidak ada salahnya untuk kita bahas lebih detail ya tentang pod ini. 

Pods are designed as relatively ephemeral, disposable entities. When a Pod gets created (directly by you, or indirectly by a controller), the new Pod is scheduled to run on a Node in your cluster. The Pod remains on that node until the Pod finishes execution, the Pod object is deleted, the Pod is evicted for lack of resources, or the node fails.

> Note: Restarting a container in a Pod should not be confused with restarting a Pod. A Pod is not a process, but an environment for running container(s). A Pod persists until it is deleted.

When you create the manifest for a Pod object, make sure the name specified is a valid DNS subdomain name.

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

Pods are designed as relatively ephemeral, disposable entities. 

You can use workload resources to create and manage multiple Pods for you. A controller for the resource handles replication and rollout and automatic healing in case of Pod failure. For example, if a Node fails, a controller notices that Pods on that Node have stopped working and creates a replacement Pod. The scheduler places the replacement Pod onto a healthy Node.

Here are some examples of workload resources that manage one or more Pods:

1. **Deployment**, managed replicated application on your cluster
2. **StatefulSet**, managed deployment and scalling of a set of Pods with durable storage and persisten identifiers for each Pod.
3. **DaemonSet**, Ensures a copy of a Pod is running accress a set of nodes in a cluster 

## Pod templates

Controllers for workload resources create Pods from a pod template and manage those Pods on your behalf. 

PodTemplates are specifications for creating Pods, and are included in workload resources such as **Deployments**, **Jobs**, and **DaemonSets**.

Each controller for a workload resource uses the `PodTemplate` inside the workload object to make actual Pods. The `PodTemplate` is part of the desired state of whatever workload resource you used to run your app.

The sample below is a manifest for a simple Job with a `template` that starts one container. The container in that Pod prints a message then pauses.

{% highlight yaml %}
apiVersion: batch/v1
kind: Job
metadata:
  name: hello
spec:
  template:
    # This is the pod template
    spec:
      containers:
      - name: hello
        image: busybox:1.28
        command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
      restartPolicy: OnFailure
    # The pod template ends here
{% endhighlight %}

Modifying the pod template or switching to a new pod template has no direct effect on the Pods that already exist. If you change the pod template for a workload resource, that resource needs to create replacement Pods that use the updated template.

For example, the StatefulSet controller ensures that the running Pods match the current pod template for each StatefulSet object. If you edit the StatefulSet to change its pod template, the StatefulSet starts to create new Pods based on the updated template. Eventually, all of the old Pods are replaced with new Pods, and the update is complete.

> Note: Each workload resource implements its own rules for handling changes to the Pod template.

## Pod update and replacement