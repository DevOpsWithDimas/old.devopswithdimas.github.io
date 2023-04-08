---
layout: post
title: "Workload with Deployment"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Workloads
refs: 
- https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
- https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/
youtube: 
comments: true
catalog_key: workloads
image_path: /resources/posts/kubernetes/05b-deployment
gist: dimMaryanto93/96f6954c9a27a6b1934113b10223196a
downloads: []
---

Hai semuanya, materi sebelumnya kita sudah mencoba menggunakan Kubernetes workload resources dengan Object Deployment yang paling simple. Sekarang kita akan membahas yang lebih detail tentang Object Deployment. Karena pembahasan kali ini lumayan panjang jadi kita bagi2 jadi beberapa bagian diantaranya:

1. What is Deployment Object?
2. Create a Deployment
3. Updating a Deployment
4. Rolling back a Deployment
5. Scalling a Deployment
6. Deployment status
7. Writing a Deployment Spec
8. Clean up policy

Okay tanpa berlama-lama yuk langsung aja kita bahas materi yang pertama:

<!--more-->

## What is Deployment Object

Seperti yang telah saya bahas di materi sebelumnya, Deployment adalah salah satu Workload resources yang digunakan untuk me-manage Pod dan container yang paling cocok untuk aplikasi Stateless atau tidak menyimpan data. 

A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.

![deployment-flow]({{ page.image_path | prepend: site.baseurl }}/deployment-flow.png)

The following are typical use cases for Deployments:

1. Create a Deployment to rollout a ReplicaSet. The ReplicaSet creates Pods in the background. Check the status of the rollout to see if it succeeds or not.
2. Declare the new state of the Pods by updating the `PodTemplateSpec` of the Deployment. A new ReplicaSet is created and the Deployment manages moving the Pods from the old ReplicaSet to the new one at a controlled rate. Each new ReplicaSet updates the revision of the Deployment.
3. Rollback to an earlier Deployment revision if the current state of the Deployment is not stable. Each rollback updates the revision of the Deployment.
4. Scale up the Deployment to facilitate more load.
5. Pause the rollout of a Deployment to apply multiple fixes to its `PodTemplateSpec` and then resume it to start a new rollout.
6. Use the status of the Deployment as an indicator that a rollout has stuck.
7. Clean up older ReplicaSets that you don't need anymore.

## Create Deployment using yaml file

Untuk membuat object deployment bisa menggunakan imperative command (`kubectl create deploy`) dan declarative seperti membuat file extension `.yaml` atau `.json` yang kemudian di execute menggunakan perintah `kubectl apply -f filename.yaml`.

Berikut adalah basic Deployment spec yang digunakan untuk membuat/menjalankan 3 buah pod dengan container image `nginx` seperti berikut:

{% gist page.gist "05b-basic-deploy-nginx.yaml" %}

Kemudian coba jalankan menggunakan perintah:

{% highlight bash %}
kubectl apply -f basic-deployment.yaml
{% endhighlight %}

Jika kita lihat hasilnya seperti berikut:

```bash
➡ kubectl apply -f 03-workloads/01-basic-deploy/basic-deployment.yaml
deployment.apps/nginx-deploy created

➜ kubernetes git:(main) ✗ kubectl get deploy
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   3/3     3            3           3m21s

➜ kubernetes git:(main) ✗ kubectl get rs
NAME                     DESIRED   CURRENT   READY   AGE
nginx-deploy-c9bcb48d4   3         3         3       3m39s

➜ kubernetes git:(main) ✗ kubectl get pod
NAME                           READY   STATUS    RESTARTS   AGE
nginx-deploy-c9bcb48d4-5s7zs   1/1     Running   0          82s
nginx-deploy-c9bcb48d4-nrsr7   1/1     Running   0          3m54s
nginx-deploy-c9bcb48d4-rbc8s   1/1     Running   0          82s
```

In this example:

1. A Deployment named `nginx-deploy` is created, indicated by the `.metadata.name` field. This name will become the basis for the ReplicaSets and Pods which are created later. See [Writing a Deployment Spec](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#writing-a-deployment-spec) for more details.

2. The Deployment creates a ReplicaSet that creates three replicated Pods, indicated by the `.spec.replicas` field.

3. The `.spec.selector` field defines how the created ReplicaSet finds which Pods to manage. In this case, you select a label that is defined in the Pod template (`app: nginx`, `env: test`). However, more sophisticated selection rules are possible, as long as the Pod template itself satisfies the rule.

4. The `template` field contains the following sub-fields:

    1. The Pods are labeled `app: nginx` using the `.metadata.labels` field.
    2. The Pod template's specification, or `.template.spec` field, indicates that the Pods run one container, `nginx`, which runs the `nginx` Docker [Hub image](https://hub.docker.com/_/nginx) at version [mainline].
    3. Create one container and name it `nginx` using the `.spec.template.spec.containers[0].name` field.

## Updating a Deployment

Ada beberapa cara melakukan update suatu Deployment object pada kubernetes

1. Using `kubectl set` command
2. Using `kubectl edit deploy/<deploy-name>`
3. Using declarative file kemudian menjalakan `kubectl apply -f` command

For example, saya mau update image deployment versionnya dari `mainline` menjadi `stable-alpine` jadi perintahnya seperti berikut:

{% highlight bash %}
kubectl set image deploy/nginx-deploy nginx-deploy=nginx:stable-alpine
{% endhighlight %}

Atau alternative lainnya, kita bisa edit secara langsung di kubernetes clusternya dengan menggunakan perintah 

{% highlight bash %}
kubectl edit deploy nginx-deploy
{% endhighlight %}

Nah jika kita jalankan outputnya seperti berikut:

```bash
➜  kubectl set image deploy/nginx-deploy nginx-deploy=nginx:stable-alpine
deployment.apps/nginx-deploy image updated

➜  kubectl get rs
NAME                      DESIRED   CURRENT   READY   AGE
nginx-deploy-5c7b8c97f6   3         3         3       2m8s
nginx-deploy-c9bcb48d4    0         0         0       168m

➜  kubectl get pod
NAME                            READY   STATUS    RESTARTS   AGE
nginx-deploy-5c7b8c97f6-jgt2p   1/1     Running   0          2m54s
nginx-deploy-5c7b8c97f6-k7jnf   1/1     Running   0          3m4s
nginx-deploy-5c7b8c97f6-mzg4m   1/1     Running   0          3m16s

➜  kubernetes git:(main) kubectl describe pod/nginx-deploy-5c7b8c97f6-jgt2p
Name:             nginx-deploy-5c7b8c97f6-jgt2p
Namespace:        default
Node:             minikube/192.168.105.9
Labels:           app=nginx
                  env=test
                  pod-template-hash=5c7b8c97f6
Status:           Running
IP:               10.244.0.5
IPs:
  IP:           10.244.0.5
Controlled By:  ReplicaSet/nginx-deploy-5c7b8c97f6
Containers:
  nginx-deploy:
    Image:          nginx:stable-alpine
    Port:           80/TCP
    State:          Running
      Started:      Fri, 07 Apr 2023 17:29:38 +0700
    Ready:          True
    Restart Count:  0
    Environment:    <none>
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m32s  default-scheduler  Successfully assigned default/nginx-deploy-5c7b8c97f6-jgt2p to minikube
  Normal  Pulling    3m32s  kubelet            Pulling image "nginx:stable-alpine"
  Normal  Pulled     3m22s  kubelet            Successfully pulled image "nginx:stable-alpine" in 9.54521492s (9.545224254s including waiting)
  Normal  Created    3m22s  kubelet            Created container nginx-deploy
  Normal  Started    3m22s  kubelet            Started container nginx-deploy
```

Get more details on your updated Deployment:

1. After the rollout succeeds, you can view the Deployment by running `kubectl get deployments`. The output is similar to this:

    ```bash
    NAME           READY   UP-TO-DATE   AVAILABLE   AGE
    nginx-deploy   3/3     3            3           3h6m
    ```

2. Run `kubectl get rs` to see that the Deployment updated the Pods by creating a new ReplicaSet and scaling it up to `3` replicas, as well as scaling down the old ReplicaSet to `0` replicas.

    ```bash
    NAME                      DESIRED   CURRENT   READY   AGE
    nginx-deploy-5c7b8c97f6   3         3         3       6m33s
    nginx-deploy-c9bcb48d4    0         0         0       173m
    ```

3. Run `kubectl get pod`, Running get pods should now show only the new Pods:

    ```bash
    NAME                            READY   STATUS    RESTARTS   AGE
    nginx-deploy-5c7b8c97f6-jgt2p   1/1     Running   0          7m30s
    nginx-deploy-5c7b8c97f6-k7jnf   1/1     Running   0          7m40s
    nginx-deploy-5c7b8c97f6-mzg4m   1/1     Running   0          7m52s
    ```

Next time you want to update these Pods, you only need to update the Deployment's Pod template again.

Deployment ensures that only a certain number of Pods are down while they are being updated. By default, it ensures that at least `75%` of the desired number of Pods are up (`25%` max unavailable).

For example, if you look at the above Deployment closely, you will see that it first creates a new Pod, then deletes an old Pod, and creates another new one. It does not kill old Pods until a sufficient number of new Pods have come up, and does not create new Pods until a sufficient number of old Pods have been killed. It makes sure that at least `3` Pods are available and that at max `4` Pods in total are available. In case of a Deployment with `4` replicas, the number of Pods would be between `3` and `5`.

## Rolling Back a Deployment

Sometimes, you may want to rollback a Deployment; for example, when the Deployment is not stable, such as crash looping. By default, all of the Deployment's rollout history is kept in the system so that you can rollback anytime you want (you can change that by modifying revision history limit).

Suppose that you made a typo while updating the Deployment, by putting the image name as `nginx:1.161` instead of `nginx:1.16.1`:

{% highlight bash %}
kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.161
{% endhighlight %}

Berikut outputnya:

```bash
➜ kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.161
deployment.apps/nginx-deploy image updated

➜ kubectl get deploy
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   3/3     1            3           7m13s

➜ kubectl get rs
NAME                      DESIRED   CURRENT   READY   AGE
nginx-deploy-5c7b8c97f6   3         3         3       7m11s
nginx-deploy-65cbcc896b   1         1         0       36s
nginx-deploy-c9bcb48d4    0         0         0       7m27s

➜ kubectl get pod
NAME                            READY   STATUS         RESTARTS   AGE
nginx-deploy-5c7b8c97f6-6xzfr   1/1     Running        0          7m34s
nginx-deploy-5c7b8c97f6-tvfxv   1/1     Running        0          7m32s
nginx-deploy-5c7b8c97f6-vt5lf   1/1     Running        0          7m33s
nginx-deploy-65cbcc896b-7q6mc   0/1     ErrImagePull   0          59s
```

The rollout gets stuck. You can verify it by checking the rollout status:

{% highlight bash %}
kubectl rollout status deploy/nginx-deploy
{% endhighlight %}

The output look like:

```bash
➜ kubectl rollout status deploy/nginx-deploy
Waiting for deployment "nginx-deploy" rollout to finish: 1 out of 3 new replicas have been updated...
```

Press `Ctrl-C` to stop the above rollout status watch. First, check the revisions of this Deployment:

{% highlight bash %}
kubectl rollout history deploy/nginx-deploy
{% endhighlight %}

The output look like:

```bash
➜ kubectl rollout history deploy/nginx-deploy
deployment.apps/nginx-deploy
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         <none>
```

To see the details of each revision, run:

{% highlight bash %}
kubectl rollout history deploy/nginx-deploy --revision=2
{% endhighlight %}

The output look like:

```bash
➜ kubectl rollout history deploy/nginx-deploy --revision=2
deployment.apps/nginx-deploy with revision #2
Pod Template:
  Labels:	app=nginx
	env=test
	pod-template-hash=5c7b8c97f6
  Containers:
   nginx-deploy:
    Image:	nginx:stable-alpine
    Port:	80/TCP
    Host Port:	0/TCP
    Environment:	<none>
    Mounts:	<none>
  Volumes:	<none>
```

Follow the steps given below to rollback the Deployment from the current version to the previous version, which is version 3.

Now you've decided to undo the current rollout and rollback to the previous revision:

{% highlight bash %}
kubectl rollout undo deploy/nginx-deploy
{% endhighlight %}

The output is similar to this:

```bash
➜ kubectl rollout undo deploy/nginx-deploy
deployment.apps/nginx-deploy rolled back

➜ kubectl rollout status deploy/nginx-deploy
deployment "nginx-deploy" successfully rolled out

➜ kubectl get deploy
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   3/3     3            3           15m

➜ kubectl get rs
NAME                      DESIRED   CURRENT   READY   AGE
nginx-deploy-5c7b8c97f6   3         3         3       15m
nginx-deploy-65cbcc896b   0         0         0       9m4s
nginx-deploy-c9bcb48d4    0         0         0       15m

➜ kubectl describe deploy nginx-deploy
Name:                   nginx-deploy
Namespace:              default
Labels:                 app=nginx
                        env=test
Annotations:            deployment.kubernetes.io/revision: 4
Selector:               app=nginx,env=test
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
           env=test
  Containers:
   nginx-deploy:
    Image:        nginx:stable-alpine
    Port:         80/TCP
    Host Port:    0/TCP
NewReplicaSet:   nginx-deploy-5c7b8c97f6 (3/3 replicas created)
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled up replica set nginx-deploy-c9bcb48d4 to 3
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled up replica set nginx-deploy-5c7b8c97f6 to 1
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled down replica set nginx-deploy-c9bcb48d4 to 2 from 3
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled up replica set nginx-deploy-5c7b8c97f6 to 2 from 1
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled down replica set nginx-deploy-c9bcb48d4 to 1 from 2
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled up replica set nginx-deploy-5c7b8c97f6 to 3 from 2
  Normal  ScalingReplicaSet  16m    deployment-controller  Scaled down replica set nginx-deploy-c9bcb48d4 to 0 from 1
  Normal  ScalingReplicaSet  9m42s  deployment-controller  Scaled up replica set nginx-deploy-65cbcc896b to 1
  Normal  ScalingReplicaSet  97s    deployment-controller  Scaled down replica set nginx-deploy-65cbcc896b to 0 from 1
```

Alternatively, you can rollback to a specific revision by specifying it with `--to-revision`:

{% highlight bash %}
kubectl rollout undo deploy/nginx-deploy --to-revision 1
{% endhighlight %}

The output is similar to this:

```bash
➜ kubectl rollout undo deploy/nginx-deploy --to-revision 1
deployment.apps/nginx-deploy rolled back

➜ kubectl rollout status deploy/nginx-deploy
deployment "nginx-deploy" successfully rolled out

➜ kubectl get deploy
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   3/3     3            3           19m

➜ kubectl get rs
NAME                      DESIRED   CURRENT   READY   AGE
nginx-deploy-5c7b8c97f6   0         0         0       19m
nginx-deploy-65cbcc896b   0         0         0       12m
nginx-deploy-c9bcb48d4    3         3         3       19m

➜ kubectl describe deploy nginx-deploy
Name:                   nginx-deploy
Namespace:              default
Labels:                 app=nginx
                        env=test
Annotations:            deployment.kubernetes.io/revision: 5
Selector:               app=nginx,env=test
Replicas:               3 desired | 3 updated | 3 total | 3 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
           env=test
  Containers:
   nginx-deploy:
    Image:        nginx:mainline
    Port:         80/TCP
    Host Port:    0/TCP

NewReplicaSet:   nginx-deploy-c9bcb48d4 (3/3 replicas created)
Events:
  Type    Reason             Age                From                   Message
  ----    ------             ----               ----                   -------
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled up replica set nginx-deploy-c9bcb48d4 to 3
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled up replica set nginx-deploy-5c7b8c97f6 to 1
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled down replica set nginx-deploy-c9bcb48d4 to 2 from 3
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled up replica set nginx-deploy-5c7b8c97f6 to 2 from 1
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled down replica set nginx-deploy-c9bcb48d4 to 1 from 2
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled up replica set nginx-deploy-5c7b8c97f6 to 3 from 2
  Normal  ScalingReplicaSet  19m                deployment-controller  Scaled down replica set nginx-deploy-c9bcb48d4 to 0 from 1
  Normal  ScalingReplicaSet  12m                deployment-controller  Scaled up replica set nginx-deploy-65cbcc896b to 1
  Normal  ScalingReplicaSet  4m54s              deployment-controller  Scaled down replica set nginx-deploy-65cbcc896b to 0 from 1
  Normal  ScalingReplicaSet  61s (x6 over 63s)  deployment-controller  (combined from similar events): Scaled down replica set nginx-deploy-5c7b8c97f6 to 0 from 1
```

## Scalling a Deployment

Selain kita bisa meng-update specifikasi pod dan container, kita juga bisa melakukan scalling suatu Deployment object dengan menggunakan beberapa cara yaitu

1. Using `kubectl scale deploy/<deploy-name> --replicas=<number-of-instance>` command
2. Using `kubectl edit deploy/<deploy-name>`
3. Update `deployment.yaml` file then using `kubectl apply -f`

For example, saya mau update secara langsung dengan perintahnya seperti berikut:

{% highlight bash %}
kubectl scale deploy/nginx-deploy --replicas=5
{% endhighlight %}

Jika kita coba jalankan maka seperti berikut:

```bash
➡ kubectl scale deploy/nginx-deploy --replicas=5
deployment.apps/nginx-deploy scaled

➜  kubernetes git:(main) kubectl get deploy
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deploy   5/5     5            5           3m20s

➜  kubernetes git:(main) kubectl get rs
NAME                     DESIRED   CURRENT   READY   AGE
nginx-deploy-c9bcb48d4   5         5         5       3m34s

➜  kubernetes git:(main) kubectl get pod
NAME                           READY   STATUS    RESTARTS   AGE
nginx-deploy-c9bcb48d4-blnpp   1/1     Running   0          69s
nginx-deploy-c9bcb48d4-bsgsr   1/1     Running   0          3m46s
nginx-deploy-c9bcb48d4-rh76q   1/1     Running   0          3m46s
nginx-deploy-c9bcb48d4-sg97l   1/1     Running   0          3m46s
nginx-deploy-c9bcb48d4-tvtq8   1/1     Running   0          69s
```

## RollingUpdate a Deployment

RollingUpdate Deployments support running multiple versions of an application at the same time. When you or an autoscaler scales a RollingUpdate Deployment that is in the middle of a rollout (either in progress or paused), the Deployment controller balances the additional replicas in the existing active ReplicaSets (ReplicaSets with Pods) in order to mitigate risk. This is called proportional scaling.

For example, you are running a Deployment with 10 replicas, `maxSurge=3`, and `maxUnavailable=2`. Configuration look like:

{% gist page.gist "05b-rollingupdate-deployment.yaml" %}

Kemudian coba jalankan dengan perintah berikut:

{% highlight bash %}
kubectl apply -f rollingupdate-deployment.yaml
{% endhighlight %}

Maka outputnya seperti berikut:

```bash
➜ kubectl apply -f 03-workloads/01-basic-deploy/rollingupdate-deployment.yaml
deployment.apps/rollingupdate-nginx-deploy created

➜ kubectl get deploy rollingupdate-nginx-deploy
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
rollingupdate-nginx-deploy   10/10   10           10          2m25s

NAME                                   DESIRED   CURRENT   READY   AGE
rollingupdate-nginx-deploy-cd8ddf7d8   10        10        10      9s

➜  kubernetes git:(main) ✗ kubectl get pod
NAME                                         READY   STATUS    RESTARTS   AGE
rollingupdate-nginx-deploy-cd8ddf7d8-7ffkl   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-7p5x2   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-f2pcm   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-fxvbb   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-hw67p   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-j2zls   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-rwln8   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-tw8m5   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-v5kt2   1/1     Running   0          30s
rollingupdate-nginx-deploy-cd8ddf7d8-zzt44   1/1     Running   0          30s
```

Sekarang kita coba update image menjadi latest dengan perintah berikut:

{% highlight bash %}
kubectl set image deploy/rollingupdate-nginx-deploy nginx=nginx:latest && \
kubectl get rs -w
{% endhighlight %}

Maka outputnya seperti berikut:

```bash
➜ kubectl set image deploy/rollingupdate-nginx-deploy nginx=nginx:latest && \
kubectl get rs -w
deployment.apps/rollingupdate-nginx-deploy image updated

NAME                                    DESIRED   CURRENT   READY   AGE
rollingupdate-nginx-deploy-cd8ddf7d8    10        10        10      0s
rollingupdate-nginx-deploy-cd8ddf7d8    8         8         8       1s
rollingupdate-nginx-deploy-77599d4db8   10        10        8       3s
rollingupdate-nginx-deploy-cd8ddf7d8    2         2         2       4s
rollingupdate-nginx-deploy-cd8ddf7d8    0         0         0       4s
rollingupdate-nginx-deploy-77599d4db8   10        10        10      5s
```

## Pause and Resume rollout of a Deployment

When you update a Deployment, or plan to, you can pause rollouts for that Deployment before you trigger one or more updates. When you're ready to apply those changes, you resume rollouts for the Deployment. This approach allows you to apply multiple fixes in between pausing and resuming without triggering unnecessary rollouts.

For example:

Get the rollout status:

{% highlight bash %}
kubectl get rs
{% endhighlight %}

Jika dijalankan outputnya seperti berikut:

```bash
➜ kubectl get deploy
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
rollingupdate-nginx-deploy   10/10   10           10          33m

➜ kubectl get rs
NAME                                    DESIRED   CURRENT   READY   AGE
rollingupdate-nginx-deploy-77599d4db8   10        10        10      26m
```

Pause by running the following command:

{% highlight bash %}
kubectl rollout pause deploy/rollingupdate-nginx-deploy
{% endhighlight %}

Then when you update the deployment, such as image version using `kubectl set image deploy/rollingupdate-nginx-deploy nginx=nginx:1.16.1` The output look like:

```bash
➜ kubectl rollout pause deploy/rollingupdate-nginx-deploy
deployment.apps/rollingupdate-nginx-deploy paused

➜ kubectl set image deploy/rollingupdate-nginx-deploy nginx=nginx:1.16.1
deployment.apps/rollingupdate-nginx-deploy image updated

➜ kubectl rollout history deploy/rollingupdate-nginx-deploy
deployment.apps/rollingupdate-nginx-deploy
REVISION  CHANGE-CAUSE
1         <none>
2         <none>

➜ kubectl rollout status deploy/rollingupdate-nginx-deploy
Waiting for deployment "rollingupdate-nginx-deploy" rollout to finish: 0 out of 10 new replicas have been updated...

➜  kubernetes git:(main) kubectl describe deploy rollingupdate-nginx-deploy
Name:                   rollingupdate-nginx-deploy
Namespace:              default
CreationTimestamp:      Sat, 08 Apr 2023 15:52:55 +0700
Labels:                 app=nginx
                        env=test
Annotations:            deployment.kubernetes.io/revision: 2
Selector:               app=nginx,env=test
Replicas:               10 desired | 0 updated | 10 total | 10 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  2 max unavailable, 3 max surge
Pod Template:
  Labels:  app=nginx
           env=test
  Containers:
   nginx:
    Image:        nginx:1.16.1
    Port:         80/TCP
    Host Port:    0/TCP
Conditions:
  Type           Status   Reason
  ----           ------   ------
  Available      True     MinimumReplicasAvailable
  Progressing    Unknown  DeploymentPaused
OldReplicaSets:  rollingupdate-nginx-deploy-77599d4db8 (10/10 replicas created)
NewReplicaSet:   <none>
```

Notice that no new rollout started, because the object has been pause. to solve this you need run resume rollout with this command:

{% highlight bash %}
kubectl rollout resume deploy/rollingupdate-nginx-deploy
{% endhighlight %}

Maka outputnya seperti berikut:

```bash
➜ kubectl rollout status deploy/rollingupdate-nginx-deploy
deployment "rollingupdate-nginx-deploy" successfully rolled out

➜ kubectl rollout history deploy/rollingupdate-nginx-deploy
deployment.apps/rollingupdate-nginx-deploy
REVISION  CHANGE-CAUSE
1         <none>
2         <none>
3         <none>

➜ kubectl describe deploy/rollingupdate-nginx-deploy
Name:                   rollingupdate-nginx-deploy
Namespace:              default
CreationTimestamp:      Sat, 08 Apr 2023 15:52:55 +0700
Labels:                 app=nginx
                        env=test
Annotations:            deployment.kubernetes.io/revision: 3
Selector:               app=nginx,env=test
Replicas:               10 desired | 10 updated | 10 total | 10 available | 0 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  2 max unavailable, 3 max surge
Pod Template:
  Labels:  app=nginx
           env=test
  Containers:
   nginx:
    Image:        nginx:1.16.1
    Port:         80/TCP
    Host Port:    0/TCP
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      True    MinimumReplicasAvailable
  Progressing    True    NewReplicaSetAvailable
NewReplicaSet:   rollingupdate-nginx-deploy-679cf9c85d (10/10 replicas created)
```