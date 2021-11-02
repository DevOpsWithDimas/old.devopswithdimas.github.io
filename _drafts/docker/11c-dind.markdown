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
2. Docker in Docker use cases?
3. Run Docker in Docker container
3. The good, the bad, the ugly, and then gets better using Docker in Docker

Ok langsung aja kita bahas materi yang pertama yaitu 

## What is Docker in Docker (DinD)?

Although running Docker inside Docker is generally not recommended, there are some legitimate use cases. The primary purpose of Docker-in-Docker was to help with the development of Docker itself. Many people use it to run CI (e.g. with Gitlab CI, Jenkins, Github Action, etc)

Docker in Docker (DinD) yaitu Kita bisa menjalankan docker daemon dalam docker container (Sub Docker host) jika kita gambarkan seperti berikut:

![architecture docker in docker]({{ page.image_path | prepend: site.baseurl }}/docker-in-docker-arch.jpg)

For example this is sample `docker-compose.yaml`:

{% gist page.gist "11c-dind-without-tls.docker-compose.yaml" %}

Jika kita coba jalankan maka hasilnya seperti berikut:

```powershell
➜ docker git:(master) docker-compose -f .\09-docker-context\dind\basic.docker-compose.yaml up -d dockerd
Recreating dind_dockerd_1 ... done

➜ docker git:(master) docker-compose -f .\09-docker-context\dind\basic.docker-compose.yaml up docker
dind_dockerd_1 is up-to-date
Starting dind_docker_1 ... done
Attaching to dind_docker_1
docker_1   | Client:
docker_1   |  Context:    default
docker_1   |  Debug Mode: false
docker_1   |
docker_1   | Server:
docker_1   |  Containers: 0
docker_1   |   Running: 0
docker_1   |   Paused: 0
docker_1   |   Stopped: 0
docker_1   |  Images: 0
docker_1   |  Server Version: 18.09.9
docker_1   |  Storage Driver: overlay2
docker_1   |   Backing Filesystem: extfs
docker_1   |   Supports d_type: true
docker_1   |   Native Overlay Diff: true
docker_1   |  Logging Driver: json-file
docker_1   |  Cgroup Driver: cgroupfs
docker_1   |  Plugins:
docker_1   |   Volume: local
docker_1   |   Network: bridge host macvlan null overlay
docker_1   |   Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
docker_1   |  Swarm: inactive
docker_1   |  Runtimes: runc
docker_1   |  Default Runtime: runc
docker_1   |  Init Binary: docker-init
docker_1   |  containerd version: 894b81a4b802e4eb2a91d1ce216b8817763c29fb
docker_1   |  runc version: 425e105d5a03fabd737a126ad93d62a9eeede87f
docker_1   |  init version: fec3683
docker_1   |  Security Options:
docker_1   |   seccomp
docker_1   |    Profile: default
docker_1   |  Kernel Version: 4.19.128-microsoft-standard
docker_1   |  Operating System: Alpine Linux v3.10 (containerized)
docker_1   |  OSType: linux
docker_1   |  Architecture: x86_64
docker_1   |  CPUs: 2
docker_1   |  Total Memory: 3.842GiB
docker_1   |  Name: b21597bc4d19
docker_1   |  ID: UBPC:4BAN:B7SH:TE4Q:VT63:WDU4:3O3P:BL2H:ZTKC:UCLI:B2KI:TKEJ
docker_1   |  Docker Root Dir: /var/lib/docker
docker_1   |  Debug Mode: false
docker_1   |  Registry: https://index.docker.io/v1/
docker_1   |  Labels:
docker_1   |  Experimental: false
docker_1   |  Insecure Registries:
docker_1   |   192.168.88.50:8086
docker_1   |   192.168.88.50:8087
docker_1   |   127.0.0.0/8
docker_1   |  Live Restore Enabled: false
docker_1   |  Product License: Community Engine
docker_1   |
docker_1   | WARNING: API is accessible on http://0.0.0.0:2375 without encryption.
docker_1   |          Access to the remote API is equivalent to root access on the host. Refer
docker_1   |          to the 'Docker daemon attack surface' section in the documentation for
docker_1   |          more information: https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
docker_1   | WARNING: bridge-nf-call-iptables is disabled
docker_1   | WARNING: bridge-nf-call-ip6tables is disabled
dind_docker_1 exited with code 0
```

## Docker in Docker use cases?

Nah buat temen-temen yang masih binggung sebetulnya, buat apa sih Docker in Docker (DinD). Berikut adalah beberapa contoh kasus penggunaannya:

1. One potential use case for docker in docker is for the CI pipeline, where you need to build and push docker images to a container registry after a successful code build.
2. Docker daemon clusters espesialy using for docker swarm (alternative for docker-machine).
3. Sandboxed environments.
4. For experimental purposes on your local development workstation (docker development it's self).

## Run Docker in Docker container methods

Ada 3 cara untuk menggunakan Docker in Docker (DinD), yaitu

1. Run docker by mounting `docker.sock` (DooD Method)
2. Docker in Docker (DinD) method
3. Using Nestybox sysbox

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

