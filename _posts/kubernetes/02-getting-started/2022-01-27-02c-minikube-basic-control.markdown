---
layout: post
title: "Minikube basic control"
date: 2022-01-27T18:55:11+07:00
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/handbook/controls/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02c-minikube-manage-cluster
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas dulu basic penggunaan dari minikube seperti

1. Start/Stop cluster
2. Multiple cluster on same machine
3. Delete cluster

Ok langsung ja kita bahas materi yang pertama 

## Start/Stop kubernetes cluster

Dengan menggunakan minikube kita bisa management cluster seperti start/stop. Feature ini berguna karena kubernetes cluster menggunakan lumayan besar sometime juga kita tidak menggunakan cluster tersebut tetapi kita bisa menyimpan container yang akan kita gunakan di kemudian hari. Ok pada saat pertama kali init cluster kita sudah menggunakan `minikube start --option` jika kita mau menjankan kita bisa menggunakan peritah 

{% gist page.gist "02c-minikube-start.bash" %}

Jika kita mau stop service kubernetes cluster pada minikube, kita bisa menggunakan perintah 

{% gist page.gist "02c-minikube-stop.bash" %}

## Multiple cluster on same machine

Dengan menggunakan minikube kita bisa membuat multiple cluster dalam 1 machine, Feature ini berguna sakali jika kita bekerja dengan banyak project/team karena biasanya setiap project memiliki environment masing-masing.

Artinya setiap object per-project akan di buatkan masing-masing cluster atau juga biasanya kita memiliki 3 environtment yaitu test, staging dan production. Setiap environment memungkinkan untuk menggunakan stack yang berbeda contohnya pada Test hanya menggunakan single database transaction sedangkan untuk production menggunakan clustered database transaction. Maka dari itu biasanya kita akan pisahkan secara kubernetes clusternya.

Di minikube kita bisa memembuat kubernetes cluster baru dengan menggunakan / parsing argument `-p <cluster-name>` pada `minikube start` seperti berikut contohnya

{% gist page.gist "02c-minikube-start-other-cluster.bash" %}

Dan untuk melihat daftar project pada minikube kita bisa menggunakan perintah berikut:

{% gist page.gist "02c-minikube-list-cluster.bash" %}

Dan jika kita mau stop cluster tersebut menggukan perintah berikut:

{% gist page.gist "02c-minikube-stop-other-cluster.bash" %}

## Delete cluster

Dengan menggunakan minikube juga kita bisa menghapus cluster yang sudah kita gunakan, dengan menggunakan perintah:

{% gist page.gist "02c-minikube-delete-profile.bash" %}

Selain itu juga kita bisa menghapus semua cluster yang ada, dengan menggunakan perintah berikut:

{% gist page.gist "02c-minikube-delete-all.bash" %}