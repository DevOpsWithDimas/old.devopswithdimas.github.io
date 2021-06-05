---
layout: post
title: "Use Bind Mounts"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/storage/bind-mounts/
youtube: 
comments: true
image_path: /resources/posts/docker/06b-use-bind-volume
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di video kali ini kita akan membahas tentang binding volume di Docker, diantaranya yang akan kita bahas yaitu

1. What is bind volume?
2. Binding volume using `--volume` flag
3. Binding volume using `--mount` flag
4. Use a read-only bind mount

## What is bind volume

When you use a bind mount, a file or directory on the host machine is mounted into a container. The file or directory is referenced by its absolute path on the host machine. By contrast, when you use a volume, a new directory is created within Docker’s storage directory on the host machine, and Docker manages that directory’s contents.

![docker volume](https://docs.docker.com/storage/images/types-of-mounts-bind.png)

The file or directory does not need to exist on the Docker host already. It is created on demand if it does not yet exist. Bind mounts are very performant, but they rely on the host machine’s filesystem having a specific directory structure available. If you are developing new Docker applications, consider using named volumes instead.

## Binding volume using `--volume` flag

`-v` or `--volume`: Consists of three fields, separated by colon characters (`:`). The fields must be in the correct order, and the meaning of each field is not immediately obvious.

1. In the case of bind mounts, the first field is the path to the file or directory on the host machine.
2. The second field is the path where the file or directory is mounted in the container.
3. The third field is optional, and is a comma-separated list of options, such as `ro`, `z`, and `Z`. These options are discussed below.

Ok sekarang kita coba, nah pertama kita buat dulu folder dengan nama `html` untuk lokasinya terserah temen-temen dan buat file dengan nama `index.html` isinnya seperti berikut:

{% gist page.gist "06b-index.html" %}

Kemudian arahkan terminal di lokasi html tersebut, dan jalankan perintah berikut:

For Bash script:

{% gist page.gist "06b-bind-volume.bash" %}

For Powershell script:

currently not support, will throws error like `docker: invalid reference format.`. Recomend using `--mount`

Jika dijalankan maka hasilnya seperti berikut:

```bash
web $ ll
drwxrwxrwx 1 dimasm93 dimasm93 4096 Jun  5 14:00 html/

web $ docker container run --name webapp -p 8080:80 -v "$(pwd)"/html:/usr/share/nginx/html -d nginx
75c65a42aef72a91f05d0f28ab9a4383979c629121d0372dbb91d7e3808dc157

web $ docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS                                   NAMES
75c65a42aef7   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8080->80/tcp, :::8080->80/tcp   webapp

web $ docker volume ls
DRIVER    VOLUME NAME

web $ docker inspect webapp -f "{% raw %}{{json .Mounts}}{% endraw %}" | python -m json.tool
[
    {
        "Type": "bind",
        "Source": "/mnt/c/Users/dimasm93/Workspaces/youtube/docker/06-docker-volume/web/html",
        "Destination": "/usr/share/nginx/html",
        "Mode": "",
        "RW": true,
        "Propagation": "rprivate"
    }
]
```

Nah setelah kita buat mountnya, sekarang kita coba akses web-nya menggunakan browser dengan alamat [http://localhost:8080](http://localhost:8080). Hasilnya seperti berikut:

![nginx]({{ page.image_path | prepend: site.baseurl }}/nginx-index-html.png)

## Binding volume using `--mount` flag

In general, `--mount` is more explicit and verbose. The biggest difference is that the `-v` syntax combines all the options together in one field, while the `--mount` syntax separates them. `--mount`: Consists of multiple key-value pairs, separated by commas and each consisting of a `<key>=<value>` tuple. The `--mount` syntax is more verbose than `-v` or `--volume`, but the order of the keys is not significant, and the value of the flag is easier to understand.

1. The type of the mount, which can be `bind`, `volume`, or `tmpfs`. This topic discusses bind mounts, so the type is always `bind`.
2. The `source` of the mount. For bind mounts, this is the path to the file or directory on the Docker daemon host. May be specified as `source` or `src`.
3. The `destination` takes as its value the path where the file or directory is mounted in the container. May be specified as `destination`, `dst`, or `target`.
4. The `readonly` option, if present, causes the bind mount to be mounted into the container as read-only.
5. The `bind-propagation` option, if present, changes the bind propagation. May be one of `rprivate`, `private`, `rshared`, `shared`, `rslave`, `slave`.
6. The `--mount` flag does not support `z` or `Z` options for modifying selinux labels.

Ok sekarang kita coba, kita buat dulu file config untuk nginx dengan nama `default.conf` dalam folder `conf` isinya seperti berikut:

{% gist page.gist "06b-default.conf" %}

Jika kita lihat sekaran struktur directornya seperti berikut:

```powershell
➜ web  tree ..
Folder PATH listing
Volume serial number is 000000EF 5A1A:CA78
C:\USERS\DIMASM93\WORKSPACES\YOUTUBE\DOCKER\06-DOCKER-VOLUME
└───web
    ├───conf
    |    └──default.conf
    └───html
    |    └──index.html
```

For Bash script:

{% gist page.gist "06b-bind-mount.bash" %}

For Powershell script:

{% gist page.gist "06b-bind-mount.ps1" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ web  docker container run `
>> --name webapp_public `
>> --mount type=bind,source="$(pwd)"\html,destination=/var/www/html `
>> --mount type=bind,source="$(pwd)"\conf\default.conf,destination=/etc/nginx/conf.d/default.conf `
>> -p 9090:80 `
>> -d nginx
426356f8d566f1cc1e48e93db4be1a2d02fb0e35e6865ba253a24a8a56ad9556

➜ web  docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
426356f8d566   nginx     "/docker-entrypoint.…"   29 seconds ago   Up 29 seconds   0.0.0.0:9090->80/tcp, :::9090->80/tcp   webapp_public

➜ web  docker container inspect webapp_public -f '{% raw %}{{json .Mounts}}{% endraw %}'
[
   {
      "Type":"bind",
      "Source":"C:\\Users\\dimasm93\\Workspaces\\youtube\\docker\\06-docker-volume\\web\\html",
      "Destination":"/var/www/html",
      "Mode":"",
      "RW":true,
      "Propagation":"rprivate"
   },
   {
      "Type":"bind",
      "Source":"C:\\Users\\dimasm93\\Workspaces\\youtube\\docker\\06-docker-volume\\web\\conf\\default.conf",
      "Destination":"/etc/nginx/conf.d/default.conf",
      "Mode":"",
      "RW":true,
      "Propagation":"rprivate"
   }
]

➜ web  docker exec webapp_public ls /var/www/html
index.html

➜ web  docker exec webapp_public cat /etc/nginx/conf.d/default.conf
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    #charset koi8-r;
    access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /var/www/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /var/www/html;
    }

}
```

Jadi dengan begitu, kita sudah bisa meng-override config yang ada pada image `nginx` seperti serve location public html awalnya di `/usr/share/nginx/html` sekarnag kita pindah ke `/var/www/html`

## Use a read-only bind mount

For some development applications, the container needs to write into the bind mount, so changes are propagated back to the Docker host. At other times, the container only needs read access.

This example modifies the one above but mounts the directory as a read-only bind mount, by adding ro to the (empty by default) list of options, after the mount point within the container. Where multiple options are present, separate them by commas.

Ok sekarang kita coba buat containernya dengan perintah seperti berikut:

For Bash script:

{% gist page.gist "06b-bind-mount-readonly.bash" %}

For Powershell script:

{% gist page.gist "06b-bind-mount-readonly.ps1" %}

Jika kita coba jalankan maka hasilnya seperti berikut:

```powershell
➜ web  docker container run `
>> --name webapp_readonly `
>> --mount type=bind,source="$(pwd)"\html,destination=/var/www/html,readonly `
>> --mount type=bind,source="$(pwd)"\conf\default.conf,destination=/etc/nginx/conf.d/default.conf `
>> -p 9080:80 `
>> -d nginx

➜ web  docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
91f4b112377d   nginx     "/docker-entrypoint.…"   7 minutes ago    Up 7 minutes    0.0.0.0:9080->80/tcp, :::9080->80/tcp   webapp_readonly
426356f8d566   nginx     "/docker-entrypoint.…"   30 minutes ago   Up 30 minutes   0.0.0.0:9090->80/tcp, :::9090->80/tcp   webapp_public

➜ web  docker container inspect webapp_readonly -f '{% raw %}{{json .Mounts}}{% endraw %}'
[
   {
      "Type":"bind",
      "Source":"C:\\Users\\dimasm93\\Workspaces\\youtube\\docker\\06-docker-volume\\web\\conf\\default.conf",
      "Destination":"/etc/nginx/conf.d/default.conf",
      "Mode":"",
      "RW":true,
      "Propagation":"rprivate"
   },
   {
      "Type":"bind",
      "Source":"C:\\Users\\dimasm93\\Workspaces\\youtube\\docker\\06-docker-volume\\web\\html",
      "Destination":"/var/www/html",
      "Mode":"",
      "RW":false,
      "Propagation":"rprivate"
   }
]

➜ web  docker exec -it webapp_readonly bash -c "cat 'halo ini text baru' > /var/www/html/index.html"
bash: /var/www/html/index.html: Read-only file system
```

## Cleanup

Setelah kita mecoba beberapa secenario diatas, sekarang kita bersih-bersih dulu ya. berikut perintahnya:

{% gist page.gist "06b-cleanup.bash" %}