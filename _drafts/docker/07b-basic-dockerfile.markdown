---
layout: post
title: "Basic Dockerfile"
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
image_path: /resources/posts/docker/07b-basic-dockerfile
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang Dockerfile references diantaranya:

1. `FROM` instruction
2. Environment replacement
3. Copy resources
    1. `ADD` instruction
    2. `COPY` instruction
4. Dockeringore
5. Execute commands
    1. `RUN` instruction
    2. `CMD` instruction
    3. `Entrypoint` instruction
6. `LABEL` instruction
7. `EXPOSE` instruction
8. Environtment `ARGS` instruction
9. `USER` instruction
10. `WORKDIR` instruction
11. `HEALTHCHECK` intruction

Ok sekarang kita bahas satu-per-satu ya.

## `FROM` instruction

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

{% gist page.gist "07b-dockerfile-from-instruction.bash" %}

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

## Environment replacement

Environment variables (declared with the `ENV` statement) can also be used in certain instructions as variables to be interpreted by the `Dockerfile`. Escapes are also handled for including variable-like syntax into a statement literally.

Environment variables are notated in the `Dockerfile` either with `$variable_name` or `${variable_name}`. They are treated equivalently and the brace syntax is typically used to address issues with variable names with no whitespace, like `${foo}_bar`.

The ${variable_name} syntax also supports a few of the standard bash modifiers as specified below:
1. `${variable:-word}` indicates that if `variable` is set then the result will be that value. If `variable` is not set then word will be the result.
2. `${variable:+word}` indicates that if `variable` is set then word will be the result, otherwise the result is the empty string.

Environment variables are supported by the following list of instructions in the Dockerfile: `ADD`, `COPY`, `ENV`, `EXPOSE`,  `FROM`, `LABEL`, `STOPSIGNAL`, `USER`, `VOLUME`, `WORKDIR`, and `ONBUILD` 

Contoh penggunaanya seperti berikut:

{% gist page.gist "07b-dockerfile-env-replacement.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.2 .
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                                                   0.0s 
 => => transferring dockerfile: 281B                                                                                   0.0s 
 => [internal] load .dockerignore                                                                                      0.0s 
 => => transferring context: 2B                                                                                        0.0s 
 => [internal] load metadata for docker.io/library/centos:7                                                            0.0s 
 => [1/2] FROM docker.io/library/centos:7                                                                              0.0s 
 => CACHED [2/2] RUN mkdir -p /usr/share/nginx/html && echo "<html><head><title>Halo World</title></head><body><h3>it"  0.0s 
 => exporting to image                                                                                                 0.0s 
 => => exporting layers                                                                                                0.0s 
 => => writing image sha256:22b22460babc563c047eed204534a463d34a13a1cb75dda635d49bcddcb9351e                           0.0s 
 => => naming to docker.io/dimmaryanto93/centos:0.2

➜ 07-dockerfile  docker run --rm dimmaryanto93/centos:0.2  
<html><head><title>Halo World</title></head><body><h3>it''s Works!</h3></body></html>
```

## Copy resources

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

{% gist page.gist "07b-dockerfile-copy.bash" %}

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

