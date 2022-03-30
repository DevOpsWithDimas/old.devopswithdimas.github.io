---
layout: post
title: "Using NFS for share data in Compose"
date: 2021-08-15T18:06:06+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Compose
- Volume
refs: 
- https://docs.docker.com/storage/volumes/#create-a-service-which-creates-an-nfs-volume
- https://www.howtoforge.com/nfs-server-and-client-on-centos-7
- https://hub.docker.com/r/itsthenetwork/nfs-server-alpine/
youtube: zyenHnDoiPI
comments: true
catalog_key: docker-compose
image_path: /resources/posts/docker/09g-share-data-using-nfs-in-compose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang share data berbeda machine mengunakan [NFS (Network File System)](https://en.wikipedia.org/wiki/Network_File_System)

Nah jadi sekarang kita memerlukan NFS Server, sebagai contoh disini saya udah sediakan VM (Virtual Machine) yang udah ter-install CentOS 8 dan ssh-server. Sekarang yang perlu kita lakukan adalah install NFS Server di vm pada ip (`192.168.88.110`) dengan menggunakan perintah seperti berikut: 

{% gist page.gist "09h-install-nfs-server.bash" %}

Setelah kita install kita bisa check dengan perintah `nfsstat -S` maka outputnya seperti berikut:

```bash
[root@storage-nfs ~]# nfsstat -s
Server rpc stats:
calls      badcalls   badfmt     badauth    badclnt
0          0          0          0          0

[root@storage-nfs ~]# exportfs
## empty result
```

Setelah itu kita akan buat folder untuk menyimpan datanya kemudian kita export foldernya perintah berikut:

{% highlight bash %}
sudo mkdir -p /var/nfs-data/nginx-app && \
sudo chmod -R 777 /var/nfs-data/nginx-app/ && \
touch /var/nfs-data/nginx-app/.gitkeep
{% endhighlight %}

Kemudian kita edit file `/etc/exports` tambahkan config folder yang telah kita buat tadi seperti berikut:

{% highlight config %}
/var/nfs-data/nginx-app *(rw,fsid=0,async,no_subtree_check,no_auth_nlm,insecure,no_root_squash)
{% endhighlight %}

Setelah itu kita restart service `nfs-server` dengan perintah seperti berikut:

{% highlight bash %}
sudo systemctl restart nfs-server.service
{% endhighlight %}

Sekarang kita coba test dengan perintah `exportfs` maka hasilnya seperti berikut:

```bash
[root@storage-nfs ~]# exportfs
/var/nfs-data/nginx-app
                <world>
```

Ok sekarang kita bisa check dari client apakah NFS Server udah bisa di access dengan perintah seperti berikut

```bash
[root@docker-vm ~]# showmount -e 192.168.88.110
Export list for 192.168.88.110:
/var/nfs-data/nginx-app 192.168.88.0
```

Ok setup untuk NFS server sudah selesai, sekarang kita buat compose file untuk melakukan conneksi ke nfs server seperti berikut:

{% gist page.gist "09h-share-nfs.docker-compose.yaml" %}

Jika di jalankan maka hasilnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\volume\nfs\docker-compose.yaml -p share-nfs up
 -d
Creating network "share-nfs_default" with the default driver
Creating volume "share-nfs_nfs-server" with local driver
Creating share-nfs_nginx_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\volume\nfs\docker-compose.yaml -p share-nfs ps

      Name                     Command               State                Ports
---------------------------------------------------------------------------------------------
share-nfs_nginx_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp

➜ docker  curl localhost

StatusCode        : 200
StatusDescription : OK
Content           : <html>
                        <head>
                                <title>Volume from NFS Server</title>
                        </head>
                        <body><h3>it''s Works!</h3></body>
                    </html>

RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 111
                    Content-Type: text/html
                    Date: Sun, 15 Aug 2021 11:04:14 GMT
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length,
                    111], [Content-Type, text/html]...}
ParsedHtml        : System.__ComObject
RawContentLength  : 111
```