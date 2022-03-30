---
layout: post
title: "Angular - Proxy to backend"
date: 2021-07-11T21:10:26+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://angular.io/guide/build#proxying-to-a-backend-server
- https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
youtube: f7BHAKWQYCM
comments: true
catalog_key: study-cases-dockerfile
image_path: /resources/posts/docker/08i-angular-proxy
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
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

## Run reverse proxy from container

Setelah kita mencoba manual developmentnya, sekarang kita coba build menggunakan docker. Yang perlu kita siapkan adalah `default.conf` untuk melakukan proxy ke backend. Tetapi disini saya gak mau hard-code endpointnya seperti pada config sebelumnya yaitu menggunakan `proxy_pass http://localhost:8080/;` tapi disini kita mau menggunakan Environtment dalam nginxnya. Sebetulnya udah ada yang pernah bahas juga [disini](https://github.com/docker-library/docs/tree/master/nginx#using-environment-variables-in-nginx-configuration-new-in-119)

Sekarang kita buat template conf nya dulu seperti berikut:

{% gist page.gist "08i-nginx-template.conf" %}

Setelah itu kita modif / edit file `Dockerfile` seperti berikut:

{% gist page.gist "08i-dockerfile" %}

Setelah itu kita build docker image, dengan perintah seperti berikut:

{% highlight bash %}
docker build -t dimmaryanto93/docker-angular:0.0.1-SNAPSHOT .
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```powershell
➜ docker-angular  docker build -t dimmaryanto93/docker-angular:0.0.1-SNAPSHOT .
[+] Building 107.4s (16/16) FINISHED
 => [internal] load build definition from Dockerfile                                                       0.0s
 => => transferring dockerfile: 1.28kB                                                                     0.0s
 => [internal] load .dockerignore                                                                          0.0s
 => => transferring context: 34B                                                                           0.0s
 => [internal] load metadata for docker.io/library/node:14.15-alpine                                       4.8s
 => [internal] load metadata for docker.io/library/nginx:latest                                            0.0s
 => [auth] library/node:pull token for registry-1.docker.io                                                0.0s
 => [npm_install 1/5] FROM docker.io/library/node:14.15-alpine@sha256:5edad160011cc8cfb69d990e9ae1cb2681c  0.0s
 => [internal] load build context                                                                          0.0s
 => => transferring context: 4.20kB                                                                        0.0s
 => CACHED [stage-1 1/4] FROM docker.io/library/nginx:latest                                               0.0s
 => [stage-1 2/4] WORKDIR /var/www/html                                                                    0.0s
 => CACHED [npm_install 2/5] WORKDIR /var/www                                                              0.0s
 => [npm_install 3/5] COPY . .                                                                             0.0s
 => [npm_install 4/5] RUN npm install --prod --silent && npm install @angular-devkit/build-angular --sil  72.7s
 => [npm_install 5/5] RUN ./node_modules/@angular/cli/bin/ng build --aot --build-optimizer --configurati  29.4s
 => [stage-1 3/4] COPY --from=npm_install /var/www/dist/docker-angular .                                   0.1s
 => [stage-1 4/4] COPY .nginx/default.template.conf /etc/nginx/templates/default.conf.template             0.0s
 => exporting to image                                                                                     0.1s
 => => exporting layers                                                                                    0.1s
 => => writing image sha256:8cb61351f167b0f002842f25ebf7d3d1290a4075a0e80cf18a78c66d1881609f               0.0s
 => => naming to docker.io/dimmaryanto93/docker-angular:0.0.1-SNAPSHOT

➜ docker-angular  docker run --name angular-nginx-proxy `
>> -p 80:80 `
>> -e BACKEND_HOST=spring-db `
>> -e BACKEND_PORT=80 `
>> -e BACKEND_CONTEXT_PATH=/ `
>> --network backend `
>> -d dimmaryanto93/docker-angular:0.0.1-SNAPSHOT
1160ae87ea485d95c9f89b0134cd6623ffe558adb65e211cb19cdf9d1d3f2dc8

➜ docker-angular  docker container ls
CONTAINER ID   IMAGE                                                         COMMAND                  CREATED
       STATUS                             PORTS                                   NAMES
1160ae87ea48   dimmaryanto93/docker-angular:0.0.1-SNAPSHOT                   "/docker-entrypoint.…"   13 seconds
 ago   Up 12 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp       angular-nginx-proxy
22835ba3d9f9   dimmaryanto93/udemy-springboot-docker:2021.07.05.00-release   "java -Djava.securit…"   5 minutes
ago    Up 5 minutes (healthy)             0.0.0.0:8080->80/tcp, :::8080->80/tcp   spring-db
4ffaa6d947ff   postgres:12.6                                                 "docker-entrypoint.s…"   5 minutes
ago    Up 5 minutes                       5432/tcp                                postgresdb

➜ docker-angular  docker exec angular-nginx-proxy cat /etc/nginx/conf.d/default.conf
server {
    listen       80;
    server_name  localhost;

    location / {
      root   /var/www/html;
      index  index.html;
    }

    location /spring-boot/ {
      proxy_pass                      http://spring-db:80/;
      proxy_set_header Host           $host;
      proxy_set_header X-Real-IP      $remote_addr;
    }

}
```

Sekarang kalo kita coba access dari browser, menggunakan alamat [http://localhost](http://localhost:80) hasilnya akan sama seperti pada deploy di nginx. seperti berikut:

![angular-nginx-proxy]({{ page.image_path | prepend: site.baseurl }}/02-nginx-reverse-proxy.png)

## Cleanup

Seperti biasa setelah kita mencoba schenario studi kasus tersebut. sekarang kita bersih-bersih dulu ya berikut perintahnya:

For Bash script:

{% gist page.gist "08i-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08i-cleanup.ps1" %}