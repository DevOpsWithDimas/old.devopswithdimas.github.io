---
layout: post
title: "Deploying an apps/services into Kubernetes"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/tutorials/kubernetes-basics/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02c-getting-started
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Basic of Kubernetes untuk Container orchestration system menggunakan minikube (Learning environment). Diantaranya yang akan kita bahas

1. Deploy a containerized application on a cluster.
2. Viewing Pods and Nodes
3. 
3. Scale the deployment.
4. Update the containerized application with a new software version.
5. Debug the containerized application.

## Deploy a containerized application on a cluster

Once you have a running Kubernetes cluster, you can deploy your containerized applications on top of it. To do so, you create a Kubernetes Deployment configuration.

Let's deploy nginx application on Kubernetes with command `kubectl create deployment` command. We need to provide the deployment name and image location (Docker/Podman image from [Docker Hub](https://hub.docker.com/) or insecure-registry)

{% gist page.gist "02b-create-deploy-command.bash" %}

Great! you just deployed your first application by creating a deployment. This performed a few thing for you:

1. Searched for suitable node where an instance of application could be run
2. Schedule the application to run on that node
3. Configured the cluster to reschedule the instance on a new Node when need

To check list of your deployment use `get deploy` or `get deployment` command.

```bash
➜ ~  kubectl get deploy
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   1/1     1            1           40s

➜ ~  kubectl describe deploy nginx-deploy
Name:                   nginx-deploy
Namespace:              default
CreationTimestamp:      Sun, 23 Jan 2022 18:53:09 +0700
Labels:                 app=nginx-deploy
Annotations:            deployment.kubernetes.io/revision: 1
Selector:               app=nginx-deploy
Replicas:               1 desired | 1 updated | 1 total | 1 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx-deploy
  Containers:
   nginx:
    Image:        nginx
    Port:         <none>
    Host Port:    <none>
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deploy-6c758c8d46 (1/1 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  59s   deployment-controller  Scaled up replica set nginx-deploy-6c758c8d46 to 1
```

## Viewing Pods and Nodes

When you created a Deployment, Kubernetes created a **Pod** to host your application instance. A Pod is a Kubernetes abstraction that represents a group of one or more application containers (such as Docker), and some shared resources for those containers. Those resources include:

1. Shared storage, as Volumes
2. Networking, as a unique cluster IP address
3. Information about how to run each container, such as the container image version or specific ports to use

![pod-overview](https://d33wubrfki0l68.cloudfront.net/fe03f68d8ede9815184852ca2a4fd30325e5d15a/98064/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg)

A Pod always runs on a **Node**. A Node is a worker machine in Kubernetes and may be either a virtual or a physical machine, depending on the cluster.

![node-overview](https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg)

To view list of pods currently running in your cluster use `get pods`:

{% gist page.gist "02b-get-pods.bash" %}

To view list of nodes use `get node` :

{% gist page.gist "02b-get-node.bash" %}

To view list of pods with where instances are running you can use `get pods -o wide`

{% gist page.gist "02b-get-pod-out-wide.bash" %}

Ketika dijalankan maka hasilnya seperti berikut:

```bash
➜ ~  kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
nginx-deploy-6c758c8d46-s8nrj   1/1     Running   0          22m

➜ ~  kubectl get node
NAME       STATUS   ROLES                  AGE   VERSION
minikube   Ready    control-plane,master   31m   v1.23.1

➜ ~  kubectl get pods -o wide
NAME                            READY   STATUS    RESTARTS   AGE   IP           NODE       NOMINATED NODE   READINESS GATES
nginx-deploy-6c758c8d46-s8nrj   1/1     Running   0          22m   172.17.0.3   minikube   <none>           <none>
```