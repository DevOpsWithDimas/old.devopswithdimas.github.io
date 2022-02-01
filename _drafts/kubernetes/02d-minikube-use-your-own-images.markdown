---
layout: post
title: "Using your own image into Minikube cluster"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/handbook/pushing/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02d-minikube-push-images
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas Menggunakan image yang kita buat pada Kubernetes cluster dengan Minikube. Jadi selain menggunakan service yang di publish oleh official image docker/podman terkadang kita juga perlu menjalankan service docker/podman image yang kita buat sendiri. Ada beberapa cara yang bisa kita gunakan pada Minikube cluster

1. Save/Load from archive `.tar` files
2. Build container image in minikube cluster
3. Publish to public registry
4. Publish to private/insecure registry

Ok langsung aja kita ke pembahasan yang pertama

## Save/Load from archive `.tar` files

Untuk menggunakan Save/Load Container image pada minikube, kita perlu build dulu image yang akan kita gunakan, contohnya berikut adalah file `Dockerfile` 

{% gist page.gist "02d-dockerfile" %}

Dan berikut adalah file `index.html` yang digunakan pada `Dockerfile` diatas:

{% gist page.gist "02d-index.html" %}

Sekarang kita coba build dengan menggunakan perintah docker seperti berikut:

{% gist page.gist "02d-docker-build-context.bash" %}

Jika dirunning hasilnya seperti berikut:

```powershell
➜ 01-getting-started  docker build -t dimmaryanto93/kubernetes-cource:1.0 .
[+] Building 3.9s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                           0.0s
 => => transferring dockerfile: 31B                                                            0.0s
 => [internal] load .dockerignore                                                              0.0s
 => => transferring context: 2B                                                                0.0s
 => [internal] load metadata for docker.io/library/nginx:mainline                              3.8s
 => [internal] load build context                                                              0.0s
 => => transferring context: 32B                                                               0.0s
 => [1/2] FROM docker.io/library/nginx:mainline@sha256:2834dc507516af02784808c5f48b7cbe38b8ed  0.0s
 => CACHED [2/2] COPY index.html /usr/share/nginx/html/                                        0.0s
 => exporting to image                                                                         0.0s
 => => exporting layers                                                                        0.0s
 => => writing image sha256:7b1c3ff864355cd0c597c87ba6bf6bed73f8313bd30e9e2ce1ea9575bb749963   0.0s
 => => naming to docker.io/dimmaryanto93/kubernetes-cource:1.0
```

Sekarang setelah kita memiliki container image, kita akan load container image tersebut ke minikube cluster dengan menggunakan perintah `minikube image` 

```powershell
➜ 01-getting-started  minikube image -h
Manage images

Available Commands:
  build       Build a container image in minikube
  load        Load a image into minikube
  ls          List images
  pull        Pull images
  push        Push images
  rm          Remove one or more images
  save        Save a image from minikube
  tag         Tag images

Use "minikube <command> --help" for more information about a given command.
```

Pertama kita akan menggunakan perintah `image load` command pada minikube, Untuk perintah load kita bisa menggunakan 2 cara yaitu directly from docker image atau dengan load from file `.tar`. Nah kalau saya sendiri lebih sering menggunakan directly from docker image dengan perintah seperti berikut:

{% gist page.gist "02d-minikube-load-docker-image.bash" %}

Jika sudah selesai, kita bisa lihat dengan menggunakan perintah

{% gist page.gist "02d-minikube-image-list.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 01-getting-started  minikube image load dimmaryanto93/kubernetes-cource:1.0

➜ 01-getting-started  minikube image ls
...
docker.io/dimmaryanto93/kubernetes-cource:1.0
```

Nah sekarang setelah imagenya tersedia di cluster, kita bisa jalankan dengan menggunakan perintah `kubectl run --image-pull-policy='Never'` seperti berikut:

{% gist page.gist "02d-kubectl-run-load-image.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 01-getting-started  kubectl run nginx-app --image='dimmaryanto93/kubernetes-cource:1.0' --image-pull-policy='Never' --port=80
pod/nginx-app created

➜ 01-getting-started  kubectl get pod
NAME        READY   STATUS    RESTARTS   AGE
nginx-app   1/1     Running   0          10s
```