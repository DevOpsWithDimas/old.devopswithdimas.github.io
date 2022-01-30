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
- https://minikube.sigs.k8s.io/docs/tutorials/multi_node/
- https://minikube.sigs.k8s.io/docs/commands/ssh/
- https://minikube.sigs.k8s.io/docs/handbook/registry/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02c-minikube-manage-cluster
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas dulu basic penggunaan dari minikube seperti

1. Start/Stop cluster
2. Delete cluster
3. Multiple cluster on same machine
4. Multiple nodes on a cluster
5. Accessing a node using ssh

Ok langsung ja kita bahas materi yang pertama 

## Start/Stop kubernetes cluster

Dengan menggunakan minikube kita bisa management cluster seperti start/stop. Feature ini berguna karena kubernetes cluster menggunakan lumayan besar sometime juga kita tidak menggunakan cluster tersebut tetapi kita bisa menyimpan container yang akan kita gunakan di kemudian hari. Ok pada saat pertama kali init cluster kita sudah menggunakan `minikube start --option` jika kita mau menjankan kita bisa menggunakan peritah 

{% gist page.gist "02c-minikube-start.bash" %}

Jika kita mau stop service kubernetes cluster pada minikube, kita bisa menggunakan perintah 

{% gist page.gist "02c-minikube-stop.bash" %}

## Delete cluster

Dengan menggunakan minikube juga kita bisa menghapus cluster yang sudah kita gunakan, dengan menggunakan perintah:

{% gist page.gist "02c-minikube-delete-profile.bash" %}

Selain itu juga kita bisa menghapus semua cluster yang ada, dengan menggunakan perintah berikut:

{% gist page.gist "02c-minikube-delete-all.bash" %}

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

## Accessing a node using ssh

Dengan menggunakan minikube juga kita bisa log into node using ssh untuk debugging terkait dengan kubernetes components (api-server, kubelet, cni, container runtime), dengan menggunakan perintah `minikube ssh`.

{% highlight bash %}
minikube ssh -h
{% endhighlight %}

Maka outputnya seperti berikut:

```powershell
➜ ~  minikube ssh -h
Log into or run a command on a machine with SSH; similar to 'docker-machine ssh'.

Options:
      --native-ssh=true: Use native Golang SSH client (default true). Set to 'false' to use the
command line 'ssh' command when accessing the docker machine. Useful for the machine drivers when
they will not start with 'Waiting for SSH'.
  -n, --node='': The node to ssh into. Defaults to the primary control plane.

Usage:
  minikube ssh [flags] [options]

Use "minikube options" for a list of global command-line options (applies to all commands).
```

Untuk melihat daftar nodes kita bisa menggunakan perintah:

{% gist page.gist "02c-minikube-node-list.bash" %}

Sekarang kita akan coba login ke node `multiple-nodes-m03` maka perintahnya seperti berikut:

{% gist page.gist "02c-minikube-ssh-login.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  minikube ssh -n multiple-nodes-m03
                         _             _
            _         _ ( )           ( )
  ___ ___  (_)  ___  (_)| |/')  _   _ | |_      __
/' _ ` _ `\| |/' _ `\| || , <  ( ) ( )| '_`\  /'__`\
| ( ) ( ) || || ( ) || || |\`\ | (_) || |_) )(  ___/
(_) (_) (_)(_)(_) (_)(_)(_) (_)`\___/'(_,__/''`\____)

$ docker info
Client:
 Context:    default
 Debug Mode: false

Server:
 Containers: 7
  Running: 6
  Paused: 0
  Stopped: 1
 Images: 12
 Server Version: 20.10.12
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: systemd
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 io.containerd.runtime.v1.linux runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 7b11cfaabd73bb80907dd23182b9347b4245eb5d
 runc version: 52b36a2dd837e8462de8e01458bf02cf9eea47dd
 init version: de40ad0
 Security Options:
  seccomp
   Profile: default
 Kernel Version: 4.19.202
 Operating System: Buildroot 2021.02.4
 OSType: linux
 Architecture: x86_64
 CPUs: 2
 Total Memory: 3.335GiB
 Name: multiple-nodes-m03
 ID: GBLY:WYNL:WWKN:5OKS:WE2Y:5H3R:JICT:KOML:3XE5:R32H:Q64S:RKGL
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 No Proxy: 192.168.59.110,192.168.59.111
 Registry: https://index.docker.io/v1/
 Labels:
  provider=virtualbox
 Experimental: false
 Insecure Registries:
  10.96.0.0/12
  127.0.0.0/8
 Live Restore Enabled: false
 Product License: Community Engine

WARNING: No blkio throttle.read_bps_device support
WARNING: No blkio throttle.write_bps_device support
WARNING: No blkio throttle.read_iops_device support
WARNING: No blkio throttle.write_iops_device support
```