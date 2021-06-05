---
layout: post
title: "Use host networking"
date: 2021-05-29T07:13:15+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/network/host/
youtube: 5kKAvSJZsvk
comments: true
image_path: /resources/posts/docker/05c-docker-host-network
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

If you use the `host` network mode for a container, that container’s network stack is not isolated from the Docker host (the container shares the host’s networking namespace), and the container does not get its own IP-address allocated. For instance, if you run a container which binds to port 80 and you use `host` networking, the container’s application is available on port 80 on the host’s IP address.

> Note: Given that the container does not have its own IP-address when using host mode networking, port-mapping does not take effect, and the `-p`, `--publish`, `-P`, and `--publish-all` option are ignored, producing a warning instead:
`WARNING: Published ports are discarded when using host network mode`

Host mode networking can be useful to optimize performance, and in situations where a container needs to handle a large range of ports, as it does not require network address translation (NAT), and no “userland-proxy” is created for each port.

The host networking driver only works on Linux hosts, and is not supported on Docker Desktop for Mac, Docker Desktop for Windows, or Docker EE for Windows Server.

You can also use a `host` network for a swarm service, by passing `--network host` to the `docker service create` command. In this case, control traffic (traffic related to managing the swarm and the service) is still sent across an overlay network, but the individual swarm service containers send data using the Docker daemon’s host network and ports. This creates some extra limitations. For instance, if a service container binds to port 80, only one service container can run on a given swarm node.

## Prerequisites

1. The host networking driver only works on Linux hosts, and is not supported on Docker Desktop for Mac, Docker Desktop for Windows, or Docker EE for Windows Server.

2. This procedure requires port 80 to be available on the Docker host. To make Nginx listen on a different port, see the documentation for the [nginx image](https://hub.docker.com/_/nginx/)

## Procedure

Untuk mencoba docker network dengan driver `host`, berikut adalah contoh membuat container `nginx` image seperti berikut:

{% gist page.gist "05e-docker-container-create.bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```bash
➜  ~ ifconfig
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:cc:9c:df:27  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.88.100  netmask 255.255.255.0  broadcast 192.168.88.255
        inet6 fe80::670f:5a7e:d0f6:e5c7  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:13:91:87  txqueuelen 1000  (Ethernet)
        RX packets 213  bytes 44371 (43.3 KiB)
        RX errors 0  dropped 6  overruns 0  frame 0
        TX packets 138  bytes 16020 (15.6 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

➜  ~ docker container run --name webapp --network host -d nginx
a7b5ec793fd4bc3df307b717069ce62d2afc0053a0263ac78686dfca7458c74c

➜  ~ docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS     NAMES
a7b5ec793fd4   nginx     "/docker-entrypoint.…"   15 seconds ago   Up 14 seconds             webapp

➜  ~ docker container inspect webapp -f '{% raw %}{{json .NetworkSettings }}{% endraw %}' | python -m json.tool
{
    "GlobalIPv6PrefixLen": 0,
    "HairpinMode": false,
    "Networks": {
        "host": {
            "Aliases": null,
            "DriverOpts": null,
            "EndpointID": "6241273f3ca305c3ddbf2452bb3453002f140bc634dd71761dd96e75e963378e",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAMConfig": null,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "Links": null,
            "MacAddress": "",
            "NetworkID": "931a9cbb585ae6d4b7f7bbe468860ecb84fd0f370e6b733f295762d3ffc72221"
        }
    },
    "SandboxID": "81e6c3a88d9c3915b6c14e050bd3dfea786e96390cd45913f8c5c3b99415c6d8",
    "SandboxKey": "/var/run/docker/netns/default"
}

➜  ~ curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

➜  ~ docker container run --name webapp2 --network host -d httpd

➜  ~ docker container ls -a
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS                          PORTS     NAMES
8fd78af4f1ed   httpd     "httpd-foreground"       About a minute ago   Exited (1) About a minute ago             webapp2
a7b5ec793fd4   nginx     "/docker-entrypoint.…"   5 minutes ago        Up 5 minutes                              webapp

➜  ~ docker logs webapp2
AH00558: httpd: Could not reliably determine the server\'s fully qualified domain name, using docker-vm.localnetwork. Set the 'ServerName' directive globally to suppress this message
(98)Address already in use: AH00072: make_sock: could not bind to address [::]:80
(98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:80
no listening sockets available, shutting down
AH00015: Unable to open logs

➜  ~ docker run --name mysql_db --network host -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7
7c5379e92ccaeb5af3b7848eadeb896cf2675cbd8dafa25a157374ea91cad398

➜  ~ docker network inspect host -f '{% raw %}{{json .Containers}}{% endraw %}' | python -m json.tool
{
    "7c5379e92ccaeb5af3b7848eadeb896cf2675cbd8dafa25a157374ea91cad398": {
        "EndpointID": "f7e7501a9dae6a509240a5bb68634b83947280307d02473ae537c5a8266a838a",
        "IPv4Address": "",
        "IPv6Address": "",
        "MacAddress": "",
        "Name": "mysql_db"
    },
    "a7b5ec793fd4bc3df307b717069ce62d2afc0053a0263ac78686dfca7458c74c": {
        "EndpointID": "6241273f3ca305c3ddbf2452bb3453002f140bc634dd71761dd96e75e963378e",
        "IPv4Address": "",
        "IPv6Address": "",
        "MacAddress": "",
        "Name": "webapp"
    }
}
```

## Cleanup

Ok setelah kita mencoba, sekarang kita akan cleanup. berikut adalah perintahnya:

{% gist page.gist "05e-cleanup.bash" %}