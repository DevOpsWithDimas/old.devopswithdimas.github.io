---
layout: post
title: "Share volume among container and machine"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
youtube: 
comments: true
image_path: /resources/posts/docker/06d-share-volume-among-containers
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang share volume diantaranya:

1. Share volume among containers
2. Share volume among machine

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
```