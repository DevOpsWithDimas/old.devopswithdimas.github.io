---
layout: post
title: "Basic Dockerfile - Exposing Ports"
date: 2021-06-20T12:15:43+07:00
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/engine/reference/builder/
youtube: ZHFE3nA6iKY
comments: true
image_path: /resources/posts/docker/07h-expose
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas tentang `Expose` Instruction pada Dockerfile, diantaranya yang akan kita bahas yaitu

1. Expose default port by sevice
2. Custom port
3. Multiple port in same image

## Expose default port

The `EXPOSE` instruction informs Docker that the container listens on the specified network ports at runtime. You can specify whether the port listens on `TCP` or `UDP`, and the default is `TCP` if the protocol is not specified.

{% highlight docker %}
EXPOSE <port> [<port>/<protocol>...]
{% endhighlight %}

The `EXPOSE` instruction does not actually publish the port. It functions as a type of documentation between the person who builds the image and the person who runs the container, about which ports are intended to be published. To actually publish the port when running the container, use the `-p` flag on `docker run` to publish and map one or more ports, or the `-P` flag to publish all exposed ports and map them to high-order ports.

By default, `EXPOSE` assumes `TCP`. You can also specify `UDP`:

{% highlight docker %}
EXPOSE 80/udp
{% endhighlight %}

To expose on both `TCP` and `UDP`, include two lines:

{% highlight docker %}
EXPOSE 80/tcp
EXPOSE 80/udp
{% endhighlight %}

Contoh penggunaanya, misalnya kita akan meng-expose port `80` dengan protocol `TCP` pada web-server yang telah kita buat di materi sebelumnya seperti berikut:

{% gist page.gist "07i-dockerfile-expose-default-port" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.0 .
[+] Building 49.5s (8/8) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/centos:7                                                        0.0s
 => CACHED [1/3] FROM docker.io/library/centos:7                                                                   0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 3.14kB                                                                                0.0s
 => [2/3] RUN yum install epel-release -y && yum install nginx -y && yum clean all                                49.1s
 => [3/3] COPY index.html /usr/share/nginx/html/index.html                                                         0.0s
 => exporting to image                                                                                             0.3s
 => => exporting layers                                                                                            0.3s
 => => writing image sha256:55fdc633367c3a0f79bea9f0c0f3f94dec1fb30c7ae89191ae8ec9d36b8f674e                       0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.0

➜ 07-dockerfile  docker image inspect dimmaryanto93/centos:1.0 -f '{% raw %}{{json .Config.ExposedPorts }}{% endraw %}'
{"80/tcp":{}}

➜ 07-dockerfile  docker run --name webapp -p 80:80 -d dimmaryanto93/centos:1.0
c62bc7a6e61e8abb0b56a3f4ac86b312c9d6ba8b13f5fb147ccafd21c0105207

➜ 07-dockerfile  curl localhost
StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta http-equiv="X-UA-Compatible" content="IE=edge">
                        <title>Belajar HTML</title>

                        <!--Import Google Icon Font--...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 3105
                    Content-Type: text/html
                    Date: Sun, 20 Jun 2021 04:28:24 GMT
                    ETag: "60bb3f04-c21"
                    Last-Modified: Sat, 05 Jun 2021...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 3105], [Content-Type,
                    text/html]...}
Images            : {}
InputFields       : {}
Links             : {@{innerHTML=Webapp Cources; innerText=Webapp Cources; outerHTML=<a class="brand-logo"
                    href="#">Webapp Cources</a>; outerText=Webapp Cources; tagName=A; class=brand-logo; href=#},
                    @{innerHTML=HTML; innerText=HTML; outerHTML=<a href="sass.html">HTML</a>; outerText=HTML;
                    tagName=A; href=sass.html}, @{innerHTML=CSS; innerText=CSS; outerHTML=<a
                    href="badges.html">CSS</a>; outerText=CSS; tagName=A; href=badges.html}, @{innerHTML=JavaScript;
                    innerText=JavaScript; outerHTML=<a href="collapsible.html">JavaScript</a>; outerText=JavaScript;
                    tagName=A; href=collapsible.html}...}
ParsedHtml        : System.__ComObject
RawContentLength  : 3105
```

Jika coba akses dari browser dengan alamat [localhost](http://localhost), maka hasilnya seperti berikut:

![hasilnya]({{ page.image_path | prepend: site.baseurl }}/index-html.png)

## Expose custom port

Atau selain itu kita juga bisa custom port, misalnya masih pada `Dockerfile` sebelumnya kita coba edit `Listen 80` pada `/etc/nginx/nginx.conf`

Seperti berikut:

{% gist page.gist "07i-dockerfile-expose-change-port" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.0 .
[+] Building 0.4s (9/9) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 537B                                                                               0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/centos:7                                                        0.0s
 => [1/4] FROM docker.io/library/centos:7                                                                          0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 32B                                                                                   0.0s
 => CACHED [2/4] RUN yum install epel-release -y && yum install nginx -y && yum clean all                          0.0s
 => CACHED [3/4] COPY index.html /usr/share/nginx/html/index.html                                                  0.0s
 => [4/4] RUN sed -i "s|80|8080|g" /etc/nginx/nginx.conf                                                           0.2s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.0s
 => => writing image sha256:5d6df3b2384a47e4f9d47d7306d2d7ab9e8534498239e2b51d49ffa2c1ed4675                       0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.0

 ➜ 07-dockerfile  docker image inspect dimmaryanto93/centos:1.0 -f '{% raw %}{{json .Config.ExposedPorts }}{% endraw %}'
{"8080/tcp":{}}

➜ 07-dockerfile  docker run --name webapp-changed-port -p 8080:8080 -d dimmaryanto93/centos:1.0
ce103ccf4446890e3de2e2f8b201d8fc7aff3139c12b893b2ca05551146c5c27

➜ 07-dockerfile ✗  curl http://localhost:8080
StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <html lang="en">

                    <head>
                        <meta charset="UTF-8">
                        <meta http-equiv="X-UA-Compatible" content="IE=edge">
                        <title>Belajar HTML</title>

                        <!--Import Google Icon Font--...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 3105
                    Content-Type: text/html
                    Date: Sun, 20 Jun 2021 04:42:25 GMT
                    ETag: "60bb3f04-c21"
                    Last-Modified: Sat, 05 Jun 2021...
Forms             : {}
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 3105], [Content-Type,
                    text/html]...}
Images            : {}
InputFields       : {}
Links             : {@{innerHTML=Webapp Cources; innerText=Webapp Cources; outerHTML=<a class="brand-logo"
                    href="#">Webapp Cources</a>; outerText=Webapp Cources; tagName=A; class=brand-logo; href=#},
                    @{innerHTML=HTML; innerText=HTML; outerHTML=<a href="sass.html">HTML</a>; outerText=HTML;
                    tagName=A; href=sass.html}, @{innerHTML=CSS; innerText=CSS; outerHTML=<a
                    href="badges.html">CSS</a>; outerText=CSS; tagName=A; href=badges.html}, @{innerHTML=JavaScript;
                    innerText=JavaScript; outerHTML=<a href="collapsible.html">JavaScript</a>; outerText=JavaScript;
                    tagName=A; href=collapsible.html}...}
ParsedHtml        : System.__ComObject
RawContentLength  : 3105
```

Jika coba akses dari browser dengan alamat [localhost:8080](http://localhost:8080), maka hasilnya seperti berikut:

![hasilnya]({{ page.image_path | prepend: site.baseurl }}/index-html-port-8080.png)

## Expose multiple ports

Atau kita juga bisa menggunakan multiple port, contohnya jika kita aktifkan module ssl pada nginx seperti berikut:

Buatlah file dengan nama `nginx-ssl.conf` seperti berikut:

{% gist page.gist "nginx-ssl.conf" %}

Kemudian edit file `Dockerfile` seperti berikut

{% gist page.gist "07i-dockerfile-expose-multi-ports" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ 07-dockerfile  docker build -t dimmaryanto93/centos:1.0 .
[+] Building 33.9s (10/10) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 32B                                                                                0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 35B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/centos:7                                                        0.0s
 => CACHED [1/5] FROM docker.io/library/centos:7                                                                   0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 738B                                                                                  0.0s
 => [2/5] RUN yum install epel-release -y && yum install nginx -y && yum clean all                                33.2s
 => [3/5] COPY index.html /usr/share/nginx/html/index.html                                                         0.0s
 => [4/5] COPY nginx-ssl.conf /etc/nginx/conf.d/nginx-ssl.conf;                                                    0.0s
 => [5/5] RUN sed -i "s|80|8080|g" /etc/nginx/nginx.conf                                                           0.2s
 => exporting to image                                                                                             0.3s
 => => exporting layers                                                                                            0.3s
 => => writing image sha256:7b6c1dd89bd8b7f97b37cb48e73ae14074ffe8655c2c5bc3c7bfd7772b224b19                       0.0s
 => => naming to docker.io/dimmaryanto93/centos:1.0

➜ 07-dockerfile  docker image inspect dimmaryanto93/centos:1.0 -f '{% raw %}{{json .Config.ExposedPorts }}{% endraw %}'
{"443/tcp":{},"8080/tcp":{}}
```

**NOTES: jika ingin menjalankan image tersebut, kita perlu siapkan ssl certificatenya dulu kemudian kita copy ke `/etc/pki/nginx/server.crt` dan `/etc/pki/nginx/private/server.key` menggunakan `openssl`**

## Cleanup

Seperti biasa, setelah kita mencobanya. kita bersih-bersih ya. berikut perintahnya:

For Bash script:

{% gist page.gist "07i-cleanup.bash" %}

For Powershell script:

{% gist page.gist "07i-cleanup.ps1" %}