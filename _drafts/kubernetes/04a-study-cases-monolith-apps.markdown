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

Hai semuanya, di materi study cases untuk Pod dan Container specification kita coba create, and build  aplikasi monolith dengan framework Laravel Web MVC (Model View Controller) dengan architecture seperti berikut:

![architecture mvc]({{ page.image_path | prepend: site.baseurl }}/monolith-architecture.png)

Mengapa kita membahas ini, seperti yang temen-temen ketahui hampir `85%` aplikasi yang ada masih menggunakan architecture tersebut, mungkin dari beberapa temen-temen pernah mengalami begitu aplikasi tersebut diakses secara public atau banyak orang mengakases aplikasi terasa lambat dalam mereseponse atau tiba-tiba mati (downtime) hal ini penyebabnya bisa macam-macam tapi salah satu penyebabnya adalah server tidak mampu menghandle request yang masuk sehingga menyebabkan performa dari aplikasi menurun. 

Sebetulnya ada banyak solusi dari masalah tersebut, misalnya 

1. Replikasi aplikasi
2. Cloning server (node) baik berbentuk virtual maupun physical

Kubernetes memprovide solusi terserbut dengan High Availablity, Self Healing, Auto scaling dan lain-lain. So jadi kita akan migrasikan aplikasi terserbut supaya bisa jalan di atas kubernetes dengan tujuan untuk memudahkan di maintanance secara operational, mudah di scale up and down serta meningkatkan zero down time. Adapun step by step yang akan kita lakukan adalah

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