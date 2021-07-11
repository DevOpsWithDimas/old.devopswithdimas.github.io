---
layout: post
title: "Study Cases: Angular proxy to backend"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://angular.io/guide/build#proxying-to-a-backend-server
- https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
youtube: 
comments: true
image_path: /resources/posts/docker/08i-angular-proxy
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini akan membahas tentang Proxy To Backend dan Reverse Proxy pada nginx. Diantaranya adalah

1. Setup proxy for local development
2. Setup reverse proxy pada nginx
3. Run reverse proxy from container
4. Cleanup

Ok langsung ja kita bahas yang pertama

## Setup proxy for local development

Pada materi [sebelumnya]({% post_url docker/07-study-cases/2021-07-11-08h-build-angular-rest-api %}) kita telah membuat Angular project ini meng-consume Rest API dengan cara set Env host dan port. sebetulnya saya gak suka cara tersebut! saya lebih sering menggunakan Reverse proxy atau proxy to backend sesuai dengan rekomendasi dari article [angular ini](https://angular.io/guide/build#proxying-to-a-backend-server). ya let's do create proxy to backend:

1. Buat file `proxy.conf.json`, seperti berikut:
    {% gist page.gist "08i-proxy-conf.json" %}
2. Kita edit file `angular.json` dengan menambahkan config proxy tersebut pada `projects.architect.serve.configurations.development` seperti berikut:
    {% gist page.gist "08i-proxy-angular.json" %}
3. Tambahkan env variable `apiProxyPath: '/spring-boot'` pada `environments/environment.ts`, `environments/environment.prod.ts` dan `environments/environment.docker.ts` seperti berikut contohnya:
    {% gist page.gist "08i-proxy-environment.ts" %}
4. Update service `service/mahasiswa.service.ts` seperti berikut:
    {% gist page.gist "08i-proxy-mahasiswa-service.ts" %}

Sebelum kita me-running kita jalankan service spring-boot terlebih dahulu seperti berikut:

{% gist page.gist "08f-dotenv" %}

For Bash script: 

{% gist page.gist "08f-docker-run.bash" %}

For Powershell script:

{% gist page.gist "08f-docker-run.ps1" %}

Setelah itu coba jalankan dengan perintah seperti berikut:

{% highlight bash %}
ng serve --disable-host-check
{% endhighlight %}

Maka hasilnya seperti berikut:

```powershell
➜ docker-angular  ng serve --disable-host-check
Warning: Running a server with --disable-host-check is a security risk. See https://medium.com/webpack/webpack-d
ev-server-middleware-security-issues-1489d950874a for more information.
- Generating browser application bundles (phase: setup)...[HPM] Proxy created: /spring-boot  ->  http://localhos
t:8080
[HPM] Proxy rewrite rule created: "^/spring-boot" ~> ""
[HPM] Subscribed to http-proxy events:  [ 'error', 'close' ]
√ Browser application bundle generation complete.

Initial Chunk Files   | Names         |      Size
vendor.js             | vendor        |   2.78 MB
polyfills.js          | polyfills     | 508.82 kB
styles.css, styles.js | styles        | 381.01 kB
main.js               | main          |  23.81 kB
runtime.js            | runtime       |   6.58 kB

                      | Initial Total |   3.68 MB

Build at: 2021-07-11T12:32:47.989Z - Hash: d36451f7e7ab28b70847 - Time: 5046ms

** Angular Live Development Server is listening on localhost:4200, open your browser on http://localhost:4200/ *
*


√ Compiled successfully.
```

Sekarang kita bisa coba, dari browser dengan mengakses [http://localhost:4200](http://localhost:4200) seperti berikut:

![angular-proxy-to-backend]({{ page.image_path | prepend: site.baseurl }}/01-proxy-to-backend.png)


## Setup reverse proxy pada nginx

Untuk deployment ke nginx, pertama kita perlu build ulang sourcenya dan copy sourcenya ke root folder dari nginx tersebut, dengan perintah seperti berikut:

{% highlight bash %}
ng build --stats-json --source-map --optimization --common-chunk --build-optimizer --aot
{% endhighlight %}

Seperti berikut outputnya:

```powershell
➜ docker-angular  ng build --stats-json --source-map --optimization --common-chunk --build-optimizer --aot
√ Browser application bundle generation complete.
√ Copying assets complete.
√ Index html generation complete.

Initial Chunk Files               | Names         |      Size
main.abd551167fb9b2ff3fbc.js      | main          | 243.38 kB
polyfills.66a6ee27a5b4801e3d29.js | polyfills     |  36.03 kB
runtime.5694b417c6f4c412fb7a.js   | runtime       |   1.07 kB
styles.31d6cfe0d16ae931b73c.css   | styles        |   0 bytes

                                  | Initial Total | 280.48 kB

Build at: 2021-07-11T12:51:09.367Z - Hash: d6ee461f7275c011e9a8 - Time: 19014ms

## remove old build
➜ docker-angular  rm -Force C:\tools\nginx-1.20.1\html\*

## deploy new application
➜ docker-angular  cp -Recurse .\dist\docker-angular\* C:\tools\nginx-1.20.1\html\
```

Kalau kita jalankan, nginxnya ini tidak akan melakukan proxy to backend pada saat menggunakan development mode `ng serve`. Kita perlu setting reverse proxy pada `nginx.conf` seperti berikut:

{% gist page.gist "08i-nginx-reverse-proxy.conf" %}

Sekarang kita coba test dulu dengan perintah 

{% highlight bash %}
nginx -t
{% endhighlight %}

Hasilnya seperti berikut:

```powershell
➜ nginx-1.20.1  .\nginx.exe -t
nginx: the configuration file C:\tools\nginx-1.20.1/conf/nginx.conf syntax is ok
nginx: configuration file C:\tools\nginx-1.20.1/conf/nginx.conf test is successful
```

Setelah itu kita coba jalankan service nginx, dengan menggunakan perintah 

{% highlight bash %}
## stop service if running
nginx -s stop

## then start
nginx
{% endhighlight %}

Sekarang klo kita coba akses service, harusnya udah jalan proxynya seperti berikut:

![angular-nginx-proxy]({{ page.image_path | prepend: site.baseurl }}/02-nginx-reverse-proxy.png)