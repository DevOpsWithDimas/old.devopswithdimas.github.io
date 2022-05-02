---
layout: post
title: "Initialization of Containers"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/pods/init-containers/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/03c-init-containers
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, setelah kita mempelajari tentang basic Container dan Pod configuration selanjutnya kita bahas Init Containers. Ok seperti biasa karena materi ini akan lumayan panyang jadi kita akan bagi-bagi menjadi beberapa bagian diantaranya:

1. What is init containers
2. Differences from regular containers
3. what are `initContainers` for?
4. Examples using `initContainers`
5. Behavior of initContainers

Ok langsung aja kita bahas ke materi yang pertama

<!--more-->

## What is init containers

A Pod can have multiple containers running apps within it, but it can also have one or more init containers, which are run before the app containers are started. 

Init containers are exactly like regular containers, except:

1. Init containers always run to completion.
2. Each init container must complete successfully before the next one starts.

If a Pod's init container fails, the kubelet repeatedly restarts that init container until it succeeds. However, if the Pod has a `restartPolicy` of Never, and an init container fails during startup of that Pod, Kubernetes treats the overall Pod as failed.

To specify an init container for a Pod, add the `initContainers` field into the Pod specification, as an array of `container` items (similar to the app containers field and its contents).

The status of the init containers is returned in `.status.initContainerStatuses` field as an array of the container statuses (similar to the `.status.containerStatuses` field).

## Differences from regular containers

Mungkin sebagian banyak dari temen-temen bertanya apasih bedanya antara `initContainers` dengan `containers`?

Init containers support all the fields and features of app containers, including resource limits, volumes, and security settings. However, the resource requests and limits for an init container are handled differently, as documented in [Resources](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/#resources).

Also, init containers do not support `lifecycle`, `livenessProbe`, `readinessProbe`, or `startupProbe` because they must run to completion before the Pod can be ready.

If you specify multiple init containers for a Pod, kubelet runs each init container sequentially. Each init container must succeed before the next can run. When all of the init containers have run to completion, kubelet initializes the application containers for the Pod and runs them as usual.

## what are `initContainers` for?

Because init containers have separate images from app containers, they have some advantages for start-up related code:

1. Init containers can contain utilities or custom code for setup that are not present in an app image. For example, there is no need to make an image FROM another image just to use a tool like `sed`, `awk`, `python`, or `dig` during setup.
2. The application image builder and deployer roles can work independently without the need to jointly build a single app image.
3. Init containers can run with a different view of the filesystem than app containers in the same Pod. Consequently, they can be given access to Secrets that app containers cannot access.
4. Because init containers run to completion before any app containers start, init containers offer a mechanism to block or delay app container startup until a set of preconditions are met. Once preconditions are met, all of the app containers in a Pod can start in parallel.
5. Init containers can securely run utilities or custom code that would otherwise make an app container image less secure. By keeping unnecessary tools separate you can limit the attack surface of your app container image.


## Examples using `initContainers`

The most commons of initContainer use for is, if your application need to run task before they can run for exaample migrate db, backup file config, cleanup systemfiles and etc.

For example:

{% gist page.gist "03e-init-containers.yaml" %} 

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ kubectl -f 02-workloads/01-pod/init-containers.yaml apply 
pod/postgres-db created
service/postgres-db created
pod/backend-apps created

➜ kubectl get pod
NAME           READY   STATUS     RESTARTS   AGE
backend-apps   0/1     Init:0/1   0          8s
postgres-db    1/1     Running    0          8s

➜ kubectl get pod
NAME           READY   STATUS    RESTARTS   AGE
backend-apps   1/1     Running   0          45s
postgres-db    1/1     Running   0          45s

➜ kubectl describe pod backend-apps
Name:         backend-apps
Namespace:    default
Priority:     0
Node:         minikube/192.168.59.105
Start Time:   Tue, 03 May 2022 05:05:27 +0700
Labels:       app=backend-apps
Annotations:  <none>
Status:       Running
IP:           172.17.0.4
IPs:
  IP:  172.17.0.4
Init Containers:
  migrate-db:
    Image:         flyway/flyway
    Port:          <none>
    Host Port:     <none>
    Args:
      -url=$(DB_URL)
      -user=$(DB_USER)
      -password=$(DB_PASSWORD)
      info
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Tue, 03 May 2022 05:05:33 +0700
      Finished:     Tue, 03 May 2022 05:05:36 +0700
    Ready:          True
    Restart Count:  0
    Environment:
      DB_URL:       jdbc:postgresql://postgres-db:5432/mydb
      DB_USER:      postgres
      DB_PASSWORD:  password
Containers:
  backend-apps:
    Image:          nginx:latest
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Tue, 03 May 2022 05:05:37 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  86s   default-scheduler  Successfully assigned default/backend-apps to minikube
  Normal  Pulling    85s   kubelet            Pulling image "flyway/flyway"
  Normal  Pulled     80s   kubelet            Successfully pulled image "flyway/flyway" in 5.3909989s
  Normal  Created    80s   kubelet            Created container migrate-db
  Normal  Started    80s   kubelet            Started container migrate-db
  Normal  Pulled     76s   kubelet            Container image "nginx:latest" already present on machine
  Normal  Created    76s   kubelet            Created container backend-apps
  Normal  Started    76s   kubelet            Started container backend-apps
```