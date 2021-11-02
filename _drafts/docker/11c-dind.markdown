---
layout: post
title: "Docker Inside Docker (DinD)"
lang: docker
categories:
- DevOps
- Docker
- Context
refs: 
- https://www.docker.com/blog/docker-can-now-run-within-docker/
- https://hub.docker.com/_/docker
- https://jpetazzo.github.io/2015/09/03/do-not-use-docker-in-docker-for-ci/
- https://devopscube.com/run-docker-in-docker/
- https://docs.gitlab.com/ce/ci/docker/using_docker_build.html
youtube: 
comments: true
catalog_key: docker-context
image_path: /resources/posts/docker/11c-dind
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas tentang Docker in Docker atau orang2 mengebutnya **DinD** atau **Recursive Docker** atau **Dockerception**, Diantaranya nanti kita akan bahas

1. What is Docker in Docker (DinD)?
2. Run Docker in Docker container
3. Docker in Docker use cases?
4. Key Considerations

Ok langsung aja kita bahas materi yang pertama yaitu 

## What is Docker in Docker (DinD)?

Although running Docker inside Docker is generally not recommended, there are some legitimate use cases. The primary purpose of Docker-in-Docker was to help with the development of Docker itself. Many people use it to run CI (e.g. with Gitlab CI, Jenkins, Github Action, etc)

Docker in Docker (DinD) yaitu Kita bisa menjalankan docker daemon dalam docker container (Sub Docker host) jika kita gambarkan seperti berikut:

![architecture docker in docker]({{ page.image_path | prepend: site.baseurl }}/docker-in-docker-arch.jpg)

## Run Docker in Docker container methods

Ada 3 cara untuk menggunakan Docker in Docker (DinD), yaitu

1. Run docker by mounting `docker.sock` (DooD Method)
2. Docker in Docker (DinD) method

**Run docker by mounting `docker.sock`**

`/var/run/docker.sock` is the default Unix socket. Sockets are meant for communication between processes on the same host. Docker daemon by default listens to `docker.sock`. If you are on the same host where Docker daemon is running, you can use the `/var/run/docker.sock` to manage containers. Seperti berikut contohnya:

```powershell
[dimasm93@dev01 ~]$ docker context inspect --format '{% raw %}{{ .Name }} => {{ .Endpoints.docker.Host }}{% endraw %}'
default => unix:///var/run/docker.sock

# For example, if you run the following command, it would return the version of docker engine.
[dimasm93@dev01 ~]$ curl --unix-socket /var/run/docker.sock http://localhost/version | python3 -m json.tool
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   884  100   884    0     0  38434      0 --:--:-- --:--:-- --:--:-- 38434
{
    "Platform": {
        "Name": "Docker Engine - Community"
    },
    "Components": [
        {
            "Name": "Engine",
            "Version": "19.03.14",
            "Details": {
                "ApiVersion": "1.40",
                "Arch": "amd64",
                "BuildTime": "2020-12-01T19:19:17.000000000+00:00",
                "Experimental": "false",
                "KernelVersion": "4.18.0-305.19.1.el8_4.x86_64",
                "MinAPIVersion": "1.12",
                "Os": "linux"
            }
        },
        {
            "Name": "containerd",
            "Version": "1.2.13",
            "Details": {
                "GitCommit": "7ad184331fa3e55e52b890ea95e65ba581ae3429"
            }
        },
        {
            "Name": "runc",
            "Version": "1.0.0-rc10",
            "Details": {
                "GitCommit": "dc9208a3303feef5b3839f4323d9beb36df0a9dd"
            }
        },
        {
            "Name": "docker-init",
            "Version": "0.18.0",
            "Details": {
                "GitCommit": "fec3683"
            }
        }
    ],
    "Version": "19.03.14",
    "ApiVersion": "1.40",
    "Os": "linux",
    "Arch": "amd64",
    "KernelVersion": "4.18.0-305.19.1.el8_4.x86_64"
}
```

Atau berikut adalah `docker-compose.yaml` untuk method `docker.sock`

{% gist page.gist "11c-dood-without-tls.docker-compose.yaml" %}

**Docker in Docker (DinD) method**

This method actually creates a child container inside a container. Use this method only if you really want to have the containers and images inside the container. Otherwise, I would suggest you use the first approach.

For this, you just need to use the [official docker](https://hub.docker.com/_/docker) image with dind `tag`. The dind image is baked with required utilities for Docker to run inside a docker container. 

For example this is sample `docker-compose.yaml`:

{% gist page.gist "11c-dind-without-tls.docker-compose.yaml" %}

## Docker in Docker use cases?

Nah buat temen-temen yang masih binggung sebetulnya, buat apa sih Docker in Docker (DinD). Berikut adalah beberapa contoh kasus penggunaannya:

1. One potential use case for docker in docker is for the CI pipeline, where you need to build and push docker images to a container registry after a successful code build.
2. Docker daemon clusters espesialy using for docker swarm (alternative for docker-machine).
3. Sandboxed environments.
4. For experimental purposes on your local development workstation (docker development it's self).

# Key Considerations

1. Use Docker in Docker only if it is a requirement. Do the POCs and enough testing before migrating any workflow to the Docker-in-Docker method.
2. While using containers in privileged mode, make sure you get the necessary approvals from enterprise security teams on what you are planning to do.
3. Running docker in docker using `docker.sock` and `dind` method is less secure as it has complete privileges over the docker daemon.
4. The performance of the container doesn’t have any effect because of the methods you use. However, the underlying hardware decides on the performance.