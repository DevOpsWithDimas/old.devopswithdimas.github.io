---
layout: post
title: "Build docker image using Compose file"
date: 2021-08-28T18:46:43+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Build
refs: 
- https://docs.docker.com/compose/reference/build/
- https://docs.docker.com/compose/compose-file/compose-file-v3/#build
youtube: 1YAevQ1ZsKw
comments: true
image_path: /resources/posts/docker/09i-compose-build-image
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang build docker image melalui compose file. Diantaranya yang akan kita bahas yaitu

1. Basic build
2. Using context
3. Using build args
4. `docker-compose build` command options

Ok langsung ja kita ke pembahasan yang pertama 

# Basic build docker image

Configuration options that are applied at build time. `build` can be specified either as a string containing a path to the build context or, as an object with the path specified under context and optionally Dockerfile and args:

{% gist page.gist "09m-basic-build.docker-compose.yaml" %}

Berikut adalah file `Dockerfile` 

{% gist page.gist "09m-basic-build.dockerfile" %}

Kita bisa jalankan menggunakan perintah 

{% highlight bash %}
docker-compose -f docker-compose.yaml up -d --build
{% endhighlight %}

Maka berikut hasilnya:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\build\basic\docker-compose.yaml up -d --build
Building webapp
[+] Building 0.4s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                          0.0s
 => => transferring dockerfile: 142B                                                          0.0s
 => [internal] load .dockerignore                                                             0.0s
 => => transferring context: 2B                                                               0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                               0.0s
 => [1/2] FROM docker.io/library/nginx:latest                                                 0.2s
 => [2/2] WORKDIR /usr/share/nginx/html                                                       0.0s
 => exporting to image                                                                        0.1s
 => => exporting layers                                                                       0.0s
 => => writing image sha256:234f4c13de9060b63a7a7bec87bad3e0b316043f0f2ff5bdd95d8601fc646a70  0.0s
 => => naming to docker.io/dimmaryanto93/my-web:latest                                        0.0s
Creating basic_webapp_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\build\basic\docker-compose.yaml ps
     Name                   Command               State                Ports
------------------------------------------------------------------------------------------
basic_webapp_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp

➜ docker  docker images dimmaryanto93/*
REPOSITORY             TAG       IMAGE ID       CREATED              SIZE
dimmaryanto93/my-web   latest    234f4c13de90   About a minute ago   133MB

➜ docker  docker-compose -f .\09-docker-compose\build\basic\docker-compose.yaml down
Stopping basic_webapp_1 ... done
Removing basic_webapp_1 ... done
Removing network basic_default
```

## Using build context

Either a path to a directory containing a Dockerfile, or a url to a git repository.

When the value supplied is a relative path, it is interpreted as relative to the location of the Compose file. This directory is also the build context that is sent to the Docker daemon.

Compose builds and tags it with a generated name, and uses that image thereafter.

{% gist page.gist "09m-build-context.docker-compose.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\build\context\docker-compose.yaml up -d --build
Building webapp
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                             0.0s
 => => transferring dockerfile: 31B                                                              0.0s
 => [internal] load .dockerignore                                                                0.0s
 => => transferring context: 2B                                                                  0.0s
 => [internal] load metadata for docker.io/library/nginx:latest                                  0.0s
 => [1/2] FROM docker.io/library/nginx:latest                                                    0.0s
 => CACHED [2/2] WORKDIR /usr/share/nginx/html                                                   0.0s
 => exporting to image                                                                           0.0s
 => => exporting layers                                                                          0.0s
 => => writing image sha256:234f4c13de9060b63a7a7bec87bad3e0b316043f0f2ff5bdd95d8601fc646a70     0.0s
 => => naming to docker.io/dimmaryanto93/my-web-context:latest                                           0.0s
Recreating context_webapp_1 ... done
```

## Using build args

Add build arguments, which are environment variables accessible only during the build process.

First, specify the arguments in your Dockerfile:

{% gist page.gist "09m-basic-build.dockerfile" %}

Then specify the arguments under the build key. You can pass a mapping or a list:

{% gist page.gist "09m-build-args-list.docker-compose.yaml" %}

{% gist page.gist "09m-build-args-maps.docker-compose.yaml" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\build\args\list.docker-compose.yaml up -d --build
Building webapp
[+] Building 0.1s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                            0.0s
 => => transferring dockerfile: 31B                                                             0.0s
 => [internal] load .dockerignore                                                               0.0s
 => => transferring context: 2B                                                                 0.0s
 => [internal] load metadata for docker.io/library/nginx:mainline                               0.0s
 => [1/2] FROM docker.io/library/nginx:mainline                                                 0.0s
 => CACHED [2/2] WORKDIR /usr/share/nginx/html                                                  0.0s
 => exporting to image                                                                          0.0s
 => => exporting layers                                                                         0.0s
 => => writing image sha256:234f4c13de9060b63a7a7bec87bad3e0b316043f0f2ff5bdd95d8601fc646a70    0.0s
 => => naming to docker.io/dimmaryanto93/my-web-args:latest

➜ docker  docker-compose -f .\09-docker-compose\build\args\list.docker-compose.yaml down
Stopping args_webapp_1 ... done
Removing args_webapp_1 ... done
Removing network args_default

➜ docker  docker-compose -f .\09-docker-compose\build\args\maps.docker-compose.yaml up -d --build
Creating network "args_default" with the default driver
Building webapp
[+] Building 1.3s (6/6) FINISHED
 => [internal] load build definition from Dockerfile                                           0.0s
 => => transferring dockerfile: 31B                                                            0.0s
 => [internal] load .dockerignore                                                              0.0s
 => => transferring context: 2B                                                                0.0s
 => [internal] load metadata for docker.io/library/nginx:stable-alpine                         1.2s
 => [1/2] FROM docker.io/library/nginx:stable-alpine@sha256:bac218df22fef66a173cfa65d0dfa0742  0.0s
 => CACHED [2/2] WORKDIR /usr/share/nginx/html                                                 0.0s
 => exporting to image                                                                         0.0s
 => => exporting layers                                                                        0.0s
 => => writing image sha256:8af1b8c8d483d8fb3dd477b1486f9e897a1b2014ec6d5ae253f3f3bedb5b3a0a   0.0s
 => => naming to docker.io/dimmaryanto93/my-web-args:latest                                    0.0s
Creating args_webapp_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\build\args\maps.docker-compose.yaml down
Stopping args_webapp_1 ... done
Removing args_webapp_1 ... done
Removing network args_default
```

## `docker-compose build` command options

Services are built once and then tagged, by default as `project_service`. For example, `composetest_db`. If the Compose file specifies an [image](https://docs.docker.com/compose/compose-file/compose-file-v3/#image) name, the image is tagged with that name, substituting any variables beforehand. See [variable substitution](https://docs.docker.com/compose/compose-file/compose-file-v3/#variable-substitution).

If you change a service’s Dockerfile or the contents of its build directory, run `docker-compose build` to rebuild it.

```powershell
➜ docker  docker-compose build --help
Build or rebuild services.

Services are built once and then tagged as `project_service`,
e.g. `composetest_db`. If you change a service''s `Dockerfile` or the
contents of its build directory, you can run `docker-compose build` to rebuild it.

Usage: build [options] [--build-arg key=val...] [--] [SERVICE...]

Options:
    --build-arg key=val     Set build-time variables for services.
    --compress              Compress the build context using gzip.
    --force-rm              Always remove intermediate containers.
    -m, --memory MEM        Set memory limit for the build container.
    --no-cache              Do not use cache when building the image.
    --no-rm                 Do not remove intermediate containers after a successful build.
    --parallel              Build images in parallel.
    --progress string       Set type of progress output (auto, plain, tty).
    --pull                  Always attempt to pull a newer version of the image.
    -q, --quiet             Don''t print anything to STDOUT
```