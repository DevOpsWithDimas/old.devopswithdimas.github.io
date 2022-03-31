---
layout: post
title: "Share data among containers"
date: 2021-06-05T20:53:07+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Volume
refs: 
- https://docs.docker.com/storage/volumes/
youtube: 
comments: true
catalog_key: docker-volume
image_path: /resources/posts/docker/06c-share-data
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang share volume diantaranya:

1. Isolate volume each container
2. Share data among containers
    1. Use volume
    2. Use bind mount
3. Cleanup

<!--more-->

## Isolate volume each container

Sepertinya kita ketahui ya, setiap container memiliki volume masing-masing (isolation) baik menjalankan image yang sama ataupun berbeda. Contohnya seperti berikut:

```powershell
➜ web  docker run `
>> -p 8080:80 `
>> --name webapp `
>> -d nginx

➜ web  docker exec -it webapp bash -c "rm -rf /usr/share/nginx/html/index.html"

➜ web  docker exec -it webapp bash -c "cat > /usr/share/nginx/html/index.html <<EOF
<html>
    <head><title>Belajar HTML</title></head>
    <body>
        <h3>Saya sedang belajar HTML</h3><p>ini adalah paragraf tambahan</p>
    </body>
</html>
EOF
"

➜ web  docker exec -it webapp curl localhost
<html>
        <head>
                <title>Belajar HTML</title>
        </head>
        <body>
                <h3>Saya sedang belajar HTML</h3>
                <p>ini adalah paragraf tambahan</p>
        </body>
</html>

➜ web  docker run `
>> -p 9090:80 `
>> --name webapp2 `
>> -d nginx

➜ web  docker exec -it webapp2 curl localhost
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

➜ web  docker container rm -f $(docker container ls -aq)
c58f515e6a27
e1e93eef5730
3262bb8de64d
```

Nah jika kita mau share data / volume, kita bisa menggunakan 2 cara yaitu share between among container and among machine. Yang pertama kita bahas dulu yang berbeda container dulu

## Share data among containers

Share data berbeda container ada 2 method yaitu share volume dan bind mount. Yang pertama kita bahas dulu share data volume. Jadi misalnya kita akan membuat container 2 `nginx` dan 1 buat local volume Berikut perintahnya:

For Bash script:

{% gist page.gist "06c-share-local-volume.bash" %}

For Powershell script:

{% gist page.gist "06c-share-local-volume.ps1" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ ~  docker volume create -d local public_html | `
>> docker run --name local_webapp -p 8080:80 -v public_html:/usr/share/nginx/html -d nginx | `
>> docker run --name local_webapp2 -p 8081:80 -v public_html:/usr/share/nginx/html -d nginx
5ad9b8b114c105808ea80a68788720d23833d4929f212dfc17ae543635429db4

➜ ~  docker container ls
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
5ad9b8b114c1   nginx     "/docker-entrypoint.…"   25 seconds ago   Up 23 seconds   0.0.0.0:8081->80/tcp, :::8081->80/tcp   local_webapp2
98def3c560f6   nginx     "/docker-entrypoint.…"   27 seconds ago   Up 25 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   local_webapp

➜ ~  docker container inspect $(docker container ls -f label="env=local" -q) -f '{% raw %}{{ .Name }} => {{json .Mounts}}{% endraw %}'

/local_webapp2 => [
   {
      "Type":"volume",
      "Name":"public_html",
      "Source":"/var/lib/docker/volumes/public_html/_data",
      "Destination":"/usr/share/nginx/html",
      "Driver":"local",
      "Mode":"z",
      "RW":true,
      "Propagation":""
   }
]
/local_webapp => [
   {
      "Type":"volume",
      "Name":"public_html",
      "Source":"/var/lib/docker/volumes/public_html/_data",
      "Destination":"/usr/share/nginx/html",
      "Driver":"local",
      "Mode":"z",
      "RW":true,
      "Propagation":""
   }
]
```

Sekarang kalo kita coba edit file `index.html` di salah satu container dengan menggunakan perintah berikut:

{% highlight docker %}
docker exec -it local_webapp bash -c "cat > /usr/share/nginx/html/index.html <<EOF
<html>
    <head><title>Belajar HTML</title></head>
    <body>
        <h3>Saya sedang belajar HTML</h3><p>ini adalah paragraf tambahan</p>
    </body>
</html>
EOF
"
{% endhighlight %}

Lalu coba lihat hasilnya:

```powershell
➜ ~  docker exec -it local_webapp bash -c "cat > /usr/share/nginx/html/index.html <<EOF
>> <html>
>>     <head><title>Belajar HTML</title></head>
>>     <body>
>>         <h3>Saya sedang belajar HTML</h3><p>ini adalah paragraf tambahan</p>
>>     </body>
>> </html>
>> EOF
>> "

➜ ~  docker exec -it local_webapp curl localhost
<html>
    <head><title>Belajar HTML</title></head>
    <body>
        <h3>Saya sedang belajar HTML</h3><p>ini adalah paragraf tambahan</p>
    </body>
</html>

➜ ~  docker exec -it local_webapp2 curl localhost
<html>
    <head><title>Belajar HTML</title></head>
    <body>
        <h3>Saya sedang belajar HTML</h3><p>ini adalah paragraf tambahan</p>
    </body>
</html>
```

Nah terlihat khan, disini kita sudah berhasil share data antara container. Sekarang kita bahas share data untuk bind mount, Untuk schenario ini kita menggunakan config pada materi sebelumnya yaitu web

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

Sekarang kita buat config lagi dalam folder `conf` dengan nama `httpd.conf` dengan isinya seperti berikut:

{% gist page.gist "06c-httpd.conf" %}

Kemudian kita buat container dengan image `nginx` dan `httpd` serta bind mount masing-masing configurasi seperti berikut:

For Bash script:

{% gist page.gist "06c-share-local-mount.bash" %}

For Powershell script:

{% gist page.gist "06c-share-local-mount.ps1" %}

Kalau kita coba maka hasilnya seperti berikut:

```powershell
➜ web  docker container run `
>> --label env=local `
>> --label type=bind `
>> --name local_mount_nginx `
>> --mount type=bind,source="$(pwd)"\html,destination=/var/www/html `
>> --mount type=bind,source="$(pwd)"\conf\default.conf,destination=/etc/nginx/conf.d/default.conf `
>> -p 9090:80 -d nginx | `
>> docker container run `
>> --label env=local `
>> --label type=bind `
>> --name local_mount_httpd `
>> --mount type=bind,source="$(pwd)"\html,destination=/var/www/html `
>> --mount type=bind,source="$(pwd)"\conf\httpd.conf,destination=/usr/local/apache2/conf/httpd.conf `
>> -p 9091:80 -d httpd
595b6c6cdd7d0e1d8b361413cd74160020a6eb95fdaee145f4267f0cefc9d1fb

➜ web ✗  docker container ls -f label="type=bind"
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                   NAMES
595b6c6cdd7d   httpd     "httpd-foreground"       27 seconds ago   Up 26 seconds   0.0.0.0:9091->80/tcp, :::9091->80/tcp   local_mount_httpd
8a4a7c42d8b7   nginx     "/docker-entrypoint.…"   27 seconds ago   Up 26 seconds   0.0.0.0:9090->80/tcp, :::9090->80/tcp   local_mount_nginx

➜ web  docker container inspect $(docker container ls -q -f label="type=bind") -f '{% raw %}{{ .Name }} => {{json .Mounts}}{% endraw %}'
/local_mount_httpd => [
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
      "Source":"C:\\Users\\dimasm93\\Workspaces\\youtube\\docker\\06-docker-volume\\web\\conf\\httpd.conf",
      "Destination":"/usr/local/apache2/conf/httpd.conf",
      "Mode":"",
      "RW":true,
      "Propagation":"rprivate"
   }
]
/local_mount_nginx => [
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


```

Sekarang klo kita coba browser dengan alamat [http://localhost:9090](http://localhost:9090) dan [http://localhost:9091](http://localhost:9091) maka hasilnya pasti sama seperti berikut:

![index.html]({{ page.image_path | prepend: site.baseurl }}/index-html.png)

## Cleanup

Nah seperti biasa, setelah kita mencoba kita bersihin sampahnya ya berikut perintahnya:

For Bash script:

{% gist page.gist "06c-cleanup.bash" %}

For Powershell script:

{% gist page.gist "06c-cleanup.ps1" %}