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
3. Multiple nodes on a cluster
4. Accessing a node using ssh
5. Delete cluster

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

## Multiple nodes on a cluster

Dengan menggunakan minikube juga kita bisa setup suatu kubernetes cluster dengan configuration multi nodes (banyak server/vm), dengan cara men-specify `--nodes` pada `minikube start` command. Berikut contohnya penggunaanya:

{% gist page.gist "02c-minikube-multiple-nodes.bash" %}

Untuk melihat daftar list dari nodes yang telah di register menggunakan perintah

{% gist page.gist "02b-get-node.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  minikube start --nodes 3 --memory 3500MB --no-vtx-check --driver virtualbox -p multiple-nodes
😄  [multiple-nodes] minikube v1.25.1 on Microsoft Windows 11 Pro 10.0.22000 Build 22000
✨  Using the virtualbox driver based on user configuration
👍  Starting control plane node multiple-nodes in cluster multiple-nodes
🔥  Creating virtualbox VM (CPUs=2, Memory=3500MB, Disk=20000MB) ...
❗  This VM is having trouble accessing https://k8s.gcr.io
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
🐳  Preparing Kubernetes v1.23.1 on Docker 20.10.12 ...
    ▪ kubelet.housekeeping-interval=5m
    ▪ kubelet.cni-conf-dir=/etc/cni/net.mk
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring CNI (Container Networking Interface) ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🌟  Enabled addons: storage-provisioner, default-storageclass
🔎  Verifying Kubernetes components...

👍  Starting worker node multiple-nodes-m02 in cluster multiple-nodes
🔥  Creating virtualbox VM (CPUs=2, Memory=3500MB, Disk=20000MB) ...
🌐  Found network options:
    ▪ NO_PROXY=192.168.59.110
    ▪ no_proxy=192.168.59.110
❗  This VM is having trouble accessing https://k8s.gcr.io
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
🐳  Preparing Kubernetes v1.23.1 on Docker 20.10.12 ...
    ▪ env NO_PROXY=192.168.59.110
🔎  Verifying Kubernetes components...

👍  Starting worker node multiple-nodes-m03 in cluster multiple-nodes
🔥  Creating virtualbox VM (CPUs=2, Memory=3500MB, Disk=20000MB) ...
🌐  Found network options:
    ▪ NO_PROXY=192.168.59.110,192.168.59.111
    ▪ no_proxy=192.168.59.110,192.168.59.111
❗  This VM is having trouble accessing https://k8s.gcr.io
💡  To pull new external images, you may need to configure a proxy: https://minikube.sigs.k8s.io/docs/reference/networking/proxy/
🐳  Preparing Kubernetes v1.23.1 on Docker 20.10.12 ...
    ▪ env NO_PROXY=192.168.59.110
    ▪ env NO_PROXY=192.168.59.110,192.168.59.111
🔎  Verifying Kubernetes components...
🏄  Done! kubectl is now configured to use "multiple-nodes" cluster and "default" namespace by default

➜ ~  minikube status -p multiple-nodes
multiple-nodes
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

multiple-nodes-m02
type: Worker
host: Running
kubelet: Running

multiple-nodes-m03
type: Worker
host: Running
kubelet: Running

➜ ~  kubectl get nodes
NAME                 STATUS   ROLES                  AGE     VERSION
multiple-nodes       Ready    control-plane,master   2m40s   v1.23.1
multiple-nodes-m02   Ready    <none>                 110s    v1.23.1
multiple-nodes-m03   Ready    <none>                 68s     v1.23.1

➜ ~  kubectl create deployment nginx-deploy --image nginx
deployment.apps/nginx-deploy created

➜ ~  kubectl get pods -o wide
NAME                            READY   STATUS    RESTARTS   AGE    IP           NODE                 NOMINATED NODE   READINESS GATES
nginx-deploy-6c758c8d46-g76mc   1/1     Running   0          2m2s   10.244.2.2   multiple-nodes-m03   <none>           <none>

➜ ~  kubectl expose deploy/nginx-deploy --type="NodePort" --port 80
service/nginx-deploy exposed

➜ ~  kubectl get services
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP        10m
nginx-deploy   NodePort    10.99.228.184   <none>        80:30067/TCP   6m2s

➜ ~  minikube node list
multiple-nodes  192.168.59.110
multiple-nodes-m02      192.168.59.111
multiple-nodes-m03      192.168.59.112

➜ ~  curl http://192.168.59.112:30067
StatusCode        : 200
StatusDescription : OK
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 615
                    Content-Type: text/html
                    Date: Sun, 30 Jan 2022 06:43:15 GMT
                    ETag: "61f01158-267"
                    Last-Modified: Tue, 25 Jan 2022 ...
```

## Delete cluster

Dengan menggunakan minikube juga kita bisa menghapus cluster yang sudah kita gunakan, dengan menggunakan perintah:

{% gist page.gist "02c-minikube-delete-profile.bash" %}

Selain itu juga kita bisa menghapus semua cluster yang ada, dengan menggunakan perintah berikut:

{% gist page.gist "02c-minikube-delete-all.bash" %}