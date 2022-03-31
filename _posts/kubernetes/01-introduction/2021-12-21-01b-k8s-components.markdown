---
layout: post
title: "Kubernetes Components"
date: 2021-12-21T04:11:18+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/concepts/overview/components/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01b-kubernetes-components
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, sebelum kita mulai menggunakan teknology Kubernetes kita akan berkenalan dulu dengan macam-macam component pada Kubernetes dalam suatu cluster. Beberapa komponen pada kubernetes di bagi menjadi 

1. Control Plane Components
2. Node Components
3. Addons

Ok lansung aja kita bahas satu-per-satu, mulai dari

<!--more-->

## Control Plane Components

The control plane's components make global decisions about the cluster (for example, scheduling), as well as detecting and responding to cluster events (for example, starting up a new pod when a deployment's `replicas` field is unsatisfied).

Control plane components can be run on any machine in the cluster. However, for simplicity, set up scripts typically start all control plane components on the same machine, and do not run user containers on this machine. See [Creating Highly Available clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/) for an example control plane setup that runs across multiple VMs.

Dalam Control Plane dibagi lagi menjadi beberapa sub component yaitu

1. **kube-apiserver**, The API server is a component of the Kubernetes control plane that exposes the Kubernetes API. The API server is the front end for the Kubernetes control plane. The main implementation of a Kubernetes API server is [kube-apiserver](https://kubernetes.io/docs/reference/generated/kube-apiserver/). kube-apiserver is designed to scale horizontally—that is, it scales by deploying more instances. You can run several instances of kube-apiserver and balance traffic between those instances.
2. **etcd**, Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data. If your Kubernetes cluster uses etcd as its backing store, make sure you have a back up plan for those data. You can find in-depth information about etcd in the [official documentation](https://etcd.io/docs/).
3. **kube-scheduler**, Control plane component that watches for newly created Pods with no assigned node, and selects a node for them to run on.
4. **kube-controller-manager**, Control plane component that runs controller processes. Some types of these controllers are:
    1. **Node controller**: Responsible for noticing and responding when nodes go down.
    2. **Job controller**: Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
    3. **Endpoints controller**: Populates the Endpoints object (that is, joins Services & Pods).
    4. **Service Account & Token controllers**: Create default accounts and API access tokens for new namespaces.
5. **cloud-controller-manager**, The cloud-controller-manager only runs controllers that are specific to your cloud provider such as [GKE](https://cloud.google.com/kubernetes-engine), [Amazon EKS](https://aws.amazon.com/id/eks/), [Openshift](https://www.redhat.com/en/technologies/cloud-computing/openshift), etc. If you are running Kubernetes on your own premises, or in a learning environment inside your own PC, the cluster does not have a cloud controller manager. As with the kube-controller-manager, the cloud-controller-manager combines several logically independent control loops into a single binary that you run as a single process. The following controllers can have cloud provider dependencies:
    1. **Node controller**: For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
    2. **Route controller**: For setting up routes in the underlying cloud infrastructure
    3. **Service controller**: For creating, updating and deleting cloud provider load balancers

## Node Components

Node components run on every node, maintaining running pods and providing the Kubernetes runtime environment.

Komponen didalamnya terdiri dari

1. **kubelet**, An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod. The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy. The kubelet doesn't manage containers which were not created by Kubernetes.
2. **kube-proxy**, kube-proxy is a network proxy that runs on each node in your cluster, implementing part of the Kubernetes Service concept. kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster. kube-proxy uses the operating system packet filtering layer if there is one and it's available. Otherwise, kube-proxy forwards the traffic itself.
3. **Container runtime**, The container runtime is the software that is responsible for running containers. Kubernetes supports several container runtimes: [Docker](https://www.docker.com/), [containerd](https://containerd.io/), [CRI-O](https://cri-o.io/), and any implementation of the Kubernetes CRI (Container Runtime Interface).

## Addons

Addons use Kubernetes resources (DaemonSet, Deployment, etc) to implement cluster features. Because these are providing cluster-level features, namespaced resources for addons belong within the `kube-system` namespace.

Selected addons are described below; for an extended list of available addons, please see [Addons](https://kubernetes.io/docs/concepts/cluster-administration/addons/).

Selain dalam list tersebut yang sifatnya optional, ada juga Addons yang sifatnya mandatory/useful seperti

1. **Cluster DNS**, Cluster DNS is a DNS server, in addition to the other DNS server(s) in your environment, which serves DNS records for Kubernetes services. Containers started by Kubernetes automatically include this DNS server in their DNS searches.
2. **Web UI (Dashboard)**, [Dashboard](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/) is a general purpose, web-based UI for Kubernetes clusters. It allows users to manage and troubleshoot applications running in the cluster, as well as the cluster itself.
3. **Container Resource Monitoring**, Container Resource Monitoring records generic time-series metrics about containers in a central database, and provides a UI for browsing that data.
4. **Cluster-level Logging**, A cluster-level logging mechanism is responsible for saving container logs to a central log store with search/browsing interface.