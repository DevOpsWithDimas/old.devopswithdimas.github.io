---
layout: post
title: "Basic Dockerfile - Copying Resources"
date: 2021-06-13T15:32:24+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
- https://nickjanetakis.com/blog/docker-tip-2-the-difference-between-copy-and-add-in-a-dockerile
youtube: 
comments: true
image_path: /resources/posts/docker/07d-dockerfile-copy
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Copies new files/directory into image, kita bisa menggunakan perintah `ADD` dan `COPY`.

The `ADD` instruction copies new files, directories or remote file URLs from <src> and adds them to the filesystem of the image at the path <dest>. The `COPY` instruction copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>. 

To add all files/directory from root context

{% highlight docker %}
COPY . /target
{% endhighlight %}

To copy all files ending with `.jar`

{% highlight docker %}
COPY *.jar /target
{% endhighlight %}

To copy files, `?` is replaced with any single character, e.g., "home.txt", "halo.txt", "heyy.txt", etc.

{% highlight docker %}
COPY h???.txt /target
{% endhighlight %}

To download files from source type url:

{% highlight docker %}
ADD https://github.com/BootcampYoutubeChannel/belajar-docker/archive/refs/tags/07b-copy-resource.tar.gz /target
{% endhighlight %}

To Extract file from source type `zip`, `tar.gz` etc:

{% highlight docker %}
ADD belajar-docker-07b-copy-resource.tar.gz /target
{% endhighlight %}

For Example

Download file [belajar-docker-07b-copy-resource.tar.gz](https://github.com/BootcampYoutubeChannel/belajar-docker/archive/refs/tags/07b-copy-resource.tar.gz) kemudian simpan dalam folder yang sama dengan file `Dockerfile` seperti berikut:

{% gist page.gist "07b-dockerfile-copy" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile ✗  docker build -t dimmaryanto93/centos:0.3 .       
[+] Building 0.1s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                                                   0.0s 
 => => transferring dockerfile: 168B                                                                                   0.0s 
 => [internal] load .dockerignore                                                                                      0.0s 
 => => transferring context: 2B                                                                                        0.0s 
 => [internal] load metadata for docker.io/library/centos:7                                                            0.0s 
 => [internal] load build context                                                                                      0.0s 
 => => transferring context: 61B                                                                                       0.0s 
 => [1/2] FROM docker.io/library/centos:7                                                                              0.0s 
 => CACHED [2/2] ADD *.tar.gz /usr/share/nginx/html                                                                    0.0s 
 => exporting to image                                                                                                 0.0s 
 => => exporting layers                                                                                                0.0s 
 => => writing image sha256:e4e14fbbd62885b0c6a18b6a444121f54884a90e21c2a00816e51d419e6dca79                           0.0s 
 => => naming to docker.io/dimmaryanto93/centos:0.3

 ➜ 07-dockerfile ✗  docker run --rm -it dimmaryanto93/centos:0.3     
8.0K    /usr/share/nginx/html/belajar-docker-07b-copy-resource/html
12K     /usr/share/nginx/html/belajar-docker-07b-copy-resource/conf
24K     /usr/share/nginx/html/belajar-docker-07b-copy-resource
28K     /usr/share/nginx/html/
28K     total
```