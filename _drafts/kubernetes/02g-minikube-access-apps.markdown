---
layout: post
title: "Access your apps/service in minikube"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/handbook/accessing/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02f-minikube-access-apps
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas bagaimana cara mengakses apps/service pada kubernetes menggunakan Minikube. Diantaranya

1. Using `minikube service` command
2. Using `minikube tunnel` command

Ok langsung aja kita ke pembahasan yang pertama

## Using `minikube service` command

Basicly pada kubernetes cluster kita meng-akses aplikasi dengan service type `NodePort`. A NodePort service is the most basic way to get external traffic directly to your service. NodePort, as the name implies, opens a specific port, and any traffic that is sent to this port is forwarded to the service.

We also have a shortcut for fetching the minikube IP and a service’s `NodePort`:

{% highlight bash %}
minikube service --url <service-name>
{% endhighlight %}

Untuk mencobanya, kita coba buat pod baru dan expose menggunakan `NodePort` seperti berikut:

```bash
➜ ~  kubectl run nginx-app --image nginx --port 80
pod/nginx-app created

➜ ~  kubectl get pod
NAME        READY   STATUS    RESTARTS   AGE
nginx-app   1/1     Running   0          35s

➜ ~  kubectl expose pod/nginx-app --type=NodePort --port 80
service/nginx-app exposed

➜ ~  kubectl get service
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        109s
nginx-app    NodePort    10.111.221.57   <none>        80:31915/TCP   13s

➜ ~  minikube ip
192.168.59.104
```

Nah jadi biasanya khan jika kita mau access aplikasinya kita perlu `minikube ip` dan exposed portnya yaitu `310915` dengan menggunakan `kubectl get svc`. minikube mengediakan shortcutnya yaitu dengan menggunakan perintah

{% gist page.gist "02g-minikube-svc-list.bash" %}

Atau kita juga bisa menggunakan specific service namenya yaitu 

{% gist page.gist "02g-minikube-svc-name.bash" %}

Jika kita jalankan maka hasilnya seperti berikut:

```bash
➜ ~  minikube service list
|-------------|----------------|--------------|-----------------------------|
|  NAMESPACE  |      NAME      | TARGET PORT  |             URL             |
|-------------|----------------|--------------|-----------------------------|
| default     | kubernetes     | No node port |
| default     | nginx-app      |           80 | http://192.168.59.104:31915 |
| kube-system | kube-dns       | No node port |
| kube-system | metrics-server | No node port |
|-------------|----------------|--------------|-----------------------------|

➜ ~  minikube service --url nginx-app
http://192.168.59.104:31915

➜ ~  curl $(minikube service --url nginx-app)
StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html>
                    <head>
                    <title>Welcome to nginx!</title>
                    <style>
                    html { color-scheme: light dark; }
                    body { width: 35em; margin: 0 auto;
                    font-family: Tahoma, Verdana, Arial, sans-serif; }
                    </style...
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 615], [Content-Type,
                    text/html]...}
```