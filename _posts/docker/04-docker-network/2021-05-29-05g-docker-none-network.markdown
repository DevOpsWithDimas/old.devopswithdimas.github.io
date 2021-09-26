---
layout: post
title: "Disable networking for a container"
date: 2021-05-29T11:40:22+07:00
lang: docker
categories:
- DevOps
- Docker
- Network
refs: 
- https://docs.docker.com/network/none/
youtube: ZlHhezRG9DA
comments: true
catalog_key: docker-network
image_path: /resources/posts/docker/05c-docker-none-network
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

If you want to completely disable the networking stack on a container, you can use the `--network none` flag when starting the container. Within the container, only the loopback device is created. The following example illustrates this.

For Bash script:

{% gist page.gist "05g-docker-run-disable-network.bash" %}

For Powershell script:

{% gist page.gist "05c-docker-run-disable-network.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container run `
>> --name disable-net `
>> --network none `
>> -dit centos:7 bash
1b10be76aa9b838fcc5ea2a4e515c977175f77c2fbb734e80179cb5bbab469d2

➜ ~  docker container run `
>> --name disable-net2 `
>> --network none `
>> -dit ubuntu:21.04 bash

CONTAINER ID   IMAGE          COMMAND   CREATED          STATUS          PORTS     NAMES
206c94c473b6   ubuntu:21.04   "bash"    31 seconds ago   Up 30 seconds             disable-net2
1b10be76aa9b   centos:7       "bash"    2 minutes ago    Up 2 minutes              disable-net

➜ ~  docker container inspect disable-net -f '{% raw %}{{json .NetworkSettings.Networks.none }}{% endraw %}'
{
   "IPAMConfig":null,
   "Links":null,
   "Aliases":null,
   "NetworkID":"de6461398e1002dba5d8d934ec95e77f55de36f3c2dc08a0f982d81eede35e70",
   "EndpointID":"843c32cd2cf1411f83d56a1c31ddd05d8f37c187d706717234b2e252505cc510",
   "Gateway":"",
   "IPAddress":"",
   "IPPrefixLen":0,
   "IPv6Gateway":"",
   "GlobalIPv6Address":"",
   "GlobalIPv6PrefixLen":0,
   "MacAddress":"",
   "DriverOpts":null
}

➜ ~  docker exec -it disable-net bash
[root@1b10be76aa9b /]# ping 8.8.8.8
connect: Network is unreachable

[root@1b10be76aa9b /]# ping google.com
ping: google.com: Name or service not known

[root@1b10be76aa9b /]# ping disable-net2
ping: disable-net2: Name or service not known

[root@1b10be76aa9b /]# ping disable-net
ping: disable-net: Name or service not known

[root@1b10be76aa9b /]# ping -c 2 localhost
PING localhost (127.0.0.1) 56(84) bytes of data.
64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.012 ms
64 bytes from localhost (127.0.0.1): icmp_seq=2 ttl=64 time=0.016 ms

--- localhost ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1028ms
rtt min/avg/max/mdev = 0.012/0.014/0.016/0.002 ms
```

## Cleanup

Ok sekarang kita cleanup servicenya, berikut perintahnya:

For Bash script:

{% gist page.gist "05g-cleanup.bash" %}

For Powershell script:

{% gist page.gist "05g-cleanup.ps1" %}