---
layout: post
title: "Managing Kubernetes Object"
date: 2021-12-26T13:36:22+07:00
lang: k8s
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/
- https://kubectl.docs.kubernetes.io/guides/introduction/kubectl/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01e-kubernetes-object-management
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---


Hai semuanya, sebelumnya kita udah membahas tentang Objects pada Kubernetes sekarang kita akan bagaimana cara memanage Objectnya. Seperti yang kita tahu untuk berinteraksi dengan Kubernetes Cluster yaitu dengan menggunakan Kubernetes Client yaitu `kubectl`, Kubernetes API, dan Kubernetes Client Libraries. Kali ini kita akan membahas tentang `kubectl` command line terlebih dulu ya Diantaranya

1. Management techniques
2. Imperative commands
3. Imperative object configuration
4. Declarative object configuration

Ok langsung aja kita bahas materi pertama 

## Management techniques

The `kubectl` command-line tool supports several different ways to create and manage Kubernetes objects. A Kubernetes object should be managed using only one technique. Mixing and matching techniques for the same object results in undefined behavior.

Most Kubectl commands typically fall into one of a few categories:

1. **Declarative Resource Management**, used for Deployment and Operations (e.g. GitOps)
2. **Imperative Resource Management**, used for Development Only. Run commands to manage Kubernetes Workloads using Command Line arguments and flags
3. **Printing Workload State**, used for Debugging or Print information about Workloads.
4. **Interacting with Containers**, used for Debugging or `exec`, `attach`, `cp`, and `logs`
5. **Cluster Management**, used for Cluster Ops or Drain and Cordon Nodes

Untuk lebih detailnya kita bisa lihat help atau documentasinya dengan menggunakan command-line

{% highlight powershell %}
kubectl --help
{% endhighlight %}

Maka hasilnya seperti berikut:

```powershell
➜ ~  kubectl -h
kubectl controls the Kubernetes cluster manager.

 Find more information at: https://kubernetes.io/docs/reference/kubectl/overview/

Basic Commands (Beginner):
  create        Create a resource from a file or from stdin
  expose        Take a replication controller, service, deployment or pod and expose it as a new
Kubernetes service
  run           Run a particular image on the cluster
  set           Set specific features on objects

Basic Commands (Intermediate):
  explain       Get documentation for a resource
  get           Display one or many resources
  edit          Edit a resource on the server
  delete        Delete resources by file names, stdin, resources and names, or by resources and
label selector

Deploy Commands:
  rollout       Manage the rollout of a resource
  scale         Set a new size for a deployment, replica set, or replication controller
  autoscale     Auto-scale a deployment, replica set, stateful set, or replication controller

Cluster Management Commands:
  certificate   Modify certificate resources.
  cluster-info  Display cluster information
  top           Display resource (CPU/memory) usage
  cordon        Mark node as unschedulable
  uncordon      Mark node as schedulable
  drain         Drain node in preparation for maintenance
  taint         Update the taints on one or more nodes

Troubleshooting and Debugging Commands:
  describe      Show details of a specific resource or group of resources
  logs          Print the logs for a container in a pod
  attach        Attach to a running container
  exec          Execute a command in a container
  port-forward  Forward one or more local ports to a pod
  proxy         Run a proxy to the Kubernetes API server
  cp            Copy files and directories to and from containers
  auth          Inspect authorization
  debug         Create debugging sessions for troubleshooting workloads and nodes

Advanced Commands:
  diff          Diff the live version against a would-be applied version
  apply         Apply a configuration to a resource by file name or stdin
  patch         Update fields of a resource
  replace       Replace a resource by file name or stdin
  wait          Experimental: Wait for a specific condition on one or many resources
  kustomize     Build a kustomization target from a directory or URL.

Settings Commands:
  label         Update the labels on a resource
  annotate      Update the annotations on a resource
  completion    Output shell completion code for the specified shell (bash or zsh)

Other Commands:
  api-resources Print the supported API resources on the server
  api-versions  Print the supported API versions on the server, in the form of "group/version"
  config        Modify kubeconfig files
  plugin        Provides utilities for interacting with plugins
  version       Print the client and server version information

Usage:
  kubectl [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
```

## Imperative commands

When using imperative commands, a user operates directly on live objects in a cluster. The user provides operations to the `kubectl` command as arguments or flags. This is the recommended way to get started or to run a one-off task in a cluster. Because this technique operates directly on live objects, it provides no history of previous configurations.

Run an instance of the nginx container by creating a Deployment object:

{% highlight bash %}
kubectl create deployment nginx --image nginx
{% endhighlight %}

Advantages compared to object configuration:

1. Commands are expressed as a single action word.
2. Commands require only a single step to make changes to the cluster.

Disadvantages compared to object configuration:

1. Commands do not integrate with change review processes.
2. Commands do not provide an audit trail associated with changes.
3. Commands do not provide a source of records except for what is live.
5. Commands do not provide a template for creating new objects.

## Imperative object configuration

In imperative object configuration, the `kubectl` command specifies the operation (`create`, `replace`, etc.), optional flags and at least one file name. The file specified must contain a full definition of the object in YAML or JSON format.

Create the objects defined in a configuration file:

{% highlight bash %}
kubectl create -f nginx.yaml
{% endhighlight %}

Delete the objects defined in two configuration files:

{% highlight bash %}
kubectl delete -f nginx.yaml -f redis.yaml
{% endhighlight %}

Update the objects defined in a configuration file by overwriting the live configuration:

{% highlight bash %}
kubectl replace -f nginx.yaml
{% endhighlight %}

Advantages compared to imperative commands:

1. Object configuration can be stored in a source control system such as Git.
2. Object configuration can integrate with processes such as reviewing changes before push and audit trails.
3. Object configuration provides a template for creating new objects.

Disadvantages compared to imperative commands:

1. Object configuration requires basic understanding of the object schema.
2. Object configuration requires the additional step of writing a YAML file.

## Declarative object configuration

When using declarative object configuration, a user operates on object configuration files stored locally, however the user does not define the operations to be taken on the files. Create, update, and delete operations are automatically detected per-object by `kubectl`. This enables working on directories, where different operations might be needed for different objects.

For examples, Process all object configuration files in the `configs` directory, and `create` or `patch` the live objects. You can first `diff` to see what changes are going to be made, and then apply:

{% highlight bash %}
kubectl diff -f configs/
kubectl apply -f configs/
{% endhighlight %}

Recursively process directories:

{% highlight bash %}
kubectl diff -R -f configs/
kubectl apply -R -f configs/
{% endhighlight %}

Advantages compared to imperative object configuration:

1. Changes made directly to live objects are retained, even if they are not merged back into the configuration files.
2. Declarative object configuration has better support for operating on directories and automatically detecting operation types (`create`, `patch`, `delete`) per-object.

Disadvantages compared to imperative object configuration:

1. Declarative object configuration is harder to debug and understand results when they are unexpected.
2. Partial updates using diffs create complex merge and patch operations.