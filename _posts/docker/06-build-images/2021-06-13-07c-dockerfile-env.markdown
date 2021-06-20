---
layout: post
title: "Basic Dockerfile - Environtment Replacement"
date: 2021-06-13T15:31:06+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: lEA1NfTjHZ4
comments: true
image_path: /resources/posts/docker/07c-dockerfile-env
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas lebih dalam tentang Env pada Dockerfile diantaranya seperti berikut:

1. Environtment Variable
2. Build Args
3. Clean

Ok kita langsung ja ke pembahasan yang pertama yaitu environtment variable

## Environtment Variable

Environment variables (declared with the `ENV` statement) can also be used in certain instructions as variables to be interpreted by the `Dockerfile`. Escapes are also handled for including variable-like syntax into a statement literally.

Environment variables are notated in the `Dockerfile` either with `$variable_name` or `${variable_name}`. They are treated equivalently and the brace syntax is typically used to address issues with variable names with no whitespace, like `${foo}_bar`.

The `${variable_name}` syntax also supports a few of the standard bash modifiers as specified below:
1. `${variable:-word}` indicates that if `variable` is set then the result will be that value. If `variable` is not set then word will be the result.
2. `${variable:+word}` indicates that if `variable` is set then word will be the result, otherwise the result is the empty string.

Environment variables are supported by the following list of instructions in the Dockerfile: `ADD`, `COPY`, `ENV`, `EXPOSE`,  `FROM`, `LABEL`, `STOPSIGNAL`, `USER`, `VOLUME`, `WORKDIR`, and `ONBUILD` 

Contoh penggunaanya seperti berikut:

{% gist page.gist "07b-dockerfile-env-replacement" %}

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

## Build Args

The `ARG` instruction defines a variable that users can pass at build-time to the builder with the docker build command using the `--build-arg` `<varname>=<value>` flag. If a user specifies a build argument that was not defined in the Dockerfile, the build outputs a warning.

A Dockerfile may include one or more ARG instructions. For example, the following is a valid Dockerfile:

{% highlight docker %}
ARG <name>[=<default value>]
{% endhighlight %}

**Notes: It is not recommended to use build-time variables for passing secrets like github keys, user credentials etc. Build-time variable values are visible to any user of the image with the `docker history` command. Refer to the “build images with BuildKit” section to learn about secure ways to use secrets when building images.**

Berikut adalah contoh penggunaanya:

{% gist page.gist "07c-dockerfile-args" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:0.2 .
[+] Building 0.4s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 365B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 173B                                                      0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => CACHED [1/2] FROM docker.io/library/centos:7                                       0.0s
 => [2/2] RUN mkdir -p /usr/share/nginx/html && echo "<html><head><title>Halo World</"  0.2s
 => exporting to image                                                                 0.0s
 => => exporting layers                                                                0.0s
 => => writing image sha256:d6171a364212fcba9782882335591e02c650c52edef49c511878ed0a7  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.2

➜ 07-dockerfile  docker run --rm dimmaryanto93/centos:0.2
<html><head><title>Halo World</title></head><body><h3>it''s Works!</h3></body></html>

## Override default value
➜ 07-dockerfile  docker build --build-arg IMAGE_VERSION=8 -t dimmaryanto93/centos:0.2 .
[+] Building 29.3s (7/7) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 32B                                                    0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 35B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:8                            4.1s
 => [auth] library/centos:pull token for registry-1.docker.io                          0.0s
 => [1/2] FROM docker.io/library/centos:8@sha256:5528e8b1b1719d34604c87e11dcd1c0a20b  24.5s
 => => resolve docker.io/library/centos:8@sha256:5528e8b1b1719d34604c87e11dcd1c0a20be  0.0s
 => => sha256:7a0437f04f83f084b7ed68ad9c4a4947e12fc4e1b006b38129ba 75.18MB / 75.18MB  21.8s
 => => sha256:5528e8b1b1719d34604c87e11dcd1c0a20bedf46e83b5632cdeac91b8c0 762B / 762B  0.0s
 => => sha256:dbbacecc49b088458781c16f3775f2a2ec7521079034a7ba499c8b0bb7f 529B / 529B  0.0s
 => => sha256:300e315adb2f96afe5f0b2780b87f28ae95231fe3bdd1e16b9ba606 2.14kB / 2.14kB  0.0s
 => => extracting sha256:7a0437f04f83f084b7ed68ad9c4a4947e12fc4e1b006b38129bac89114ec  2.5s
 => [2/2] RUN mkdir -p /usr/share/nginx/html && echo "<html><head><title>Halo World</"  0.6s
 => exporting to image                                                                 0.0s
 => => exporting layers                                                                0.0s
 => => writing image sha256:2ecf53b20c0c7cbe588a3d1142f0cf58aafe7edacc66fe74d906d9b71  0.0s
 => => naming to docker.io/dimmaryanto93/centos:0.2

➜ 07-dockerfile  docker run --rm dimmaryanto93/centos:0.2
<html><head><title>Halo World</title></head><body><h3>it''s Works!</h3></body></html>
```

Selain itu juga, kita disediakan `Predefined ARGs` yaitu `HTTP_PROXY`, `http_proxy`, `HTTPS_PROXY`, `https_proxy`, `FTP_PROXY`, `ftp_proxy`, `NO_PROXY`, dan `no_proxy`.

## Cleanup

Seperti biasa, setelah kita mencoba praktikan kita bersih-bersih dulu ya. berikut perintahnya:

{% gist page.gist "07b-cleanup.bash" %}