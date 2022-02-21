---
layout: post
title: "Mounting filesystems to minikube cluster"
date: 2022-02-21T20:33:54+07:00
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/home/
- https://minikube.sigs.k8s.io/docs/handbook/mount/
youtube: 
comments: true
catalog_key: minikube
image_path: /resources/posts/kubernetes/02h-minikube-mount
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang mount your data from workstation to minikube cluster. Mounting data ini berguna untuk bind files dari container ke volume ataupun sebaliknya (mount-bind). Dengan menggunakan minikube kita bisa menggunakan 2 cara yaitu:

1. Using 9P Mounts
2. Using Driver mounts

Ok langsung aja kita bahas materi yang pertama:

## Using 9P Mounts

9P mounts are flexible and work across all hypervisors, but suffers from performance and reliability issues when used with large folders (`>600 files`).

To mount a directory from the host into the guest using the `mount` subcommand:

{% highlight bash %}
minikube mount <source-directory>:<target-directory>
{% endhighlight %}

For example, this would mount your working directory to appear as `/volumes` within the minikube VM:

{% gist page.gist "02h-9p-mount-windows.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ youtube git:(master) minikube mount .\_posts\kubernetes\02-getting-started\:/volumes
📁  Mounting host path .\_posts\kubernetes\02-getting-started\ into VM as /volumes ...
    ▪ Mount type:
    ▪ User ID:      docker
    ▪ Group ID:     docker
    ▪ Version:      9p2000.L
    ▪ Message Size: 262144
    ▪ Options:      map[]
    ▪ Bind Address: 127.0.0.1:60187
🚀  Userspace file server: ufs starting
✅  Successfully mounted .\_posts\kubernetes\02-getting-started\ to /volumes

➜ ~  minikube ssh
docker@minikube:~$ ls /volumes/
2022-01-14-02-overview-learn-env.markdown
2022-01-16-02a-install-tools-for-macos.markdown
2022-01-22-02a-install-tools-for-windows.markdown
2022-01-27-02a-install-tools-for-linux.markdown
2022-01-27-02b-deploy-application.markdown
2022-01-27-02c-minikube-basic-control.markdown
2022-02-01-02d-minikube-use-your-own-images.markdown
2022-02-18-02f-minikube-addons.markdown
2022-02-20-02g-minikube-access-apps.markdown
docker@minikube:~$
```

This directory may then be referenced from a Kubernetes manifest, for example:

{% gist page.gist "02h-volume-host-path.yaml" %}

## Using Driver mounts

Some hypervisors, have built-in host folder sharing. Driver mounts are reliable with good performance, but the paths are not predictable across operating systems or hypervisors:

| Driver        | OS        | HostFolder    | VM            |
| :---          | :---      | :---          | :---          |
| `VirtualBox`  | Linux     | `/home`       | `/hostname`   |
| `VirtualBox`  | macOs     | `/Users`      | `/Users`      |
| `VirtualBox`  | Windows   | `C://Users`   | `/c/Users`    |
| `KVM`         | Linux     | Unsupported   | -             |
| `HyperKit`    | Linux     | Unsupported   | -             |

These mounts can be disabled by passing `--disable-driver-mounts` to minikube start.

Jika kita coba, seperti berikut:

```bash
## my workspaces
➜  ~ ls Workspaces/examples 
udemy-k8s-kustomize

## inside minikube cluster
➜  ~ minikube ssh
$ ls /hosthome/dimasm93/Workspaces/examples/ 
udemy-k8s-kustomize
```