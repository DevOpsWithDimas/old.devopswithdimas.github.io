---
layout: post
title: "Minikube addons features"
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/commands/addons/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02f-minikube-addons
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Minikube Addons for added functionality features of Kubernetes. Diantaranya yang akan kita bahas adalah

1. Basic usage `addons` command
2. Enable Dashboard & metrics-server using minikube addons
3. Enable Load balancer service using minikube addons
4. Enable Ingress Controller using minikube addons
5. Enable Storage Provisioning using minikube addons

Ok langsung aja kita ke pembahasan yang pertama

## Basic usage `addons` command

Minikube has a built-in list of applications and services that may be easily deployed, such as Istio or Ingress. Untuk lebih detail temen-temen bisa lihat dokumentasinya menggunakan perintah

{% highlight bash %}
minikube addons --help
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜ ~  minikube addons --help
addons modifies minikube addons files using subcommands like `minikube addons enable dashboard`

Available Commands:
  configure   Configures the addon w/ADDON_NAME within minikube (example: `minikube addons configure registry-creds`). For a list of available addons use: minikube addons list
  disable     Disables the addon w/ADDON_NAME within minikube (example: `minikube addons disable dashboard`). For a list of available addons use: minikube addons list
  enable      Enables the addon w/ADDON_NAME within minikube. For a list of available addons use: `minikube addons list`
  images      List image names the addon w/ADDON_NAME used. For a list of available addons use: `minikube addons list`
  list        Lists all available minikube addons as well as their current statuses (enabled/disabled)
  open        Opens the addon w/ADDON_NAME within minikube (example: `minikube addons open dashboard`). For a list of available addons use: minikube addons list

Usage:
  minikube addons SUBCOMMAND [flags] [options]

Use "minikube <command> --help" for more information about a given command.
Use "minikube options" for a list of global command-line options (applies to all commands).
```

To list the available addons for your version of minikube:

{% highlight bash %}
minikube addons list
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```bash
➜ ~  minikube addons list
|-----------------------------|--------------------------------|
|         ADDON NAME          |           MAINTAINER           |
|-----------------------------|--------------------------------|
| ambassador                  | third-party (ambassador)       |
| auto-pause                  | google                         |
| csi-hostpath-driver         | kubernetes                     |
| dashboard                   | kubernetes                     |
| default-storageclass        | kubernetes                     |
| efk                         | third-party (elastic)          |
| freshpod                    | google                         |
| gcp-auth                    | google                         |
| gvisor                      | google                         |
| helm-tiller                 | third-party (helm)             |
| ingress                     | unknown (third-party)          |
| ingress-dns                 | google                         |
| istio                       | third-party (istio)            |
| istio-provisioner           | third-party (istio)            |
| kubevirt                    | third-party (kubevirt)         |
| logviewer                   | unknown (third-party)          |
| metallb                     | third-party (metallb)          |
| metrics-server              | kubernetes                     |
| nvidia-driver-installer     | google                         |
| nvidia-gpu-device-plugin    | third-party (nvidia)           |
| olm                         | third-party (operator          |
|                             | framework)                     |
| pod-security-policy         | unknown (third-party)          |
| portainer                   | portainer.io                   |
| registry                    | google                         |
| registry-aliases            | unknown (third-party)          |
| registry-creds              | third-party (upmc enterprises) |
| storage-provisioner         | google                         |
| storage-provisioner-gluster | unknown (third-party)          |
| volumesnapshots             | kubernetes                     |
|-----------------------------|--------------------------------|
```

To enable an add-on, see:

{% highlight bash %}
minikube addons enable <name>
{% endhighlight %}

To enable an addon at start-up, where `–-addons` option can be specified multiple times:

{% highlight bash %}
minikube start --addons <name> --addons <name2>
{% endhighlight %}

For addons that expose a browser endpoint, you can quickly open them with:

{% highlight bash %}
minikube addons open <name>
{% endhighlight %}

To disable an addon:

{% highlight bash %}
minikube addons disable <name>
{% endhighlight %}

## Enable Dashboard & metrics-server

minikube has integrated support for the [Kubernetes Dashboard UI](https://github.com/kubernetes/dashboard).

The Dashboard is a web-based Kubernetes user interface. You can use it to:

1. deploy containerized applications to a Kubernetes cluster
2. troubleshoot your containerized application
3. manage the cluster resources
4. get an overview of applications running on your cluster
5. creating or modifying individual Kubernetes resources (such as `Deployments`, `Jobs`, `DaemonSets`, etc)

To access the dashboard:

{% gist page.gist "02f-minikube-dashboard.bash" %}

This will enable the dashboard add-on, and open the proxy in the default web browser. seperti berikut:

![minikube-dashboard]({{ page.image_path | prepend: site.baseurl }}/01-minikube-dashboard.png)

## Enable Load balancer service