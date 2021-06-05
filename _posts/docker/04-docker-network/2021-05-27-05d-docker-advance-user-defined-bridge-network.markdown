---
layout: post
title: "Advanced user-defined bridge network"
date: 2021-05-27T22:04:45+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/network/bridge/
- https://docs.docker.com/engine/reference/commandline/network_create/
- https://docs.docker.com/engine/reference/commandline/network_connect/
- https://docs.docker.com/engine/reference/commandline/network_rm/
youtube: oEfLvIk1z9E
comments: true
image_path: /resources/posts/docker/05d-more-bridge
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya di materi sebelumnya kita udah membahas tentang user-defined bridge network, Sekarang kita akan membahas lebih dalam lagi diantaranya yang akan kita bahas yaitu

1. Multiple user-defined bridge network in same host
2. Specify advanced options
3. Cleanup

<!--more-->

Ok lansung aja kepembahasan yang pertama yaitu membuat multiple user-defined bridge network

## Multiple user-defined bridge network in same host

Nah sekarang kita akan membuat 2 network terlebih dahulu yaitu `sandbox` dan `dev` menggunakan `--driver=bridge` seperti berikut perintahnya:

For Bash script:

{% gist page.gist "05d-multiple-network-create.bash" %}

For Powershell script:

{% gist page.gist "05d-multiple-network-create.ps1" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network create -d bridge sandbox `
>> | `
>> docker network create -d bridge dev
3170206bb146eb340537ad515bd7419924e8b611b6c4bbc223a0fd02ae22a646

➜ ~  docker network ls -f 'driver=bridge'
NETWORK ID     NAME      DRIVER    SCOPE
bcb05da45c8b   bridge    bridge    local
a33ac6d22a6f   dev       bridge    local
ec309c10e0b0   sandbox   bridge    local

➜ ~  docker network inspect $(docker network ls -f 'driver=bridge' -q) -f '{% raw %}{{ .Name }} => {{json .IPAM }}{% endraw %}'
bridge => {"Driver":"default","Options":null,"Config":[{"Subnet":"172.17.0.0/16","Gateway":"172.17.0.1"}]}
dev => {"Driver":"default","Options":{},"Config":[{"Subnet":"172.19.0.0/16","Gateway":"172.19.0.1"}]}
sandbox => {"Driver":"default","Options":{},"Config":[{"Subnet":"172.18.0.0/16","Gateway":"172.18.0.1"}]}
```

Jika kita perhatikan setiap kali kita membuat network baru nilai dari `Gateway` akan mendapatkan IP Address secara unique sebagai default route untuk container yang akan di koneksikan ke network tersebut. Ok sekarang kita buat containernya dengan configurati seperti berikut:

```yaml
dev: 
    driver: bridge
    images: 
        - httpd
        - centos:7
    IPAM: DHCP
sanbox: 
    driver: bridge
    images:
        - httpd
        - centos:7
    IPAM: DHCP
```

Jadi berikut perintahnya:

For Bash script:

{% gist page.gist "05d-multiple-container-create.bash" %}

For Powershell script:

{% gist page.gist "05d-multiple-container-create.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker run --network dev --name dev_webapp -d httpd | `
>> docker run --network dev --name dev_bash -dit centos:7 bash | `
>> docker run --network sandbox --name sandbox_webapp -d httpd | `
>> docker run --network sandbox --name sandbox_bash -dit centos:7 bash
3cd72ba0fca401a32ed683663a06cc6f4c5439f998bf1cc41a26adcd7190e6ba

➜ ~  docker container ls
CONTAINER ID   IMAGE      COMMAND                  CREATED         STATUS         PORTS     NAMES
0bfebb6f4aa4   centos:7   "bash"                   6 seconds ago   Up 6 seconds             sandbox_bash
06c992649f43   httpd      "httpd-foreground"       7 seconds ago   Up 6 seconds   80/tcp    sandbox_webapp
dee401d4ba3a   centos:7   "bash"                   7 seconds ago   Up 7 seconds             dev_bash
2c432d1680e7   httpd      "httpd-foreground"       8 seconds ago   Up 7 seconds   80/tcp    dev_webapp

docker network inspect dev sandbox -f '{% raw %}{{ .Name }} => {{json .Containers }}{% endraw %}'
dev => {
   "2c432d1680e7ef0db2295705736966ce7b5fddae2ce5a299de3cf46e50264705":{
      "Name":"dev_webapp",
      "EndpointID":"c805e5c9b81d870b3e8d4bcc677552132716d8f7194fa1028453c60ca5582c15",
      "MacAddress":"02:42:ac:13:00:02",
      "IPv4Address":"172.19.0.2/16",
      "IPv6Address":""
   },
   "dee401d4ba3a76c2a0751c5be032c1ae2cb5e2443df8b23e8f80feffe1f890b9":{
      "Name":"dev_bash",
      "EndpointID":"0adb2f8134ab9356f5e640b45b7b8908da796a238aab794480eb57df77c3f786",
      "MacAddress":"02:42:ac:13:00:03",
      "IPv4Address":"172.19.0.3/16",
      "IPv6Address":""
   }
}
sandbox => {
   "06c992649f439d749a4d3f3bcf76b28f199820a9ed202c4453a31f295324aebd":{
      "Name":"sandbox_webapp",
      "EndpointID":"8a20ea5d8b8f7b8fcf3ce7b91e42611b2a7fd11f9f3f2527a062269b236d73bb",
      "MacAddress":"02:42:ac:12:00:02",
      "IPv4Address":"172.18.0.2/16",
      "IPv6Address":""
   },
   "0bfebb6f4aa423f0d73f0488773c4a5f72bed22d2ddd4ed194e255bae212e9a3":{
      "Name":"sandbox_bash",
      "EndpointID":"240133b17d5c4daf734d9d7f1ef9036be342b8b830d5ef330df76ca37b8332a6",
      "MacAddress":"02:42:ac:12:00:03",
      "IPv4Address":"172.18.0.3/16",
      "IPv6Address":""
   }
}
```

Ok sekarang kita coba schenario berikut:

```powershell
➜ ~  docker exec -it dev_bash bash
[root@dee401d4ba3a /]# ping -c 2 google.com
PING google.com (216.239.38.120) 56(84) bytes of data.
64 bytes from 216.239.38.120 (216.239.38.120): icmp_seq=1 ttl=37 time=22.0 ms
64 bytes from 216.239.38.120 (216.239.38.120): icmp_seq=2 ttl=37 time=21.3 ms
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 2023ms
rtt min/avg/max/mdev = 21.368/21.732/22.097/0.393 ms

[root@dee401d4ba3a /]# ping -c 2 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=37 time=19.9 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=37 time=19.4 ms
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 19.497/19.742/19.987/0.245 ms

[root@dee401d4ba3a /]# ping -c 2 dev_bash
PING dev_bash (172.19.0.3) 56(84) bytes of data.
64 bytes from dee401d4ba3a (172.19.0.3): icmp_seq=1 ttl=64 time=0.016 ms
64 bytes from dee401d4ba3a (172.19.0.3): icmp_seq=2 ttl=64 time=0.030 ms
--- dev_bash ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1059ms
rtt min/avg/max/mdev = 0.016/0.023/0.030/0.007 ms

[root@dee401d4ba3a /]# curl http://dev_webapp
<html><body><h1>It works!</h1></body></html>

[root@dee401d4ba3a /]# ping -c 2 sandbox_webapp
ping: sandbox_webapp: Name or service not known

[root@dee401d4ba3a /]# ping -c 2 172.18.0.2
PING 172.18.0.2 (172.18.0.2) 56(84) bytes of data.
--- 172.18.0.2 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1039ms
[root@dee401d4ba3a /]# exit

➜ ~  docker network connect sandbox dev_bash
➜ ~  docker container inspect dev_bash -f '{% raw %}{{json .NetworkSettings.Networks }}{% endraw %}'
{
   "dev":{
      "Aliases":[
         "dee401d4ba3a"
      ],
      "NetworkID":"a33ac6d22a6fe789407e48d9f132d399ae77bdd6491011281786baa166623a0b",
      "EndpointID":"0adb2f8134ab9356f5e640b45b7b8908da796a238aab794480eb57df77c3f786",
      "Gateway":"172.19.0.1",
      "IPAddress":"172.19.0.3",
      "MacAddress":"02:42:ac:13:00:03",
   },
   "sandbox":{
      "Aliases":[
         "dee401d4ba3a"
      ],
      "NetworkID":"ec309c10e0b07df3a5826dd87c9a52d5a4318b67a58d7cf34ce3676df8a690ab",
      "EndpointID":"fa5b9070bb8d259764d72cfffe97ee8d16b8adc2fbae16f5ca46cc432fe3d7e4",
      "Gateway":"172.18.0.1",
      "IPAddress":"172.18.0.4",
      "IPPrefixLen":16,
      "MacAddress":"02:42:ac:12:00:04",
   }
}

➜ ~  docker exec -it dev_bash bash
[root@dee401d4ba3a /]# ping -c 2 sandbox_webapp
PING sandbox_webapp (172.18.0.2) 56(84) bytes of data.
64 bytes from sandbox_webapp.sandbox (172.18.0.2): icmp_seq=1 ttl=64 time=0.078 ms
64 bytes from sandbox_webapp.sandbox (172.18.0.2): icmp_seq=2 ttl=64 time=0.036 ms
--- sandbox_webapp ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1046ms
rtt min/avg/max/mdev = 0.036/0.057/0.078/0.021 ms

[root@dee401d4ba3a /]# curl http://sandbox_webapp
<html><body><h1>It works!</h1></body></html>

[root@dee401d4ba3a /]# curl http://172.18.0.2
<html><body><h1>It works!</h1></body></html>

[root@dee401d4ba3a /]# exit
```

## Specify advanced options

When you create a network, Engine creates a non-overlapping subnetwork for the network by default. This subnetwork is not a subdivision of an existing network. It is purely for ip-addressing purposes. You can override this default and specify subnetwork values directly using the `--subnet` option. On a bridge network you can only create a single subnet:

```yaml
prod:
    driver: bridge
    images:
        - nginx
        - centos:7
    IPAM: 
        Gateway: "10.10.1.254"
        Subnet: "10.10.0.0/16"
        IP-Range: "10.10.1.0/24"
```

Berikut perintahnya, untuk Bash script:

{% gist page.gist "05d-bridge-specific-option-create.bash" %}

For Powershell script:

{% gist page.gist "05d-bridge-specific-option-create.ps1" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker network inspect prod -f '{% raw %}{{json .IPAM }}{% endraw %}'
{
   "Driver":"default",
   "Options":{
      
   },
   "Config":[
      {
         "Subnet":"10.10.0.0/16",
         "IPRange":"10.10.1.0/24",
         "Gateway":"10.10.1.254"
      }
   ]
}
```

Sekarang kita akan buat containernya, berikut perintahnya untuk Bash script:

{% gist page.gist "05d-container-specific-option-create.bash" %}

For Powershell script:

{% gist page.gist "05d-container-specific-option-create.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker run --name prod_bash --network prod -dit centos:7 bash | `
>> docker run --name prod_webapp --network prod -d nginx
f8666d0b0763c46c0df3579b62294656e2da820e10e7a50448f7fc7317d1f4a9

➜ ~  docker container ls -f 'network=prod'
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS     NAMES
f8666d0b0763   nginx      "/docker-entrypoint.…"   19 seconds ago   Up 18 seconds   80/tcp    prod_webapp
870151cb5b73   centos:7   "bash"                   20 seconds ago   Up 19 seconds             prod_bash

➜ ~  docker network inspect prod -f '{% raw %}{{ .Name }} => {{json .Containers}}{% endraw %}'
{
   "870151cb5b73aaaf07b5d7ca6d63197c92478495fc6f2d99e7c3b833e45284ff":{
      "Name":"prod_bash",
      "EndpointID":"acf5eb95d9c00b075b508060b9d5a946ff600f804a0d2cbd76320814bfc634e5",
      "MacAddress":"02:42:0a:0a:01:00",
      "IPv4Address":"10.10.1.0/16",
      "IPv6Address":""
   },
   "f8666d0b0763c46c0df3579b62294656e2da820e10e7a50448f7fc7317d1f4a9":{
      "Name":"prod_webapp",
      "EndpointID":"74876aa81905e5228fda952a948ca62a24de45618252f962ce40761610aea218",
      "MacAddress":"02:42:0a:0a:01:01",
      "IPv4Address":"10.10.1.1/16",
      "IPv6Address":""
   }
}

➜ ~  docker container inspect prod_webapp prod_bash -f `
'{% raw %}{{ .Name }} => Gateway: {{json .NetworkSettings.Networks.prod.Gateway}}, IPAddress: {{json .NetworkSettings.Networks.prod.IPAddress}}{% endraw %}'
/prod_webapp => Gateway: "10.10.1.254", IPAddress: "10.10.1.1"
/prod_bash => Gateway: "10.10.1.254", IPAddress: "10.10.1.0"

➜ ~  docker exec -it prod_bash bash
[root@870151cb5b73 /]# ping -c 2 google.com
PING google.com (216.239.38.120) 56(84) bytes of data.
64 bytes from 216.239.38.120 (216.239.38.120): icmp_seq=1 ttl=37 time=21.5 ms
64 bytes from 216.239.38.120 (216.239.38.120): icmp_seq=2 ttl=37 time=21.2 ms
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 21.221/21.387/21.554/0.221 ms 

[root@870151cb5b73 /]# ping -c 2 prod_webapp
PING prod_webapp (10.10.1.1) 56(84) bytes of data.
64 bytes from prod_webapp.prod (10.10.1.1): icmp_seq=1 ttl=64 time=0.044 ms
64 bytes from prod_webapp.prod (10.10.1.1): icmp_seq=2 ttl=64 time=0.040 ms
--- prod_webapp ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1005ms
rtt min/avg/max/mdev = 0.040/0.042/0.044/0.002 ms

[root@870151cb5b73 /]# curl http://prod_webapp
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
```

Selain membuat network dengan specific `Gateway`, `subnet`, dan lain-lain. Kita juga bisa membuat container dengan specific IPAddress. Berikut adalah perintahnya untuk Bash script:

{% gist page.gist "05d-container-specific-ip-address-create.bash" %}

For Powershell script:

{% gist page.gist "05d-container-specific-ip-address-create.ps1" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker run -dit --name prod_bash2 --network prod --ip 10.10.1.50 centos:7
62a4d1e13fb120aee436e78f60babef078b7c56a9d901cb4fe51a929629ee702

➜ ~  docker container ls -f 'network=prod'
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS     NAMES
62a4d1e13fb1   centos:7   "/bin/bash"              52 seconds ago   Up 52 seconds             prod_bash2
f8666d0b0763   nginx      "/docker-entrypoint.…"   18 minutes ago   Up 18 minutes   80/tcp    prod_webapp
870151cb5b73   centos:7   "bash"                   18 minutes ago   Up 18 minutes             prod_bash

➜ ~  docker container inspect prod_webapp prod_bash prod_bash2 -f `
>> '{% raw %}{{ .Name }} => Gateway: {{json .NetworkSettings.Networks.prod.Gateway}}, IPAddress: {{json .NetworkSettings.Networks.prod.IPAddress}}{% endraw %}'
/prod_webapp => Gateway: "10.10.1.254", IPAddress: "10.10.1.1"
/prod_bash => Gateway: "10.10.1.254", IPAddress: "10.10.1.0"
/prod_bash2 => Gateway: "10.10.1.254", IPAddress: "10.10.1.50"

➜ ~ docker exec -it prod_bash2 bash
[root@62a4d1e13fb1 /]# ping -c 2 google.com
PING google.com (216.239.38.120) 56(84) bytes of data.
64 bytes from 216.239.38.120 (216.239.38.120): icmp_seq=1 ttl=37 time=30.6 ms
64 bytes from 216.239.38.120 (216.239.38.120): icmp_seq=2 ttl=37 time=23.0 ms
--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 23.067/26.847/30.628/3.784 ms

[root@62a4d1e13fb1 /]# ping -c 2 prod_bash
PING prod_bash (10.10.1.0) 56(84) bytes of data.
64 bytes from prod_bash.prod (10.10.1.0): icmp_seq=1 ttl=64 time=0.042 ms
64 bytes from prod_bash.prod (10.10.1.0): icmp_seq=2 ttl=64 time=0.036 ms
--- prod_bash ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1074ms
rtt min/avg/max/mdev = 0.036/0.039/0.042/0.003 ms

[root@62a4d1e13fb1 /]# ping -c 2 prod_webapp
PING prod_webapp (10.10.1.1) 56(84) bytes of data.
64 bytes from prod_webapp.prod (10.10.1.1): icmp_seq=1 ttl=64 time=0.043 ms
64 bytes from prod_webapp.prod (10.10.1.1): icmp_seq=2 ttl=64 time=0.038 ms
--- prod_webapp ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1074ms
rtt min/avg/max/mdev = 0.038/0.040/0.043/0.006 ms

[root@62a4d1e13fb1 /]# curl http://prod_webapp
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
```

## Cleanup

Ok setelah kita mencoba, kita bersih-bersih dulu ya berikut perintahnya untuk Bash script:

{% gist page.gist "05d-cleanup.bash" %}

For Powershell script:

{% gist page.gist "05d-cleanup.ps1" %}