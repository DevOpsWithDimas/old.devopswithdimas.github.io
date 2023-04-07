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
2. Create Deployment using yaml file
3. Writing a Deployment Spec
4. Deployment status
5. Updating a Deployment
6. Scalling a Deployment
7. Rolling back a Deployment
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