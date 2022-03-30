---
layout: post
title: "Access your apps/service in minikube"
date: 2022-02-20T15:01:52+07:00
lang: k8s
authors:
- dimasm93
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

A NodePort service is the most basic way to get external traffic directly to your service. NodePort, as the name implies, opens a specific port, and any traffic that is sent to this port is forwarded to the service.

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

## Using `minikube tunnel` command

Selain menggunakan service type `NodePort`, kita juga bisa menggunakan `LoadBalancer`. A LoadBalancer service is the standard way to expose a service to the internet. With this method, each service gets its own IP address.

Services of type `LoadBalancer` can be exposed via the `minikube tunnel` command. It must be run in a separate terminal window to keep the LoadBalancer running. `Ctrl-C` in the terminal can be used to terminate the process at which time the network routes will be cleaned up.

{% gist page.gist "02g-minikube-tunnel.bash" %}

The `minikube tunnel` runs as a process, creating a network route on the host to the service CIDR of the cluster using the cluster’s IP address as a gateway. The `tunnel` command exposes the external IP directly to any program running on the host operating system.

Jika di jalankan outputnya seperti berikut:

```bash
➜ ~  minikube addons enable metallb
    ▪ Using image metallb/speaker:v0.9.6
    ▪ Using image metallb/controller:v0.9.6
🌟  The 'metallb' addon is enabled

➜ ~  minikube ip
192.168.59.104

➜ ~  minikube addons configure metallb
-- Enter Load Balancer Start IP: 192.168.59.100
-- Enter Load Balancer End IP: 192.168.59.120
    ▪ Using image metallb/controller:v0.9.6
    ▪ Using image metallb/speaker:v0.9.6
✅  metallb was successfully configured

➜ ~  kubectl get pods -n metallb-system
NAME                          READY   STATUS    RESTARTS   AGE
controller-7dd4bdf68f-skn58   1/1     Running   0          93s
speaker-9884v                 1/1     Running   0          93s

➜ ~  kubectl run nginx-app --image nginx --port 80
pod/nginx-app created

➜ ~  kubectl expose pod/nginx-app --type=LoadBalancer --port 80
service/nginx-app exposed

➜  ~ kubectl get svc   
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
kubernetes   ClusterIP      10.96.0.1       <none>         443/TCP        66s
nginx-app    LoadBalancer   10.98.114.127   192.168.49.1   80:31832/TCP   4s
```

Jika kita mau akses applicationnya brati kita menggunakan ip external seperti berikut:

```bash
➜  ~ curl 192.168.49.1
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

Nah jadi minikube punya alternatif lain yaitu menggunakan protocol tunneling, dengan perintah `minikube tunnel` jika kita jalankan pada windows terminal baru seperti berikut:

```bash
➜  ~ minikube tunnel -c
Status:	
	machine: minikube
	pid: 14486
	route: 10.96.0.0/12 -> 192.168.49.2
	minikube: Running
	services: [nginx-app]
    errors: 
		minikube: no errors
		router: no errors
		loadbalancer emulator: no errors
```

**NOTE:** currently only work oh Linux/Mac OS

Kita bisa akses Cluster ipnya seperti berikut:


```bash
➜  ~ curl 10.98.114.127
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```