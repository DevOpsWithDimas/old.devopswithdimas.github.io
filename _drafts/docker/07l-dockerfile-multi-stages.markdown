---
layout: post
title: "Basic Dockerfile - Multiple Stage Builds"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/develop/develop-images/multistage-build/
youtube: 
comments: true
image_path: /resources/posts/docker/07l-docker-multi-stage
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang Multiple stage builds pada single Dockerfile. Diantaranya yang akan kita bahas yaitu

1. Before multi-stage builds
2. Use multi-stage builds
3. Use an external image as a “stage”
4. Use a previous stage as a new stage
5. Cleanup

## Before multi-stage builds

One of the most challenging things about building images is keeping the image size down. Each instruction in the `Dockerfile` adds a layer to the image, and you need to remember to clean up any artifacts you don’t need before moving on to the next layer. To write a really efficient Dockerfile, you have traditionally needed to employ shell tricks and other logic to keep the layers as small as possible and to ensure that each layer has the artifacts it needs from the previous layer and nothing else.

It was actually very common to have one Dockerfile to use for development (which contained everything needed to build your application), and a slimmed-down one to use for production, which only contained your application and exactly what was needed to run it. This has been referred to as the “builder pattern”. Maintaining two Dockerfiles is not ideal.

Here’s an example of a `build.Dockerfile` and `Dockerfile` which adhere to the builder pattern above:

1. Simpan file berikut dengan nama `package.json`

    {% gist page.gist "07l-package.json" %}

2. Simpan file berikut dengan nama `index.html`

    {% gist page.gist "07l-index.html" %}

3. Simpan file berikut dengan nama `build.Dockerfile`

    {% gist page.gist "07l-build-dockerfile" %}

4. Simpan file berikut dengan nama `Dockerfile`

    {% gist page.gist "07l-before-multi-dockerfile" %}


Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -f .\build.Dockerfile -t dimmaryanto93/node:build .
[+] Building 1.3s (9/9) FINISHED
 => [internal] load build definition from build.Dockerfile                                                         0.0s
 => => transferring dockerfile: 37B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/node:16-alpine3.11                                              1.2s
 => [1/4] FROM docker.io/library/node:16-alpine3.11@sha256:7c8b9c43d364951531330c7005a39382b040544f79a9b97a2e4d22  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 34B                                                                                   0.0s
 => CACHED [2/4] WORKDIR /sources                                                                                  0.0s
 => CACHED [3/4] COPY package.json .                                                                               0.0s
 => CACHED [4/4] RUN npm install --prod                                                                            0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:422db87c7b7f27d46a288ec6b20cba0d60fb23aba53602aa33bc24fd4e476f97                       0.0s
 => => naming to docker.io/dimmaryanto93/node:build

➜ 07-dockerfile  docker create --name extract dimmaryanto93/node:build
7431e0726cea175748cf5805e76ec0d601cbedfa1722b1324e5650e3d2c51e71

➜ 07-dockerfile  docker container cp extract:/sources/node_modules .

➜ 07-dockerfile  ls .\node_modules\

    Directory: C:\Users\dimasm93\Workspaces\youtube\docker\07-dockerfile\node_modules
Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
d-----         6/23/2021   7:06 AM                hammerjs
d-----         6/23/2021   7:06 AM                jquery
d-----         6/23/2021   7:06 AM                materialize-css
-a----         6/23/2021   7:06 AM            940 .package-lock.json

➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.7 .
[+] Building 0.4s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 535B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                                    0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 21.54kB                                                                               0.0s
 => CACHED [1/4] FROM docker.io/library/nginx                                                                      0.0s
 => [2/4] WORKDIR /usr/share/nginx/html                                                                            0.0s
 => [3/4] COPY index.html .                                                                                        0.0s
 => [4/4] COPY node_modules node_modules/                                                                          0.1s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.1s
 => => writing image sha256:4b276a4282bb75e31df4b443e6b1b5e33bc86c792d4f22a157f458b513733f8f                       0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.7

➜ 07-dockerfile  docker run -p 80:80 -d dimmaryanto93/centos:1.7
95c1f56835ab2b8227422ab688045defbb700c5913dcfc73f89ad05e640f8122

➜ 07-dockerfile  docker images dimmaryanto93/centos:1.7
REPOSITORY             TAG       IMAGE ID       CREATED              SIZE
dimmaryanto93/centos   1.7       4b276a4282bb   About a minute ago   138MB
```

Jika kita jalankan di browser, akses alamat [localhost](http://localhost) hasilnya seperti berikut:

![index.html]({{ page.image_path | prepend: site.baseurl }}/index-html.png)

## Use multi-stage builds

With multi-stage builds, you use multiple `FROM` statements in your Dockerfile. Each `FROM` instruction can use a different base, and each of them begins a new stage of the build. You can selectively copy artifacts from one stage to another, leaving behind everything you don’t want in the final image. To show how this works, let’s adapt the Dockerfile from the previous section to use multi-stage builds.

{% gist page.gist "07l-multi-stage-dockerfile" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/nginx:1.8 .
[+] Building 1.4s (14/14) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/node:16-alpine3.11                                              1.3s
 => [internal] load metadata for docker.io/library/nginx:latest                                                    0.0s
 => [builder 1/4] FROM docker.io/library/node:16-alpine3.11@sha256:7c8b9c43d364951531330c7005a39382b040544f79a9b9  0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 64B                                                                                   0.0s
 => [stage-1 1/4] FROM docker.io/library/nginx                                                                     0.0s
 => CACHED [stage-1 2/4] WORKDIR /usr/share/nginx/html                                                             0.0s
 => CACHED [stage-1 3/4] COPY index.html .                                                                         0.0s
 => CACHED [builder 2/4] WORKDIR /sources                                                                          0.0s
 => CACHED [builder 3/4] COPY package.json .                                                                       0.0s
 => CACHED [builder 4/4] RUN npm install --prod                                                                    0.0s
 => CACHED [stage-1 4/4] COPY --from=builder /sources/node_modules node_modules/                                   0.0s
 => exporting to image                                                                                             0.0s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:2d29aa14fd2295100c999514616a8b8e4a61509e7661f5f34557d38d6825e297                       0.0s
 => => naming to docker.io/dimmaryanto93/nginx:1.8                                                                 0.0s

➜ 07-dockerfile  docker run -p 8080:80 -d dimmaryanto93/nginx:1.8
93f9c18127372f261d6eb53ddf3c72817534f11548fc24f17975f3d3927b1e66

➜ 07-dockerfile  docker container ls
CONTAINER ID   IMAGE                     COMMAND                  CREATED              STATUS                        PORTS                                   NAMES
93f9c1812737   dimmaryanto93/nginx:1.8   "/docker-entrypoint.…"   About a minute ago   Up About a minute (healthy)   0.0.0.0:8080->80/tcp, :::8080->80/tcp   keen_varahamihira

➜ 07-dockerfile  docker images dimmaryanto93/nginx
REPOSITORY            TAG       IMAGE ID       CREATED         SIZE
dimmaryanto93/nginx   1.8       2d29aa14fd22   4 minutes ago   138MB
```