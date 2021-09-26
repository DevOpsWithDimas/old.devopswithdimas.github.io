---
layout: post
title: "FROM Instruction"
date: 2021-06-13T15:21:24+07:00
lang: docker
categories:
- DevOps
- Docker
- Dockerfile
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: t8uire2DNHE
comments: true
catalog_key: dockerfile
image_path: /resources/posts/docker/07b-basic-dockerfile
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas secara lebih mendalam tentang `Dockerfile` perintah `FROM` sebagai berikut:

The `FROM` instruction initializes a new build stage and sets the [Base Image](https://docs.docker.com/glossary/#base_image) for subsequent instructions. As such, a valid `Dockerfile` must start with a `FROM` instruction. Berikut adalah format penulisan `FROM` instrustion

{% highlight docker %}
FROM [--platform=<platform>] <image> [AS <name>]
{% endhighlight %}

{% highlight docker %}
FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
{% endhighlight %}

{% highlight docker %}
FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
{% endhighlight %}

The image can be any valid image – it is especially easy to start by pulling an image from the [Public Repositories](https://docs.docker.com/docker-hub/repos/).

1. `ARG` is the only instruction that may precede FROM in the Dockerfile. See [Understand how ARG and FROM interact](https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact).
2. `FROM` can appear multiple times within a single `Dockerfile` to create multiple images or use one build stage as a dependency for another. Simply make a note of the last image ID output by the commit before each new `FROM` instruction. Each `FROM` instruction clears any state created by previous instructions.
3. Optionally a name can be given to a new build stage by adding `AS name` to the `FROM` instruction. The name can be used in subsequent `FROM` and `COPY --from=<name>` instructions to refer to the image built in this stage.
4. The `tag` or `digest` values are optional. If you omit either of them, the builder assumes a `latest` tag by default. The builder returns an error if it cannot find the `tag` value.

Contoh penggunaanya seperti berikut:

{% gist page.gist "07b-dockerfile-from-instruction" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.1 .
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                          0.0s 
 => => transferring dockerfile: 31B                                                           0.0s 
 => [internal] load .dockerignore                                                             0.0s 
 => => transferring context: 2B                                                               0.0s 
 => [internal] load metadata for docker.io/library/centos:7                                   0.0s 
 => [1/2] FROM docker.io/library/centos:7                                                     0.0s 
 => CACHED [2/2] RUN echo "halo semuanya, ini adalah contoh text" > /var/halo.txt             0.0s 
 => exporting to image                                                                        0.0s 
 => => exporting layers                                                                       0.0s 
 => => writing image sha256:53126b30ada3ad85fb6215503e2022bd264f0ef1a7ceac213a6e08e19afdf191  0.0s 
 => => naming to docker.io/dimmaryanto93/centos:0.1

➜ 07-dockerfile  docker run --rm dimmaryanto93/centos:0.1
halo semuanya, ini adalah contoh text
```

## Cleanup

Seperti biasa, setelah kita mencoba kita bersih-bersih dulu ya berikut perintahnya:

{% gist page.gist "07b-cleanup.bash" %}
