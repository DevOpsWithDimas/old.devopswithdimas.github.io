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
image_path: /resources/posts/kubernetes/03e-distruptions
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

