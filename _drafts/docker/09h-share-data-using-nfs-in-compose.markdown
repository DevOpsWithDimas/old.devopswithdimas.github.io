---
layout: post
title: "Using NFS for share data in Compose"
lang: docker
categories:
- DevOps
- Docker
- Compose
- Volume
refs: 
- https://docs.docker.com/storage/volumes/#create-a-service-which-creates-an-nfs-volume
- https://www.howtoforge.com/nfs-server-and-client-on-centos-7
youtube: 
comments: true
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
sudo chmod -R 777 /var/nfs-data/nginx-app/
{% endhighlight %}

Kemudian kita edit file `/etc/exports` tambahkan config folder yang telah kita buat tadi seperti berikut:

{% highlight config %}
/var/nfs-data/nginx-app 192.168.88.0(rw,sync,no_root_squash,no_all_squash)
{% endhighlight %}

Setelah itu kita restart service `nfs-server` dengan perintah seperti berikut:

{% highlight bash %}
sudo systemctl restart nfs-server.service
{% endhighlight %}

Sekarang kita coba test dengan perintah `exportfs` maka hasilnya seperti berikut:

```bash
[root@storage-nfs ~]# exportfs
/var/nfs-data/nginx-app     192.168.88.0
```

Ok sekarang kita bisa check dari client apakah NFS Server udah bisa di access dengan perintah seperti berikut

```bash
[root@docker-vm ~]# showmount -e 192.168.88.110
Export list for 192.168.88.110:
/var/nfs-data/nginx-app 192.168.88.0
```

Ok setup untuk NFS server sudah selesai, sekarang kita buat compose file untuk melakukan conneksi ke nfs server seperti berikut:

{% gist page.gist "09h-share-nfs.docker-compose.yaml" %}