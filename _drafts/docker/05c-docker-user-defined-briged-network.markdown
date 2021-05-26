---
layout: post
title: "Use user-defined bridge networks"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/network/network-tutorial-standalone/#use-user-defined-bridge-networks
youtube: 
comments: true
image_path: /resources/posts/docker/05c-docker-user-defined-briged-network
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, sebelumnya kita udah mempelajari tentang default bridge network selanjutnya kita bahas tentang user-defined bridge network, Diantaranya meliputi:

1. Management Docker Network
2. Create multiple containers in same user-defined bridge network and how to connected each other
3. What the bridge network does to your containers?
4. Create multiple bridge network and containers, can a container connected each other between same and different network?

## Management Docker Network

Untuk me-manage Docker Network kita bisa menggunakan perintah `docker network COMMAND`. Untuk lebih detailnya kita bisa lihat dokumentasinya.

{% gist page.gist "05c-docker-network-help.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network --help

Usage:  docker network COMMAND

Manage networks

Commands:
  connect     Connect a container to a network
  create      Create a network
  disconnect  Disconnect a container from a network
  inspect     Display detailed information on one or more networks
  ls          List networks
  prune       Remove all unused networks
  rm          Remove one or more networks

Run 'docker network COMMAND --help' for more information on a command.
```

Untuk melihat daftar network kita bisa menggunakan perintah 

{% gist page.gist "05c-docker-netword-list.bash" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
a1dd8d92c317   bridge    bridge    local
9b4dac4a1f4a   host      host      local
de6461398e10   none      null      local
```

Untuk melihat detail dari suatu network, kita bisa menggunakan perintah seperti berikut:

{% gist page.gist "05c-docker-network-inspects-bash" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network inspect bridge host none
[
    {
        "Name": "bridge",
        "Id": "a1dd8d92c317716fefc26c1210a0e1cb280a0f695adeb7b7784effeeef0adec8",
        "Created": "2021-05-26T00:47:45.778658Z",
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
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    },
    {
        "Name": "host",
        "Id": "9b4dac4a1f4a86872ce14166d700a24d3a311a13b9b88df0e84adc76fcf06779",
        "Created": "2021-04-03T10:50:17.4124317Z",
        "Scope": "local",
        "Driver": "host",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": []
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    },
    {
        "Name": "none",
        "Id": "de6461398e1002dba5d8d934ec95e77f55de36f3c2dc08a0f982d81eede35e70",
        "Created": "2021-04-03T10:50:17.3972092Z",
        "Scope": "local",
        "Driver": "null",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": []
        },
        "Internal": false,
        "Attachable": false,
        "Ingress": false,
        "ConfigFrom": {
            "Network": ""
        },
        "ConfigOnly": false,
        "Containers": {},
        "Options": {},
        "Labels": {}
    }
]
```

Dari daftar network tersebut, yang dibuat oleh docker ketika kita meng-install Docker Engine. kita tidak bisa menghapus default atau pre-defined network.

Ok, sekarang untuk mencoba user-defined bridge network. Kita akan buat network dengan perintah seperti berikut:

For Bash script:

{% gist page.gist "05c-docker-network-create.bash" %}

For Powershell script:

{% gist page.gist "05c-docker-network-create.ps1" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network create backend_bridge `
>> --driver bridge
08ef47d6ea7a0011da3d85138e20e4a03f79bbf81b2bbc1433f8561136d4c672

➜ ~  docker network ls -f 'driver=bridge'
NETWORK ID     NAME             DRIVER    SCOPE
08ef47d6ea7a   backend_bridge   bridge    local
a1dd8d92c317   bridge           bridge    local

~  docker network inspect backend_bridge bridge -f '{% raw %}{{ .Name }} -> {{json .IPAM }}{% endraw %}'
backend_bridge -> {"Driver":"default","Options":{},"Config":[{"Subnet":"172.21.0.0/16","Gateway":"172.21.0.1"}]}
bridge -> {"Driver":"default","Options":null,"Config":[{"Subnet":"172.17.0.0/16","Gateway":"172.17.0.1"}]}
```

## How to connect containers each other in user-defined bridge network


For Bash script:

{% gist page.gist "05c-create-multi-container-backend-network.bash" %}

For Powershell script:

{% gist page.gist "05c-create-multi-container-backend-network.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker container run `
>> --name webapp `
>> -p 8080:80 `
>> --network backend_bridge `
>> -d nginx `
>> | `
>> docker container run `
>> --name postgresdb `
>> -e POSTGRES_PASSWORD=password `
>> -p 5432:5432 `
>> --network backend_bridge `
>> -d postgres:12.6 `
>> | `
>> docker container run `
>> --name centos7 `
>> --network backend_bridge `
>> -it `
>> -d centos:7 bash
c374148946e8c5c073e5c11e0c75c4457f99c7aeaa8bcfdb9572072f8a16032f

➜ ~  docker container ls
CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                                       NAMES
c374148946e8   centos:7        "bash"                   15 seconds ago   Up 14 seconds                                               centos7
a22ff7c66400   postgres:12.6   "docker-entrypoint.s…"   16 seconds ago   Up 14 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgresdb
8b756747082e   nginx           "/docker-entrypoint.…"   17 seconds ago   Up 16 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp       webapp

➜ ~  docker network inspect bridge backend_bridge --format '{% raw %}{{ .Name }}  ==> {{json .Containers}}{% endraw %}'
bridge  ==> {}
backend_bridge  ==> 
{
   "08d9210b39c8f78296a10ab5ea4c00d6a5d705ef689575057a5f3ed960a7a762":{
      "Name":"postgresdb",
      "EndpointID":"8b220c8947d5e6fc4ec5e353963b948a0b815b6c8827ecbfac2341f9139b5b89",
      "MacAddress":"02:42:ac:15:00:03",
      "IPv4Address":"172.21.0.3/16",
      "IPv6Address":""
   },
   "d9a000b91856d10c84de4fd24079241deb7249f152f7f858b9b8f6ca4d9141ac":{
      "Name":"webapp",
      "EndpointID":"411c23b907e75f54be1abe44e961653bc81dfbe9092d8932dfd75e2317ea89df",
      "MacAddress":"02:42:ac:15:00:04",
      "IPv4Address":"172.21.0.4/16",
      "IPv6Address":""
   },
   "e4f9e041acf0a89c44f1849e55d4b55bee86d628822b2c099470709b1163a4dd":{
      "Name":"centos7",
      "EndpointID":"7c345d7dc17c76dc1c8d4bf32ee05f6a2b8064d0568ed058c8ecc089454b2d5e",
      "MacAddress":"02:42:ac:15:00:02",
      "IPv4Address":"172.21.0.2/16",
      "IPv6Address":""
   }
}
```

Berbeda dengan default `bridge` network, pada user-defined bridge network jika suatu container mau komumikasi antara container maka kita bisa panggil dengan  **Internal IP-Address atau Container Name**