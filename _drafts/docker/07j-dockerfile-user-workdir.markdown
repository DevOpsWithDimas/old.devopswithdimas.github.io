---
layout: post
title: "Basic Dockerfile - User, Volumes and Working Directory"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: 
comments: true
image_path: /resources/posts/docker/07i-dockerfile-user-workdir
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang `USER` Instruction, `VOLUME` Instruction dan `WORKDIR` Instruction diantaranya:

1. Run command non-root user
2. Using Working Directory
3. Volume for persistence data
4. Cleanup

Ok lansung aja kita ke materi yang pertama yaitu `USER` Instruction

## `USER` Instruction

The `USER` instruction sets the user name (or UID) and optionally the user group (or GID) to use when running the image and for any `RUN`, `CMD` and `ENTRYPOINT` instructions that follow it in the `Dockerfile`.

> Note that when specifying a group for the user, the user will have only the specified group membership. Any other configured group memberships will be ignored.

> Notes: When the user doesn’t have a primary group then the image (or the next instructions) will be run with the root group. 

{% highlight docker %}
USER <user>[:<group>]
{% endhighlight %}

OR

{% highlight docker %}
USER <UID>[:<GID>]
{% endhighlight %}

> **On Windows, the user must be created first** if it’s not a built-in account. This can be done with the `net user` command called as part of a `Dockerfile`.

{% highlight docker %}
FROM microsoft/windowsservercore
# Create Windows user in the container
RUN net user /add patrick
# Set it for subsequent commands
USER patrick
{% endhighlight %}

Contoh penggunaanya, seperti berikut:

{% gist page.gist "07j-dockerfile-run-non-root" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.4 .
[+] Building 0.1s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 518B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 35B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => [1/3] FROM docker.io/library/centos:7                                              0.0s
 => [internal] load build context                                                      0.0s
 => => transferring context: 32B                                                       0.0s
 => CACHED [2/3] RUN groupadd www-data && adduser -r -g www-data www-data              0.0s
 => CACHED [3/3] COPY --chown=www-data:www-data index.html /usr/share/nginx/html/inde  0.0s
 => exporting to image                                                                 0.0s
 => => exporting layers                                                                0.0s
 => => writing image sha256:dfd217de06f44d9d2a33808dcf9d77510bc2b05734d08e1830374c1e1  0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.4

➜ 07-dockerfile  docker run --rm dimmaryanto93/centos:1.3
www-data
total 12
drwxr-xr-x 2 www-data www-data 4096 Jun 20 12:49 .
drwxr-xr-x 3 www-data www-data 4096 Jun 20 12:49 ..
-rwxr-xr-x 1 www-data www-data 3105 Jun  5 09:08 index.html

➜ 07-dockerfile  docker run --rm -it  dimmaryanto93/centos:1.3 bash
bash-4.2$ pwd
/

bash-4.2$ whoami
www-data

bash-4.2$ ls -l /usr/share/nginx/html
total 4
-rwxr-xr-x 1 www-data www-data 3105 Jun  5 09:08 index.html
```

## Using `WORKDIR` Instruction

The `WORKDIR` instruction sets the working directory for any `RUN`, `CMD`, `ENTRYPOINT`, `COPY` and `ADD` instructions that follow it in the `Dockerfile`. If the `WORKDIR` doesn’t exist, it will be created even if it’s not used in any subsequent `Dockerfile` instruction.

The `WORKDIR` instruction can be used multiple times in a `Dockerfile`. If a relative path is provided, it will be relative to the path of the previous `WORKDIR` instruction. For example:

{% highlight docker %}
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
{% endhighlight %}

The output of the final `pwd` command in this `Dockerfile` would be `/a/b/c`.

The `WORKDIR` instruction can resolve environment variables previously set using `ENV`. You can only use environment variables explicitly set in the `Dockerfile`. For example:

{% highlight docker %}
ENV DIRPATH=/path
WORKDIR $DIRPATH/$DIRNAME
RUN pwd
{% endhighlight %}

The output of the final `pwd` command in this `Dockerfile` would be `/path/$DIRNAME`

Contoh penggunaanya seperti berikut:

{% gist page.gist "07j-dockerfile-workdir" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.4 .
[+] Building 0.2s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                   0.0s
 => => transferring dockerfile: 519B                                                   0.0s
 => [internal] load .dockerignore                                                      0.0s
 => => transferring context: 35B                                                       0.0s
 => [internal] load metadata for docker.io/library/centos:7                            0.0s
 => [1/4] FROM docker.io/library/centos:7                                              0.0s
 => [internal] load build context                                                      0.0s
 => => transferring context: 32B                                                       0.0s
 => CACHED [2/4] RUN groupadd www-data && adduser -r -g www-data www-data              0.0s
 => [3/4] WORKDIR /usr/share/nginx/html                                                0.0s
 => [4/4] COPY --chown=www-data:www-data index.html .                                  0.0s
 => exporting to image                                                                 0.1s
 => => exporting layers                                                                0.0s
 => => writing image sha256:cd868f8e9a60ae8cddb15b75496d1978530581fa7cdf85b9a3a3074f3  0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.4

➜ 07-dockerfile  docker run --rm -it  dimmaryanto93/centos:1.4
www-data

/usr/share/nginx/html

total 16
drwxr-xr-x 1 www-data www-data 4096 Jun 20 13:11 .
drwxr-xr-x 1 www-data www-data 4096 Jun 20 13:11 ..
-rwxr-xr-x 1 www-data www-data 3105 Jun  5 09:08 index.html

➜ 07-dockerfile  docker run --rm -it  dimmaryanto93/centos:1.4 bash
bash-4.2$ pwd
/usr/share/nginx/html

bash-4.2$ exit
```