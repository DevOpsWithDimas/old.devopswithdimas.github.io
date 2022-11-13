---
layout: post
title: "Pod Disruptions"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/disruptions/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/03i-distruption
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, sebelumnya kita sudah membahas secara detail tentang Pod Specification selanjutnya jika kita mau membuat aplikasi yang support dengan Highly Available containers pada kubernetes kita harus memahami System yang namanya Distruption dan juga beberapa cluster administration upgrading and autoscaling clusters.

So karena pembahasannya ini akan lumayan panjang jadi kita akan bagi-bagi menjadi beberapa bagian diantaranya:

1. Voluntary and involuntary disruptions
2. Dealing with disruptions
3. Pod disruption budgets
4. Pod disruption conditions

Ok tanpa berlama-lama yuk lansung aja kita bahas materi yang pertama:

<!--more-->

## Voluntary and involuntary disruptions

Pods do not disappear until someone (a person or a controller) destroys them, or there is an unavoidable hardware or system software error.

We call these unavoidable cases involuntary disruptions to an application. Examples are:

![deletes vm(instances)]({{ page.image_path | prepend: site.baseurl }}/01-cluster-deletes-vm.png)

1. a hardware failure of the physical machine backing the node
2. cluster administrator deletes VM (instance) by mistake
3. cloud provider or hypervisor failure makes VM disappear
4. a kernel panic
5. the node disappears from the cluster due to cluster network partition
6. eviction of a pod due to the node being out-of-resources.

Except for the out-of-resources condition, all these conditions should be familiar to most users; they are not specific to Kubernetes.

We call other cases voluntary disruptions. These include both actions initiated by the application owner and those initiated by a Cluster Administrator. 

Typical application owner actions include:

![delete resources]({{ page.image_path | prepend: site.baseurl }}/02-resource-k8s-deleted.png)

1. Deleting the deployment or other controller that manages the pod
2. Updating a deployment's pod template causing a restart
3. Directly deleting a pod (e.g. by accident)

Cluster administrator actions include:

1. Draining a node for repair or upgrade.
2. Draining a node from a cluster to scale the cluster down (learn about Cluster Autoscaling ).
3. Removing a pod from a node to permit something else to fit on that node.

These actions might be taken directly by the cluster administrator, or by automation run by the cluster administrator, or by your cluster hosting provider.