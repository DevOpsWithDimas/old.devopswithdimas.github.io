---
layout: post
title: "Using sshfs for share data in Compose"
date: 2021-08-15T17:09:07+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Volume
refs: 
- https://github.com/vieux/docker-volume-sshfs
- https://docs.docker.com/storage/volumes/#use-a-volume-driver
youtube: 
comments: true
image_path: /resources/posts/docker/09h-share-data-using-sshfs-in-compose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang share data between machine menggunakan docker plugin volume yaitu [sshfs](https://github.com/vieux/docker-volume-sshfs) di compose file.

Temen-temen masih inget khan terminologinya? aku lupa boleh baca-baca lagi [artikel ini]({% post_url docker/05-docker-volume/2021-06-08-06e-share-data-among-machines %}) Jadi kesimpulnya kita perlu ssh-server.

Disini saya sudah siapkan, VM (Virtual Machine) yang telah terinstall Centos 8 dan juga ssh-server dengan setting seperti berikut:

```yaml
servers:
    system:
        info:
            os-release: CentOS Linux 8
            hostname: storage-nfs.dimas-maryanto.com
            arch: x86-64
        cpu: 2 cores
        storage: 50Gb
        memory: 2GB
    network:
        ip4: 
            addr: 192.168.88.110
            port: 22/tcp
    cred:
        user: testing
        passwd: testing2021
```

Sekarang kita coba login menggunakan perintah ssh seperti berikut hasilnya:

```bash
➜ ~  ssh testing@192.168.88.110
testing@192.168.88.110''s password:
Activate the web console with: systemctl enable --now cockpit.socket

[testing@storage-nfs ~]$ pwd
/home/testing

[testing@storage-nfs ~]$ mkdir -p httpd-apps

# create sample file, for handle permission denied docker to access
[testing@storage-nfs ~]$ touch httpd-apps/.gitkeep

[testing@storage-nfs ~]$ ls
httpd-apps
```

Nah dengan seperti itu kita udah bisa login dan kita juga udah punya folder dengan nama `ubuntu-apps` sekarang kita buat compose file untuk mengkases folder tersebut melalui docker plugin sshfs, pertama kita perlu install dlu plugin volumenya dengan perintah seperti berikut:

{% gist page.gist "06e-install-plugin.bash" %}

Setelah itu berikut adalah file docker-compose.yamlnya:

{% gist page.gist "09g-share-sshfs.docker-compose.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ sshfs  docker-compose -f .\docker-compose.yaml up -d
Creating network "sshfs_default" with the default driver
Creating volume "sshfs_ssh-server" with vieux/sshfs driver
Creating sshfs_webapp_1 ... done

➜ sshfs  docker-compose -f .\docker-compose.yaml ps
     Name                 Command            State             Ports
------------------------------------------------------------------------------
sshfs_webapp_1   /docker-entrypoint.sh       Up      0.0.0.0:80->80/tcp,:::80-
                 ngin ...                            >80/tcp

➜ sshfs  docker-compose -f .\docker-compose.yaml exec webapp bash
root@f26f551a9072:/#

root@f26f551a9072:/# cd /usr/share/nginx/html/

root@f26f551a9072:/usr/share/nginx/html# ls -a
.  ..  .gitkeep

root@f26f551a9072:/usr/share/nginx/html# echo "it's works!" > index.html
root@f26f551a9072:/usr/share/nginx/html# ls
index.html
```

Sekarang kita check di ssh-server, maka hasilnya seperti berikut:

```bash
[testing@storage-nfs ~]$ ls -a httpd-apps/
.  ..  .gitkeep  index.html

[testing@storage-nfs ~]$ cat httpd-apps/index.html
it''s works!
```

