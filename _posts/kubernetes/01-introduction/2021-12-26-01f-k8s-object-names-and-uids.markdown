---
layout: post
title: "Kubernetes Object Names and IDs"
date: 2021-12-26T14:31:53+07:00
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
refs: 
- https://docs.docker.com/
- https://kubernetes.io/docs/concepts/overview/working-with-objects/names/
- https://minikube.sigs.k8s.io/docs/
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/kubernetes/01f-k8s-object-names-and-uids
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
downloads: []
---

Hai semuanya, Setelah kita mengetahui bagaimana cara beriteraksi dengan Kubernetes cluster. Sekarang kita akan bahas Aturan atau rules yang perlu kita ketahui sebelum mencoba / membuat object Kubernetes yaitu tentang Object Names dan IDs. Aturan atau Rules pada kubernetes terdiri Dari

1. Object Names
2. Standard definision for Naming resources
3. UIDs

Ok langsung aja kita ke pembahasan yang pertama yaitu

## Object Names and IDs

Each object in your cluster has a Name that is unique for that type of resource. Every Kubernetes object also has a UID that is unique across your whole cluster. For example, you can only have one Pod named `myapp-1234` within the same [namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/), but you can have one Pod and one Deployment that are each named `myapp-1234`.

For non-unique user-provided attributes, Kubernetes provides [labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) and [annotations](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/).

A client-provided string that refers to an object in a resource URL, such as `/api/v1/pods/some-name`.

Only one object of a given kind can have a given name at a time. However, if you delete the object, you can make a new object with the same name.

## Standard definision for Naming resources

Below are four types of commonly used name constraints for resources.

1. **RFC 1123 Label Names**, Some resource types require their names to follow the DNS label standard as defined in [RFC 1123](https://tools.ietf.org/html/rfc1123). This means the name must:
    1. contain at most `63 characters`
    2. contain only lowercase alphanumeric characters or `-`
    3. start with an `alphanumeric character`
    4. end with an `alphanumeric character`

2. **DNS Subdomain Names**, Most resource types require a name that can be used as a DNS subdomain name as defined in [RFC 1123](https://tools.ietf.org/html/rfc1123)

3. **RFC 1035 Label Names**, Some resource types require their names to follow the DNS label standard as defined in [RFC 1035](https://tools.ietf.org/html/rfc1035). This means the name must:
    1. contain at most `63 characters`
    2. contain only lowercase alphanumeric characters or `-`
    3. start with an `alphabetic character`
    4. end with an `alphanumeric character`

4. **Path Segment Names**, Some resource types require their names to be able to be safely encoded as a path segment. In other words, the name may not be `.` or `..` and the name may not contain `/` or `%`.

## UIDs

A Kubernetes systems-generated string to uniquely identify objects.

Every object created over the whole lifetime of a Kubernetes cluster has a distinct UID. It is intended to distinguish between historical occurrences of similar entities.

Kubernetes UIDs are universally unique identifiers (also known as UUIDs). UUIDs are standardized as ISO/IEC 9834-8 and as ITU-T X.667.