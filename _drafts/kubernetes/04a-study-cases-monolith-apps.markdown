---
layout: post
title: "Study Cases: Monolith apps"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Pods
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/04a-study-cases-monolith-apps
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi study cases untuk Pod dan Container specification kita coba create, build, convert contoh aplikasi monolith dengan framework Laravel dengan menggunakan method Web MVC (Model View Controller) dengan architecture seperti berikut:

![architecture mvc]({{ page.image_path | prepend: site.baseurl }}/monolith-architecture.png)

Berdasarkan architecture tersebut, step by step yang akan kita lakukan adalah

1. Develop aplikasi tersebut
2. Containerize apps
3. Deploy to Kubernetes
    1. Running as a Pod
    2. Run initContainer for database migration
    3. Using container probe
    4. Using resource request and limit

Ok tanpa berlama-lama yuk langsung aja ke pembahasan yang pertama.

<!--more-->

## Development aplikasi