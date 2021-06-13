---
layout: post
title: "Basic Dockerfile - Environtment Replacement"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: 
comments: true
image_path: /resources/posts/docker/07c-dockerfile-env
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Environment variables (declared with the `ENV` statement) can also be used in certain instructions as variables to be interpreted by the `Dockerfile`. Escapes are also handled for including variable-like syntax into a statement literally.

Environment variables are notated in the `Dockerfile` either with `$variable_name` or `${variable_name}`. They are treated equivalently and the brace syntax is typically used to address issues with variable names with no whitespace, like `${foo}_bar`.

The ${variable_name} syntax also supports a few of the standard bash modifiers as specified below:
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