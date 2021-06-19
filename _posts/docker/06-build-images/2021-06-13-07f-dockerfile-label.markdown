---
layout: post
title: "Basic Dockerfile - Label Instruction"
date: 2021-06-13T18:46:32+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: 
comments: true
image_path: /resources/posts/docker/07f-dockerfile-label
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Labeling pada suatu image yang kita build yaitu sebagai berikut:

The `LABEL` instruction adds metadata to an image. A `LABEL` is a key-value pair. To include spaces within a `LABEL` value, use quotes and backslashes as you would in command-line parsing. A few usage examples:

{% highlight docker %}
LABEL "com.example.vendor"="ACME Incorporated"
LABEL com.example.label-with-value="foo"
LABEL version="1.0"
LABEL description="This text illustrates \
that label-values can span multiple lines."
{% endhighlight %}

The `MAINTAINER` instruction sets the Author field of the generated images. The `LABEL` instruction is a much more flexible version of this and you should use it instead, as it enables setting any metadata you require, and can be viewed easily, for example with `docker inspect`. To set a label corresponding to the `MAINTAINER` field you could use:

{% highlight docker %}
MAINTAINER "someone@something.com" # deprecated
LABEL maintainer="someone@something.com"
{% endhighlight %}

For Example:

{% gist page.gist "07f-dockerfile-label" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ bootcamp docker build -t dimmaryanto93/centos:0.5 .                               
[+] Building 0.2s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                 0.0s 
 => => transferring dockerfile: 371B                                                 0.0s 
 => [internal] load .dockerignore                                                    0.0s 
 => => transferring context: 34B                                                     0.0s 
 => [internal] load metadata for docker.io/library/centos:7                          0.0s 
 => [internal] load build context                                                    0.0s 
 => => transferring context: 494B                                                    0.0s 
 => [1/3] FROM docker.io/library/centos:7                                            0.0s 
 => CACHED [2/3] RUN mkdir -p /usr/share/nginx/html                                  0.0s 
 => [3/3] ADD . /usr/share/nginx/html                                                0.0s 
 => exporting to image                                                               0.0s 
 => => exporting layers                                                              0.0s 
 => => writing image sha256:6ca624eebf09de934c436767d7ba8c5b58b6449f7543f74b7aca089  0.0s 
 => => naming to docker.io/dimmaryanto93/centos:0.5

➜ bootcamp docker images
REPOSITORY             TAG       IMAGE ID       CREATED         SIZE
dimmaryanto93/centos   0.5       6ca624eebf09   2 minutes ago   204MB
dimmaryanto93/centos   0.4       7109257718d3   4 hours ago     204MB
dimmaryanto93/centos   0.3       e4e14fbbd628   5 hours ago     204MB
dimmaryanto93/centos   0.2       22b22460babc   7 hours ago     204MB
dimmaryanto93/centos   0.1       53126b30ada3   19 hours ago    204MB

➜ bootcamp docker image inspect dimmaryanto93/centos:0.5 -f '{% raw %}{{json .Config.Labels}}{% endraw %}'
{
   "com.maryanto.dimas.image.authors":"software.dimas_m@icloud.com",
   "com.maryanto.dimas.vendor":"PT. Tabeldata Informatika",
   "maintaniner":"software.dimas_m@icloud.com",
   "org.label-schema.build-date":"20201113",
   "org.label-schema.license":"GPLv2",
   "org.label-schema.name":"CentOS Base Image",
   "org.label-schema.schema-version":"1.0",
   "org.label-schema.vendor":"CentOS",
   "org.opencontainers.image.created":"2020-11-13 00:00:00+00:00",
   "org.opencontainers.image.licenses":"GPL-2.0-only",
   "org.opencontainers.image.title":"CentOS Base Image",
   "org.opencontainers.image.vendor":"CentOS",
   "version":"0.5"
}
```

## Cleanup

Seperti biasa, setelah kita mencoba praktikan kita bersih-bersih dulu ya. berikut perintahnya:

{% gist page.gist "07b-cleanup.bash" %}