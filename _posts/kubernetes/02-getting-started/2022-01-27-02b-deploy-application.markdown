---
layout: post
title: "Deploying an apps/services into Kubernetes"
date: 2022-01-27T12:59:08+07:00
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
image_path: /resources/posts/kubernetes/02b-deploy-application
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Basic of Kubernetes untuk Container orchestration system menggunakan minikube (Learning environment). Diantaranya yang akan kita bahas

1. Deploy a containerized application on a cluster.
2. Viewing Pods and Nodes.
3. Expose Your App Publicly.
4. Scale the deployment.
5. Update the containerized application with a new software version.
6. Debug the containerized application.

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

![pod-overview]({{ page.image_path | prepend: site.baseurl }}/03-pods.png)

A Pod always runs on a **Node**. A Node is a worker machine in Kubernetes and may be either a virtual or a physical machine, depending on the cluster.

![node-overview]({{ page.image_path | prepend: site.baseurl }}/04-nodes.png)

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

## Expose Your App Publicly

When you created a Deployment, by default you can't access that service directly. to Expose your container you need a Kubernetes Service. A Service in Kubernetes is an abstraction which defines a logical set of Pods and a policy by which to access them. Services enable a loose coupling between dependent Pods. 

Although each Pod has a unique IP address, those IPs are not exposed outside the cluster without a Service. Services can be exposed in different ways by specifying a type in the ServiceSpec:

1. **ClusterIP** (default) - Exposes the Service on an internal IP in the cluster. This type makes the Service only reachable from within the cluster.
2. **NodePort** - Exposes the Service on the same port of each selected Node in the cluster using NAT. Makes a Service accessible from outside the cluster using `<NodeIP>:<NodePort>`. Superset of ClusterIP.
3. **LoadBalancer** - Creates an external load balancer in the current cloud (if supported) and assigns a fixed, external IP to the Service. Superset of NodePort.
4. **ExternalName** - Maps the Service to the contents of the externalName field (e.g. `foo.bar.example.com`), by returning a CNAME record with its value. No proxying of any kind is set up. This type requires v1.7 or higher of kube-dns, or CoreDNS version 0.0.8 or higher.

First take a look list of services using `get services` command: 

{% gist page.gist "02b-get-service.bash" %}

By default we have a services called `kubernetes` created when kubernetes cluster started. To create a new service and expose to external traffic we'll use `expose` command with type `NodePort` as parameter.

{% gist page.gist "02b-create-service-node-port.bash" %}

Ok cool!, let's run again `get service` command, to view list of services created.

```bash
➜ ~  kubectl get service
NAME           TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)        AGE
kubernetes     ClusterIP   10.96.0.1      <none>        443/TCP        49m
nginx-deploy   NodePort    10.102.0.219   <none>        80:30733/TCP   68s
```

You will see, `nginx-deploy` service. kita bisa check portnya di kolom `PORT(S)` yaitu `80:30733/TCP` 

- Port `80` adalah port container
- Port `30733` adalah port exposed

Jadi kita bisa mengkasesnya dengan port `30733`. Karena kita menjalankan menggunakan minikube dengan driver virtualbox jadi kita bisa ambil ip nya menggunakan `minikube ip` seperti berikut:

```bash
➜ ~  minikube ip minikube
192.168.59.105
```

Maka kita bisa akes dari browser dengan alamat `http://192.168.59.105:30733` hasilnya seperti berikut:

![nginx-deploy]({{ page.image_path | prepend: site.baseurl }}/02-nginx-exposed.png)

## Scale the deployment

In the previous modules we created a Deployment, and then exposed it publicly via a Service. The Deployment created only one Pod for running our application. When traffic increases, we will need to scale the application to keep up with user demand. 

![scaling-application]({{ page.image_path | prepend: site.baseurl }}/05-services.png)

Scaling out a Deployment will ensure new Pods are created and scheduled to Nodes with available resources. Scaling will increase the number of Pods to the new desired state.

Running multiple instances of an application will require a way to distribute the traffic to all of them. Services have an integrated load-balancer that will distribute network traffic to all Pods of an exposed Deployment.

Next, let's scale the Deployment to 4 replicas. We'll use the `kubectl scale` command, followed by deployment type, name and disired number of instances:

{% gist page.gist "02b-deploy-scale.bash" %}

To list your deployment state use `get deploy`:

{% gist page.gist "02b-get-deploy.bash" %}

The change was applied and we have 4 instance of application available. Next, let's check if number of Pods changed:

{% gist page.gist "02b-get-pod-out-wide.bash" %}

There are 4 pods now, with different IP address. The change was registered in the Deployment event logs. To check that, use `kubectl describe` command:

{% gist page.gist "02b-describe-deploy.bash" %}

You can also view in the output of this command that there are 4 replicas now.

## Update the containerized application with a new software version.

Users expect applications to be available all the time and developers are expected to deploy new versions of them several times a day. In Kubernetes this is done with rolling updates. **Rolling updates** allow Deployments' update to take place with zero downtime by incrementally updating Pods instances with new ones. The new Pods will be scheduled on Nodes with available resources.

Similar to application Scaling, if a Deployment is exposed publicly, the Service will load-balance the traffic only to available Pods during the update. Rolling updates allow the following actions:

1. Promote an application from one environment to another (via container image updates)
2. Rollback to previous versions
3. Continuous Integration and Continuous Delivery of applications with zero downtime

To update the image of application to next version, use the `set image` command, followed by deployment name, container name and the new image version:

{% gist page.gist "02b-set-new-image.bash" %}

The command notified the Deployment to use a different image from your app and initiated a rolling update. To check the status of new Pods and view the old one terminate with the `get pods`

{% gist page.gist "02b-get-pods.bash" %}

## Debug the containerized application.

Setelah kita memcoba meng-operasikan kubernetes dengan `kubectl` command, sekarang kita akan membahas bagaimana cara melakukan debug pada Pod yang sedang berjalan (running) atau yang failed (crashing) pada Node. Untuk melakukan debug kita bisa menggunakan beberapa cara yaitu

1. `logs` command
2. `describe` command
3. `exec` command

Examining pod logs. First, look at the logs of the affected container:

{% highlight bash %}
kubectl logs ${POD_NAME} ${CONTAINER_NAME}
{% endhighlight %}

Example:

{% gist page.gist "02b-logs-pod.bash" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  kubectl get pods
NAME                            READY   STATUS         RESTARTS   AGE
nginx-deploy-7ffddfc8f8-66mbk   0/1     ErrImagePull   0          31s

➜ ~  kubectl logs nginx-deploy-7ffddfc8f8-66mbk
Error from server (BadRequest): container "nginx" in pod "nginx-deploy-7ffddfc8f8-66mbk" is waiting to start: trying and failing to pull image
```

If you want more detail, use `describe` command:

{% highlight bash %}
kubectl describe pod ${POD_NAME}
{% endhighlight %}

Example:

{% gist page.gist "02b-pod-describe.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  kubectl describe pod nginx-deploy
Name:         nginx-deploy-7ffddfc8f8-66mbk
Namespace:    default
Priority:     0
Node:         minikube/192.168.49.2
Start Time:   Tue, 25 Jan 2022 05:21:45 +0700
Labels:       app=nginx-deploy
              pod-template-hash=7ffddfc8f8
Annotations:  <none>
Status:       Pending
IP:           172.17.0.3
IPs:
  IP:           172.17.0.3
Controlled By:  ReplicaSet/nginx-deploy-7ffddfc8f8
Containers:
  nginx:
    Container ID:
    Image:          nginx:0.0.0
    Image ID:
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-72dhn (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             False
  ContainersReady   False
  PodScheduled      True
Volumes:
  kube-api-access-72dhn:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  94s                default-scheduler  Successfully assigned default/nginx-deploy-7ffddfc8f8-66mbk to minikube
  Normal   Pulling    30s (x3 over 94s)  kubelet            Pulling image "nginx:0.0.0"
  Warning  Failed     25s (x3 over 77s)  kubelet            Failed to pull image "nginx:0.0.0": rpc error: code = Unknown desc = Error response from daemon: manifest for nginx:0.0.0 not found: manifest unknown: manifest unknown
  Warning  Failed     25s (x3 over 77s)  kubelet            Error: ErrImagePull
  Normal   BackOff    0s (x4 over 76s)   kubelet            Back-off pulling image "nginx:0.0.0"
  Warning  Failed     0s (x4 over 76s)   kubelet            Error: ImagePullBackOff
```

You can see at the Events has message: `Back-off pulling image "nginx:0.0.0"` it's mean docker image `nginx` version `0.0.0` not valid or not available on registries.

Or somethime error logs trigger at runtime and produce using file not on stdout by default. use `exec` command to interact inside container

{% highlight bash %}
kubectl exec -it deploy/${DEPLOYMENT_NAME} -c ${CONTAINER_NAME} -- ${APPS} ${ARGS1 ...}
{% endhighlight %}

Example:

{% gist page.gist "02b-exec-container.bash" %}