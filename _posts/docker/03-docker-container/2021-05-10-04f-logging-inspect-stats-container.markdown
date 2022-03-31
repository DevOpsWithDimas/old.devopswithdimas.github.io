---
layout: post
title: "Logging, Inspect, & Resource Usage Statistics Containers"
date: 2021-05-10T09:09:41+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Container
refs: 
- https://docs.docker.com/config/containers/logging/
- https://docs.docker.com/engine/reference/commandline/logs/
- https://docs.docker.com/engine/reference/commandline/stats/
- https://docs.docker.com/engine/reference/commandline/container_stats/
youtube: -Pk7bzvrDOY
comments: true
catalog_key: docker-container
image_path: /resources/posts/docker/06c-docker-logs-ps-command
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang 

1. View Logging a running / init failed Container
2. Resource Usage Statistic a running container
3. Inspecting a container, volume and network

Ok langsung aja, jadi pertama saya akan membahas dulu tentang system logging pada Docker. 

<!--more-->

## View Logging for a container 

Perintah `docker logs`, digunakan untuk menampilkan proses yang catat (logged) a running container. The information that is logged and the format of the log depends almost entirely on the container’s endpoint command. Untuk lebih jelasnya kita bisa check dokumentasi dengan perintah seperti berikut:

{% gist page.gist "04f-docker-logs-help.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 511ms.
➜ ~  docker logs -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker logs [OPTIONS] CONTAINER

Fetch the logs of a container

Options:
      --details        Show extra details provided to logs
  -f, --follow         Follow log output
      --since string   Show logs since timestamp (e.g.
                       2013-01-02T13:23:37Z) or relative (e.g. 42m for 42
                       minutes)
  -n, --tail string    Number of lines to show from the end of the logs
                       (default "all")
  -t, --timestamps     Show timestamps
      --until string   Show logs before a timestamp (e.g.
                       2013-01-02T13:23:37Z) or relative (e.g. 42m for 42
                       minutes)
```

Sebagai contoh, jika kita menjalankan perintah `docker run` tanpa menggunakan `-d` atau `--deatach` maka secara default akan muncul logs-nya tetapi jika menggunakan perintah seperti berikut:

{% highlight powershell %}
docker container run --name pg_failed_init -d postgres:12.3
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container run --name pg_failed_init -d postgres:12.3
ba2dde01ec94355e38e2f2d9e71695d0ec760c0e6150fa0ca1ad619800595c51

➜ ~  docker container ls
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

➜ ~  docker container ls -a
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS                      PORTS     NAMES
ba2dde01ec94   postgres:12.3   "docker-entrypoint.s…"   16 seconds ago   Exited (1) 16 seconds ago             pg_failed_init
```

Jadi containernya gak jalan, tandanya yaitu status = `Exited (1)` tapi kita belum tau kenapa gak jalannya ya khan?? untuk tau kenapa gak jalannya kita bisa menggunakan perintah seperti berikut

{% gist page.gist "04f-docker-logs-failed-init.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ ~  docker logs pg_failed_init
Error: Database is uninitialized and superuser password is not specified.
       You must specify POSTGRES_PASSWORD to a non-empty value for the
       superuser. For example, "-e POSTGRES_PASSWORD=password" on "docker run".

       You may also use "POSTGRES_HOST_AUTH_METHOD=trust" to allow all
       connections without a password. This is *not* recommended.

       See PostgreSQL documentation about "trust":
       https://www.postgresql.org/docs/current/auth-trust.html
```

Jadi katanya kita harus parssing environtment variable yaitu `POSTGRES_PASSWORD` dalam perintah `docker run`. Nah selain itu juga docker log ini berguna untuk memastikan/debuging suatu program sebagai contoh kasusnya jika kita menggunakan `nginx` yang memiliki reverse proxy atau load balancer, apakah proxy urlnya udah bener diarahkan ke url yang tepat.

## Resource Usage Statistic a running container

Dalam pengembagan suatu aplikasi, kita perlu memastikan berapa spesifikasi yang di perlukan untuk menjalankan program tersebut (System Requirement). Nah yang jadi pertanyaan bagaimana caranya untuk mengukurnya, sebenarnya ada banyak cara untuk mengukur Resource Usege tapi disini salah satunya dengan menggunakan `stats`. The `docker stats` command returns a live data stream for running containers. Berikut adalah dokumentasinya:

{% gist page.gist "04f-docker-stats-help.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

Try the new cross-platform PowerShell https://aka.ms/pscore6

Loading personal and system profiles took 511ms.

➜ ~  docker stats -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker stats [OPTIONS] [CONTAINER...]

Display a live stream of container(s) resource usage statistics

Options:
  -a, --all             Show all containers (default shows just running)
      --format string   Pretty-print images using a Go template
      --no-stream       Disable streaming stats and only pull the first result
      --no-trunc        Do not truncate output
```

Berikut adalah contoh penggunaanya:

{% gist page.gist "04f-docker-stats-all-running-container.bash" %}

Tpi sebelum itu, kita buat dulu contoh containernya seperti berikut:

{% highlight bash %}
docker container run --name pgdb_stats -e POSTGRES_PASSWORD=password -d postgres:12.3 && \
docker container run --name mydb_stats -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7 && \
docker container run --name nginx_stats -d nginx
{% endhighlight %}

Maka hasilnya seperti berikut:

```powershell
➜ ~  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED              STATUS              PORTS                 NAMES
63e16633c745   mysql:5.7       "docker-entrypoint.s…"   3 seconds ago        Up 2 seconds        3306/tcp, 33060/tcp   mydb_stats
f0c401198c53   nginx           "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp                nginx_stats
61446cbc0280   postgres:12.3   "docker-entrypoint.s…"   2 minutes ago        Up 2 minutes        5432/tcp              pgdb_stats

➜ ~  docker stats
CONTAINER ID   NAME          CPU %     MEM USAGE / LIMIT     MEM %     NET I/O       BLOCK I/O   PIDS
63e16633c745   mydb_stats    0.04%     203MiB / 3.842GiB     5.16%     726B / 0B     0B / 0B     27
f0c401198c53   nginx_stats   0.00%     2.578MiB / 3.842GiB   0.07%     796B / 0B     0B / 0B     2
61446cbc0280   pgdb_stats    0.00%     27.81MiB / 3.842GiB   0.71%     1.05kB / 0B   0B / 0B     7
```

Atau kita juga bisa menampilkan specific column dengan menggunakan `--format`, contohnya seperti berikut:

{% gist page.gist "04f-docker-stats-specific-columns.bash" %}

## Inspecting a container, volume and network

Docker inspect provides detailed information on constructs controlled by Docker. Untuk lebih jelasnya kita bisa lihat di dokumentasinya menggunakan perintah berikut:

{% gist page.gist "04f-docker-inspect-help.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~ ✗  docker inspect -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker inspect [OPTIONS] NAME|ID [NAME|ID...]

Return low-level information on Docker objects

Options:
  -f, --format string   Format the output using the given Go template
  -s, --size            Display total file sizes if the type is container
      --type string     Return JSON for specified type
```

Contoh penggunaanya seperti berikut:

{% gist page.gist "04f-docker-container-inspect.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container inspect nginx_stats
[
    {
        "Id": "f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c",
        "Created": "2021-05-10T01:44:10.387235Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 2610,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2021-05-10T01:44:10.5997106Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:62d49f9bab67f7c70ac3395855bf01389eb3175b374e621f6f191bf31b54cd5b",
        "ResolvConfPath": "/var/lib/docker/containers/f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c/hostname",
        "HostsPath": "/var/lib/docker/containers/f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c/hosts",
        "LogPath": "/var/lib/docker/containers/f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c/f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c-json.log",
        "Name": "/nginx_stats",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "host",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                30,
                120
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/af2b594f283b855dc65e27373103011a87bddb8ee05044608c82d0eeed792b7e-init/diff:/var/lib/docker/overlay2/1c9c306b556d5bcaad3654ad19de3c94cabb2667a701c2dbf6ab4b5dd4a9c29a/diff:/var/lib/docker/overlay2/9fffce36926858bbba83dee8999491fa8ba5e3812776a4aa26e0ab755ace97aa/diff:/var/lib/docker/overlay2/4a58a0b3ca8f93f4b2d25977f85616b252d276c760b64809f016e88f9a7f3eed/diff:/var/lib/docker/overlay2/f135847d92b3256b359ad7adfe6e9a2a47ae7e68344b32c0d4342061f64a773e/diff:/var/lib/docker/overlay2/acb9fb9d55e525d615d4b5ea5a34709fb39a5e793f894df9e65957e706c94156/diff:/var/lib/docker/overlay2/d2f959af8ffa281a4f42339b02b91173b45bcae47be70e098033508f03694d59/diff",
                "MergedDir": "/var/lib/docker/overlay2/af2b594f283b855dc65e27373103011a87bddb8ee05044608c82d0eeed792b7e/merged",
                "UpperDir": "/var/lib/docker/overlay2/af2b594f283b855dc65e27373103011a87bddb8ee05044608c82d0eeed792b7e/diff",
                "WorkDir": "/var/lib/docker/overlay2/af2b594f283b855dc65e27373103011a87bddb8ee05044608c82d0eeed792b7e/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "f0c401198c53",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.19.10",
                "NJS_VERSION=0.5.3",
                "PKG_RELEASE=1~buster"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Image": "nginx",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers \u003cdocker-maint@nginx.com\u003e"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "1ae3980f38a8496c6537fdd7693fc20f0f7e106f092281384d2a7982c687f3e9",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/1ae3980f38a8",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "551ecc2862bd35a3d795666f3b72b9b8ce43dacf6500f88a4535ce7e658c38bd",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.3",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:03",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "41ce99478851ad7cdd5876fc0337c34d0e661acdddfd0d04ce4fc4cdf9d9e87b",
                    "EndpointID": "551ecc2862bd35a3d795666f3b72b9b8ce43dacf6500f88a4535ce7e658c38bd",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:03",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

Nah selain container, kita juga bisa melihat informasi detail tentang network. Contohnya saya akan menampilkan informasi network dengan nama `brige` seperti berikut perintahnya:

{% gist page.gist "04f-docker-network-inspect.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "41ce99478851ad7cdd5876fc0337c34d0e661acdddfd0d04ce4fc4cdf9d9e87b",
        "Created": "2021-05-09T20:29:14.2928376Z",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {
            "61446cbc02808acc2aeb10e54f829d95f2a0bbd2f2943082731264b7dec5194b": {
                "Name": "pgdb_stats",
                "EndpointID": "2c7d9844cf0e2fd01c7b84e01381c0f1aa09f7bf02b1bad216125f9d15c8180a",
                "MacAddress": "02:42:ac:11:00:02",
                "IPv4Address": "172.17.0.2/16",
                "IPv6Address": ""
            },
            "63e16633c74567dcdaa515a487fae5b125f0bb63f9c6bf8eac1bc4955854f3d4": {
                "Name": "mydb_stats",
                "EndpointID": "671829f9a6286a15ff1fb31c063384af15b7ca91108f6300d71e892b5be67c8f",
                "MacAddress": "02:42:ac:11:00:04",
                "IPv4Address": "172.17.0.4/16",
                "IPv6Address": ""
            },
            "f0c401198c53de61baf8e6e3a5ac6e1901d0ade305cb8b6269152fddde6d5c7c": {
                "Name": "nginx_stats",
                "EndpointID": "551ecc2862bd35a3d795666f3b72b9b8ce43dacf6500f88a4535ce7e658c38bd",
                "MacAddress": "02:42:ac:11:00:03",
                "IPv4Address": "172.17.0.3/16",
                "IPv6Address": ""
            }
        },
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
```

Selain network kita juga bisa lihat volume, contohnya seperti berikut:

{% gist page.gist "04f-docker-volume-inspect.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume inspect 3b0aff9e8f40576d5867290f9d2c1571d9cfd7cc3ad5751809bb5cca10b31687
[
    {
        "CreatedAt": "2021-05-10T01:44:00Z",
        "Driver": "local",
        "Labels": null,
        "Mountpoint": "/var/lib/docker/volumes/3b0aff9e8f40576d5867290f9d2c1571d9cfd7cc3ad5751809bb5cca10b31687/_data",
        "Name": "3b0aff9e8f40576d5867290f9d2c1571d9cfd7cc3ad5751809bb5cca10b31687",
        "Options": null,
        "Scope": "local"
    }
]
```

## Cleanup

Setelah selesai, sekarang saatnya kita bersih-bersih dulu. berikut adalah perintahnya:

{% gist page.gist "04f-cleanup.bash" %}
