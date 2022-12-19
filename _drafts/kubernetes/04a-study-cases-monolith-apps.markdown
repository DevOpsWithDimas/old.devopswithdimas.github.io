---
layout: post
title: "Study Cases: Monolith apps (Laravel Web MVC)"
lang: k8s
authors:
- dimasm93
categories:
- DevOps
- Orchestration
- Kubernetes
- Pods
refs: 
- https://github.com/DevOpsWithDimas/kubernetes-laravel-monolith-apps
- https://dev.to/pgoodjohn/liveness-and-readiness-probes-with-laravel-5d65
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/04a-study-cases-monolith-apps
gist: dimMaryanto93/c8e8b75d52f1266a6bd7c8f5939c91f4
downloads: []
---

Hai semuanya, di materi study cases untuk Pod dan Container specification kita coba create, and build  aplikasi monolith dengan framework Laravel Web MVC (Model View Controller) dengan architecture seperti berikut:

![architecture mvc]({{ page.image_path | prepend: site.baseurl }}/monolith-architecture.png)

Mengapa kita membahas ini, seperti yang temen-temen ketahui hampir `85%` aplikasi yang ada masih menggunakan architecture tersebut, mungkin dari beberapa temen-temen pernah mengalami begitu aplikasi tersebut diakses secara public atau banyak orang mengakases aplikasi terasa lambat dalam mereseponse atau tiba-tiba mati (downtime) hal ini penyebabnya bisa macam-macam tapi salah satu penyebabnya adalah server tidak mampu menghandle request yang masuk sehingga menyebabkan performa dari aplikasi menurun. 

Sebetulnya ada banyak solusi dari masalah tersebut, misalnya 

1. Replikasi aplikasi
2. Cloning server (node) baik berbentuk virtual maupun physical

Kubernetes memprovide solusi terserbut dengan High Availablity, Self Healing, Auto scaling dan lain-lain. So jadi kita akan migrasikan aplikasi terserbut supaya bisa jalan di atas kubernetes dengan tujuan untuk memudahkan di maintanance secara operational, mudah di scale up and down serta meningkatkan zero down time. Adapun step by step yang akan kita lakukan adalah

1. Develop aplikasi
2. Containerize apps
3. Deploy to Kubernetes
    1. Running as a Pod
    2. Specify resource request and limit
    3. Using configmap and secret for connect to a database
    4. Using initContainer to migrate db
    5. Specify container probes (health check)

Ok tanpa berlama-lama yuk langsung aja ke pembahasan yang pertama.

<!--more-->

## Development aplikasi

Dalam mendevelop aplikasi, ada beberapa hal yang perlu di persiapakan yaitu Software Development Kit dan backing service seperti Database, source-code version control dan DevTools yaitu

1. PHP v8
2. Composer (package manager)
3. Git
4. MySQL Database
5. NodeJs & npm
6. Contaner Runtime (docker/containerd)

Jadi temen-temen perlu install software development kit tersebut, untuk cara installasinya sudah pernah saya bahas di kelas [DevOps - Docker untuk Pemula s/d Mahir]({% post_url docker/07-study-cases/2021-07-24-08k-build-laravel-apps %})

Setelah temen-temen menginstall semua Software Development Kit, kemudian yang kita butuhkan adalah source-code. Untuk source-code temen-temen bisa clone dari [github repo berikut](https://github.com/DevOpsWithDimas/kubernetes-laravel-monolith-apps) perintahnya seperti berikut:

{% highlight git %}
git clone https://github.com/DevOpsWithDimas/kubernetes-laravel-monolith-apps.git
{% endhighlight %}

Setelah di clone kita coba jalankan projectnya, pertama kita download dependencynya dulu dengan perintah berikut:

{% highlight bash %}
composer install && \
npm install

## copy configuration
php -r "file_exists('.env') || copy('.env.example', '.env');"

php artisan package:discover --ansi && \
php artisan key:generate --ansi && \
npm run build
{% endhighlight %}

Setelah semuanya terinstall, kita bisa coba running development mode menggunakan perintah berikut:

{% highlight bash %}
php artisan server
{% endhighlight %}

Maka outputnya seperti berikut:

```bash
examples/k8s-laravel-example » php artisan serve
Starting Laravel development server: http://127.0.0.1:8000
[Sat Dec 17 09:25:25 2022] PHP 8.2.0 Development Server (http://127.0.0.1:8000) started
```

Kalo kita coba akses di browser hasilnya seperti berikut:

![laravel dev-mode]({{ page.image_path | prepend: site.baseurl }}/01-laravel-dev-mode.png)

## Containerize apps

Setelah kita membuat project, tahap selanjutnya adalah deployment. Target untuk deploymentnya adalah menggunakan Orchestration Container system menggunakan Kubernetes, tpi sebelum kita deploy ke kubernetes kita (DevOps) harus menyiapkan dulu container image yang kita publish ke container registry. Untuk membuat container image dari source-code yang telah dibuat sebelumnya, kita akan menggunakan Docker.

Ada beberapa hal yang perlu kita siapkan, yaitu:

1. `Dockerfile`
2. docker compose
3. `.dockerignore`

Seperti yang telah kita bahas pada [artikel berikut]({% post_url docker/07-study-cases/2021-07-24-08k-build-laravel-apps %}) jadi kita review saja ya. Setelah itu langsung aja kita buat docker image menggunakan perintah berikut:

{% highlight bash %}
docker compose -f docker-compose.build.yaml build
{% endhighlight %}

Maka hasilnya seperti berikut:

```bash
examples/k8s-laravel-example [main] » docker compose  -f docker-compose.build.yaml build
[+] Building 102.4s (27/27) FINISHED                                                                                                                                        
 => [internal] load build definition from Dockerfile                                                                                                                   0.1s
 => => transferring dockerfile: 69B                                                                                                                                    0.1s
 => [internal] load .dockerignore                                                                                                                                      0.0s
 => => transferring context: 72B                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/node:14.15-alpine3.13                                                                                               4.0s
 => [internal] load metadata for docker.io/library/php:8.0-apache                                                                                                      4.0s
 => [auth] library/node:pull token for registry-1.docker.io                                                                                                            0.0s
 => [auth] library/php:pull token for registry-1.docker.io                                                                                                             0.0s
 => [php_laravel 1/7] FROM docker.io/library/php:8.0-apache@sha256:250cc0aa50713360672b12342b8477cf6adbf7c6fa6ffd0a59bf5c95c48299db                                    0.0s
 => [laramix_build 1/4] FROM docker.io/library/node:14.15-alpine3.13@sha256:03b86ea1f9071a99ee3de468659c9af95ca0bedbcd7d32bf31d61fa32c1a8ab3                           0.0s
 => [internal] load build context                                                                                                                                      1.4s
 => => transferring context: 958.82kB                                                                                                                                  1.3s
 => FROM docker.io/library/composer:latest                                                                                                                             4.0s
 => => resolve docker.io/library/composer:latest                                                                                                                       4.0s
 => CACHED [laramix_build 2/4] WORKDIR /var/www/php                                                                                                                    0.0s
 => [laramix_build 3/4] COPY . .                                                                                                                                       2.2s
 => [auth] library/composer:pull token for registry-1.docker.io                                                                                                        0.0s
 => [laramix_build 4/4] RUN npm install -q &&     npm run-script prod                                                                                                 64.3s
 => CACHED [php_laravel 2/7] RUN apt-get update && apt-get install -y   curl   git   libicu-dev   libpq-dev   libmcrypt-dev   mariadb-client   openssl   unzip   vim   0.0s
 => CACHED [php_laravel 3/7] RUN pecl install mcrypt-1.0.4 &&   docker-php-ext-install fileinfo exif pcntl bcmath gd mysqli pdo_mysql &&   docker-php-ext-enable mcry  0.0s
 => CACHED [php_laravel 4/7] COPY --from=composer /usr/bin/composer /usr/bin/composer                                                                                  0.0s
 => CACHED [php_laravel 5/7] WORKDIR /var/www/php                                                                                                                      0.0s
 => CACHED [php_laravel 6/7] COPY .docker/000-default.apache.conf /etc/apache2/sites-enabled/000-default.conf                                                          0.0s
 => CACHED [php_laravel 7/7] COPY .docker/apache2-foreground .docker/apache2-foreground                                                                                0.0s
 => [executeable 1/6] COPY . .                                                                                                                                         1.9s
 => [executeable 2/6] COPY --from=laramix_build /var/www/php/public/css public/css                                                                                     0.0s
 => [executeable 3/6] COPY --from=laramix_build /var/www/php/public/fonts public/fonts                                                                                 0.0s
 => [executeable 4/6] COPY --from=laramix_build /var/www/php/public/js public/js                                                                                       0.0s
 => [executeable 5/6] RUN mkdir -p public/storage &&     chmod -R 777 storage/* &&     chmod -R 777 public/storage &&     chmod -R 777 .docker/*                       0.3s
 => [executeable 6/6] RUN php -r "file_exists('.env') || copy('.env.example', '.env');" &&     composer install --no-interaction --optimize-autoloader --no-dev &&    28.9s
 => exporting to image                                                                                                                                                 0.9s
 => => exporting layers                                                                                                                                                0.9s
 => => writing image sha256:1a124c8ae3c613c35b7e208dc3f3f1ccc86ca7378d6a0c26dd2c9d9ca079207b                                                                           0.0s
 => => naming to docker.io/dimmaryanto93/kubernetes-laravel-monolith-apps:v1                                                                                           0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them
```

Sekarang kita bisa coba jalankan dulu single container dengan menggunakan docker, berikut perintahnya:

{% highlight bash %}
docker compose -f docker-compose.build.yaml up -d
{% endhighlight %}

Kemudian, coba check di browser jika sudah running maka hasilnya sama seperti sebelumnya. Next step adalah coba kita push docker imagenya ke Docker HUB (docker registry) coba jalankan perintah berikut:

{% highlight bash %}
docker compose -f docker-compose.build.yaml push laravel
{% endhighlight %}

Jika sudah diexecute temen-temen bisa check di Docker HUB (docker registry)

## Deploy to Kubernetes Cluster

Setelah container image sudah di-build dan di-publish ke container registry, tahap selanjutnya kita coba deploy container tersebut ke Kubernetes cluster. Tetapi kita akan siapkan dulu kubernetes clusternya dengan perintah seperti berikut:

{% highlight bash %}
minikube start -p laravel-monolith \
--insecure-registry=192.168.88.50:8086 \
--memory 2G \
--cpus 2 \
--nodes 2

minikube profile laravel-monolith

minikube addons enable registry-creds && \
minikube addons configure registry-creds
{% endhighlight %}

Nah sambil nungguin cluster kubernetes di-provision oleh minikube, kita akan buat kuberentes resourcenya dulu untuk deploy laravel seperti berikut:

Buat file `pod-laravel.yaml` dalam folder `.kubernetes` seperti berikut:

{% gist page.gist "04a-pod-laravel-monolith.yaml" %}

Dan untuk expose ke networknya kita akan menggunakan **NodePort** dengan buat file baru namanya `service-laravel.yaml` dalam folder `.kubernetes` seperti berikut:

{% gist page.gist "04a-service-laravel-monolith.yaml" %}

Sekarang kita coba execute menggunakan perintah berikut:

{% highlight bash %}
kubectl apply -f .kubernetes
{% endhighlight %}

Jika kita jalankan pada kubernetes clusternya seperti berikut hasilnya:

```bash
examples/k8s-laravel-example [main●] » kubectl apply -f .kubernetes 
pod/laravel-apps created
service/laravel-apps created

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS              RESTARTS   AGE
laravel-apps   0/1     ContainerCreating   0          10s

examples/k8s-laravel-example [main●] » kubectl get service
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
kubernetes     ClusterIP   10.96.0.1       <none>        443/TCP          7m9s
laravel-apps   NodePort    10.103.147.20   <none>        8000:30865/TCP   2m30s

examples/k8s-laravel-example [main●] » kubectl cluster-info
Kubernetes control plane is running at https://192.168.64.9:8443
CoreDNS is running at https://192.168.64.9:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

examples/k8s-laravel-example [main●] » curl 192.168.64.9:30865 -v
*   Trying 192.168.64.9:30865...
* Connected to 192.168.64.9 (192.168.64.9) port 30865 (#0)
> GET / HTTP/1.1
> Host: 192.168.64.9:30865
> User-Agent: curl/7.85.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Date: Sun, 18 Dec 2022 08:44:48 GMT
< Server: Apache/2.4.54 (Debian)
< X-Powered-By: PHP/8.0.26
< Cache-Control: no-cache, private
< Set-Cookie: XSRF-TOKEN=eyJpdiI6ImZQSkowaGlDSi9FSE9QSkMxazNoTFE9PSIsInZhbHVlIjoiVjdMQitVdVFCL2V4d2xHWERxTEt6RkI2TlI3YlpIUmxKTEJyeXRTdFl1Nm14UGFrZzBaZXU1U0Urbm4welhGSUlIYXhRY2cwUGhzSFRUV1cwbS85ZkUwdGVxU0NQRDVZZC9EaE01eVphQkZDM0FLbjVkaGhhbG9Ba2NpT20vc20iLCJtYWMiOiI0Nzc0Y2M2YzhhZDFlNWVkNDllNGRiZDIzODVlNTE3NGIxZTBjMzFjZDQ3ODcwMjBlZjliYWU2ZjI4YTc4YmNhIiwidGFnIjoiIn0%3D; expires=Sun, 18-Dec-2022 10:44:49 GMT; Max-Age=7200; path=/; samesite=lax
< Set-Cookie: udemy_kubernetes_pemula_sd_mahir_session=eyJpdiI6ImlxUERmNDBzTHlsRmpzSG9yZGRKdVE9PSIsInZhbHVlIjoiN1ZlRFpHaXJkWm9yTEphcXdyVFdEbnVOd25PMlhBdkI5cG1La3VhenpjTDhUM05udzRUWGh6SEhJdmpYTC9qeFd1Smt4SWx6cFlTSDQ0SVpnWHBBZno0TnFBSnZjY3NZRno1K3RyQmlnL0ZiN3lETWpPL2l3emtOdjd6eU5kOWIiLCJtYWMiOiI0YjkyZGM1NTMzOWM3MGMwY2Y5NmIxYThjNmM3ZjQ1YmViNWY2NDUzOWZhYjkxNmE1ODc1ZDBlYjU1MjBmZThkIiwidGFnIjoiIn0%3D; expires=Sun, 18-Dec-2022 10:44:49 GMT; Max-Age=7200; path=/; httponly; samesite=lax
< Vary: Accept-Encoding
< Transfer-Encoding: chunked
< Content-Type: text/html; charset=UTF-8
```

## Specify resources request and limit

Seperti yang temen-temen ketahui, jika kita tidak menentukan resource request dan limit maka by default container akan menggunakan seluruh resource (hardware) maka dari itu kita harus specify resource request dan limit.

Tahap pertama kita perlu aktifkan dulu metric servernya dengan menggunakan perintah berikut:

{% highlight bash %}
minikube addons enable metrics-server
{% endhighlight %}

Jika pod `metrics-server` sudah aktif seperti berikut:

```bash
examples/k8s-laravel-example [main] » kubectl get deploy/metrics-server -n kube-system
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
metrics-server   0/1     1            0           83s

examples/k8s-laravel-example [main] » kubectl top node
NAME                   CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
laravel-monolith       611m         30%    1481Mi          75%       
laravel-monolith-m02   363m         18%    977Mi           49%
```

Nah sekarang, saatnya temen-temen menentukan berapa resource request dan limit dari Aplikasi yang telah kita buat sebelumnya yaitu Laravel Web MVC. Pada resource request dan limit ada beberapa parameter yaitu `cpus`, `momory` dan `I/O` yang kita bisa set ke container tersebut. Menentukan besaran suatu resource yang digunakan pada aplikasi tidak bisa sembarangan harus menemukan titik keseimbangan jadi jangan teralu besar karena nantinya akan boros dan juga jangan terlalu kecil karena prosesnya akan di kill secara paksa. 

Karena teknology yang kita gunakan adalah menggunakan PHP, yang secara termininology menggunakan resource ketika di gunakan dan di destroy ketika sudah selesai jadi untuk resource request kita tidak membutuhkan resource yang besar sebagai contoh `cpu = 100m` dan `memory = 500MB` sedangkan untuk limitnya kita bisa set di `cpu = 1500m` dan `memory = 1G`

Maka kita bisa modifikasi kubernetes `pod.yaml` resourcenya, menjadi seperti berikut:

{% gist page.gist "04a-pod-resource-request-and-limit.yaml" %}

Jika kita coba jalankan menggunakan perintah berikut:

{% highlight bash %}
kubectl apply -f .kubernetes
{% endhighlight %}

Hasilnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » kubectl apply -f .kubernetes 
pod/laravel-apps created
service/laravel-apps created

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS    RESTARTS   AGE
laravel-apps   1/1     Running   0          14s

examples/k8s-laravel-example [main●] » kubectl describe pod/laravel-apps
Name:             laravel-apps
Namespace:        default
Priority:         0
Service Account:  default
Node:             laravel-monolith-m02/192.168.64.10
Start Time:       Sun, 18 Dec 2022 17:57:45 +0700
Labels:           app=laravel
Annotations:      <none>
Status:           Running
IP:               10.244.1.7
IPs:
  IP:  10.244.1.7
Containers:
  laravel:
    Image:          repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v1
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Sun, 18 Dec 2022 17:57:47 +0700
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     1500m
      memory:  1000Mi
    Requests:
      cpu:     100m
      memory:  500Mi
    Environment:
      APP_URL:  

examples/k8s-laravel-example [main●] » kubectl top pod laravel-apps
NAME           CPU(cores)   MEMORY(bytes)   
laravel-apps   35m          9Mi
```

## Using configmap and secret for connect to a database

Seperti yang temen-temen ketahui, `configmap` dan `secret` adalah suatu object yang di sediakan oleh kubernetes untuk menyimpan konfigurasi berupa key-value pair.

Dalam aplikasi Laravel Web MVC yang telah kita buat tersebut menggunakan suatu database MySQL, jadi kita akan mengkomunikasikan antara Laravel Web dengan Database MySQL menggunakan konfigurasi yang di simpan pada object `configmap` dan `secret` tahap pertama kita akan buat dulu pod untuk database mysqlnya.

Nah untuk membuatnya kita buat file baru dengan nama `config.yaml` seperti berikut:

{% gist page.gist "04a-configmap-and-secret.yaml" %}

Kemudian kita buat file baru lagi dengan nama `pod-mysql.yaml` seperti berikut:

{% gist page.gist "04a-pod-mysql.yaml" %}

dan yang terakhir buat file baru lagi dengan nama `service-mysql.yaml` seperti berikut:

{% gist page.gist "04a-service-mysql.yaml" %}

Sekarang kita jalankan dengan perintah berikut:

{% highlight bash %}
kubectl apply -f .kubernetes
{% endhighlight %}

Jika kita jalankan maka outputnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » kubectl apply -f .kubernetes
configmap/mysql-config created
secret/mysql-secret created
pod/laravel-apps created
pod/mysql-db created
service/laravel-apps created
service/mysql-db created

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS    RESTARTS   AGE
laravel-apps   1/1     Running   0          17s
mysql-db       1/1     Running   0          17s

examples/k8s-laravel-example [main●] » kubectl exec -it pod/mysql-db -- mysql -u
 root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.31 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| mahasiswa_db       |
+--------------------+
5 rows in set (0.01 sec)
```

Ok nah jika sudah bisa connect dari `mysql` client sekarang kita coba komunikasi aplikasi Laravel Web dengan Database, kita coba rubah konfigurasi pod seperti berikut:

{% gist page.gist "04a-pod-laravel-connect-db.yaml" %}

kemudian coba jalankan dengan perintah berikut:

{% highlight bash %}
kubectl apply -f .kubernetes
{% endhighlight %}

Jika dijalankan outputnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » kubectl apply -f .kubernetes                     
configmap/mysql-config unchanged
secret/mysql-secret configured
pod/laravel-apps created
pod/mysql-db unchanged
service/laravel-apps unchanged
service/mysql-db unchanged
```

Kemudian kita coba jalankan database migrasionnya dengan menggunakan perintah berikut:

{% highlight bash %}
kubectl exec -it pod/laravel-apps -- php artisan migrate
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » kubectl exec -it pod/laravel-apps -- php artisan migrate
**************************************
*     Application In Production!     *
**************************************

 Do you really wish to run this command? (yes/no) [no]:
 > y

Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (123.39ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (137.38ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (112.75ms)
Migrating: 2021_08_09_164144_create_mahasiswa_table
Migrated:  2021_08_09_164144_create_mahasiswa_table (162.61ms)
```

Dan sekarang kita bisa lihat hasilnya di alamat [http://cluster-ip:node-port/db](http://192.168.64.10:30225/db) seperti berikut:

![laravel-db]({{ page.image_path | prepend: site.baseurl }}/02-laravel-k8s-db.png)

## Using initContainer to migrate db

Seperti yang temen-temen ketahui, `initContainer` biasanya digunakan untuk menjalankan container yang sifatnya run to completion (jika sudah selesai prosesnya pasti di terminate) contoh imlementasinya sendiri adalah memberikan permission pada folder/file tertentu, me-migrasi database dan lain-lain. 

Nah karena dari section sebelumnnya kita perlu menjalankan database migrastion secara manual, kita akan jalankan database migrasion secara automatis ketika pod startup dengan menggunakan iniContainer. Tetapi ada beberapa perubahan yang perlu kita lakukan.

Pertama kita buat dulu script entrypoint untuk menjalankan database migration, buat file baru dengan namma `migrate-db-entrypoint` dan simpan dalam folder `.docker` seperti berikut:

{% gist page.gist "04a-init-db-entrypoint" %}

Setelah itu kita juga update file `Dockerfile` untuk menginclude script entrypoint tersebut ke docker imagenya seperti berikut:

{% highlight Dockerfile %}
COPY .docker/migrate-db-entrypoint .docker/php-artisan-migrate
{% endhighlight %}

berikut file lengkapnya:

{% gist page.gist "04a-dockerfile-v2" %}

dan yang terakhir kita update juga file `docker-compose.build.yaml` untuk image versionnya menjadi `v2` seperti berikut:

{% gist page.gist "04a-docker-compose-build-v2.yaml" %}

Ok nah sekarang kita build ulang docker image tersebut dengan perintah

{% highlight bash %}
docker compose -f docker-compose.build.yaml build laravel && \
docker compose -f docker-compose.build.yaml push laravel
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » docker-compose -f docker-compose.build.yaml build laravel
[+] Building 194.5s (25/25) FINISHED                                                                                                                                        
 => [internal] load build definition from Dockerfile                                                                                                                   0.0s
 => => transferring dockerfile: 69B                                                                                                                                    0.0s
 => [internal] load .dockerignore                                                                                                                                      0.0s
 => => transferring context: 72B                                                                                                                                       0.0s
 => [internal] load metadata for docker.io/library/php:8.0-apache                                                                                                      1.7s
 => [internal] load metadata for docker.io/library/node:14.15-alpine3.13                                                                                               2.0s
 => [php_laravel 1/8] FROM docker.io/library/php:8.0-apache@sha256:250cc0aa50713360672b12342b8477cf6adbf7c6fa6ffd0a59bf5c95c48299db                                    0.0s
 => FROM docker.io/library/composer:latest                                                                                                                             2.2s
 => => resolve docker.io/library/composer:latest                                                                                                                       2.2s
 => [internal] load build context                                                                                                                                      1.6s
 => => transferring context: 958.90kB                                                                                                                                  1.5s
 => [laramix_build 1/4] FROM docker.io/library/node:14.15-alpine3.13@sha256:03b86ea1f9071a99ee3de468659c9af95ca0bedbcd7d32bf31d61fa32c1a8ab3                           0.0s
 => CACHED [laramix_build 2/4] WORKDIR /var/www/php                                                                                                                    0.0s
 => CACHED [laramix_build 3/4] COPY . .                                                                                                                                0.0s
 => [laramix_build 4/4] RUN npm install -q &&     npm run-script prod                                                                                                143.0s
 => CACHED [php_laravel 2/8] RUN apt-get update && apt-get install -y   curl   git   libicu-dev   libpq-dev   libmcrypt-dev   mariadb-client   openssl   unzip   vim   0.0s
 => CACHED [php_laravel 3/8] RUN pecl install mcrypt-1.0.4 &&   docker-php-ext-install fileinfo exif pcntl bcmath gd mysqli pdo_mysql &&   docker-php-ext-enable mcry  0.0s
 => CACHED [php_laravel 4/8] COPY --from=composer /usr/bin/composer /usr/bin/composer                                                                                  0.0s
 => CACHED [php_laravel 5/8] WORKDIR /var/www/php                                                                                                                      0.0s
 => CACHED [php_laravel 6/8] COPY .docker/000-default.apache.conf /etc/apache2/sites-enabled/000-default.conf                                                          0.0s
 => CACHED [php_laravel 7/8] COPY .docker/apache2-foreground .docker/apache2-foreground                                                                                0.0s
 => [php_laravel 8/8] COPY .docker/php-artisan-migrate .docker/php-artisan-migrate                                                                                     0.3s
 => [executeable 1/6] COPY . .                                                                                                                                         4.6s
 => [executeable 2/6] COPY --from=laramix_build /var/www/php/public/css public/css                                                                                     0.1s
 => [executeable 3/6] COPY --from=laramix_build /var/www/php/public/fonts public/fonts                                                                                 0.1s
 => [executeable 4/6] COPY --from=laramix_build /var/www/php/public/js public/js                                                                                       0.0s
 => [executeable 5/6] RUN mkdir -p public/storage &&     chmod -R 777 storage/* &&     chmod -R 777 public/storage &&     chmod -R 777 .docker/*                       0.4s
 => [executeable 6/6] RUN php -r "file_exists('.env') || copy('.env.example', '.env');" &&     composer install --no-interaction --optimize-autoloader --no-dev &&    45.7s
 => exporting to image                                                                                                                                                 1.4s
 => => exporting layers                                                                                                                                                1.4s
 => => writing image sha256:8c5f4fc094a2091f9bb22c177d200305ef38f5b83b088a68d21683c18e34f794                                                                           0.0s
 => => naming to repository.dimas-maryanto.com:8087/dimmaryanto93/laravel-monolith-apps:v2                                                                             0.0s

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

examples/k8s-laravel-example [main●] » docker-compose -f docker-compose.build.yaml push laravel
```

Nah selanjutnya setelah kita build, kita update file `pod-laravel.yaml` untuk menambahkan initContainer seperti berikut:

{% gist page.gist "04a-pod-laravel-init-container.yaml" %}

Nah sekarang kita bisa coba execute dengan perintah berikut:

{% highlight bash %}
kubectl apply -f .kubernetes
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » kubectl apply -f .kubernetes                             
configmap/mysql-config created
secret/mysql-secret created
pod/laravel-apps created
pod/mysql-db created
service/laravel-apps created
service/mysql-db created

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS     RESTARTS   AGE
laravel-apps   0/1     Init:0/1   0          5s
mysql-db       1/1     Running    0          5s

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS            RESTARTS   AGE
laravel-apps   0/1     PodInitializing   0          55s
mysql-db       1/1     Running           0          55s

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS    RESTARTS   AGE
laravel-apps   1/1     Running   0          58s
mysql-db       1/1     Running   0          58s

examples/k8s-laravel-example [main●] » kubectl logs laravel-apps -c init-db
Configuration cache cleared!
Application cache cleared!
Configuration cache cleared!
Configuration cached successfully!
Route cache cleared!
Routes cached successfully!
Files cached successfully!
Migration table created successfully.
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (179.94ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (113.14ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (156.36ms)
Migrating: 2021_08_09_164144_create_mahasiswa_table
Migrated:  2021_08_09_164144_create_mahasiswa_table (416.20ms)

examples/k8s-laravel-example [main●] » kubectl exec -it pod/mysql-db -- mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 8.0.31 MySQL Community Server - GPL

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| mahasiswa_db       |
| mysql              |
+--------------------+
5 rows in set (0.10 sec)

mysql> use mahasiswa_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> show tables;
+------------------------+
| Tables_in_mahasiswa_db |
+------------------------+
| failed_jobs            |
| mahasiswa              |
| migrations             |
| password_resets        |
| users                  |
+------------------------+
```

Jika kita lihat di browser maka outputnya sama seperti pada section sebelumnnya.

## Specify container probes (health check)

Seperti yang temen-temen ketahui, `Container probes` digunakan untuk health check pada suatu container. Di kubernetes ada 3 jenis container probes yaitu `liveness`, `readiness` dan `startupProbe` yang masing masing punya tujuan tertentu.

Karena aplikasi kita berupa web service yang menggunakan connection based TCP khususnya HTTP jadi kita akan menggunakan HTTP request container probe dan yang akan kita check adalah aplication `startup` dan `liveness`. Dimana startup container probe ini untuk mengecheck web server sudah running dan liveness mengecheck connection ke database apakah sukses atau gagal. Untuk membuatnya health checknya ada beberapa hasil yang perlu kita rubah yaitu 

Ubah file `web.php` pada routers folder dengan menambahkan endpoint seperti berikut:

{% gist page.gist "04a-web-container-probe.php" %}

Kemudian coba test dulu di local dengan menjalankan perintah 

{% highlight bash %}
php artisan serve
{% endhighlight %}

Kemudian coba akses di browser

1. [http://localhost:8000/actuator/health/liveness](http://localhost:8000/actuator/health/liveness)
2. [http://localhost:8000/actuator/health/readiness](http://localhost:8000/actuator/health/readiness)

Selanjutnya kita build ulang docker imagenya dengan mengupdate file `docker-compose.build.yaml` ke `v3` dan build menggunakan perintah

{% highlight bash %}
docker compose -f docker-compose.build.yaml build laravel && \
docker compose -f docker-compose.build.yaml push laravel
{% endhighlight %}

Setelah docker imagenya di build dan push, selanjutnya kita edit `pod-laravel.yaml` untuk mengimplementasikan container probe seperti berikut:

{% gist page.gist "04a-pod-laravel-container-probe.yaml" %}

Sekarang kita execute dengan perintah berikut:

{% highlight bash %}
kubectl apply -f .kubernetes
{% endhighlight %}

Jika dijalankan hasilnya seperti berikut:

```bash
examples/k8s-laravel-example [main●] » kubectl apply -f .kubernetes                             
configmap/mysql-config created
secret/mysql-secret created
pod/laravel-apps created
pod/mysql-db created
service/laravel-apps created
service/mysql-db created

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS     RESTARTS   AGE
laravel-apps   0/1     Init:0/1   0          17s
mysql-db       1/1     Running    0          17s

examples/k8s-laravel-example [main●] » kubectl get pod                  
NAME           READY   STATUS    RESTARTS   AGE
laravel-apps   1/1     Running   0          60s
mysql-db       1/1     Running   0          60s

examples/k8s-laravel-example [main●] » kubectl describe pod laravel-apps
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  81s   default-scheduler  Successfully assigned default/laravel-apps to laravel-monolith-m02
  Normal  Pulling    79s   kubelet            Pulling image "repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v3"
  Normal  Pulled     46s   kubelet            Successfully pulled image "repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v3" in 32.791370328s
  Normal  Created    46s   kubelet            Created container init-db
  Normal  Started    46s   kubelet            Started container init-db
  Normal  Pulled     42s   kubelet            Container image "repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v3" already present on machine
  Normal  Created    42s   kubelet            Created container laravel
  Normal  Started    41s   kubelet            Started container laravel

examples/k8s-laravel-example [main●] » kubectl delete pod/mysql-db
pod "mysql-db" deleted

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS    RESTARTS     AGE
laravel-apps   0/1     Running   1 (3s ago)   2m53s

examples/k8s-laravel-example [main●] » kubectl describe pod laravel-apps
Events:
  Type     Reason     Age                  From               Message
  ----     ------     ----                 ----               -------
  Normal   Scheduled  3m8s                 default-scheduler  Successfully assigned default/laravel-apps to laravel-monolith-m02
  Normal   Pulling    3m6s                 kubelet            Pulling image "repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v3"
  Normal   Pulled     2m33s                kubelet            Successfully pulled image "repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v3" in 32.791370328s
  Normal   Created    2m33s                kubelet            Created container init-db
  Normal   Started    2m33s                kubelet            Started container init-db
  Normal   Killing    19s                  kubelet            Container laravel failed liveness probe, will be restarted
  Normal   Pulled     17s (x2 over 2m29s)  kubelet            Container image "repository.dimas-maryanto.com:8086/dimmaryanto93/laravel-monolith-apps:v3" already present on machine
  Normal   Created    17s (x2 over 2m29s)  kubelet            Created container laravel
  Normal   Started    17s (x2 over 2m28s)  kubelet            Started container laravel
  Warning  Unhealthy  1s (x5 over 25s)     kubelet            Liveness probe failed: HTTP probe failed with statuscode: 500

examples/k8s-laravel-example [main●] » kubectl get pod
NAME           READY   STATUS             RESTARTS     AGE
laravel-apps   0/1     CrashLoopBackOff   4 (2s ago)   4m13s
```

Nah jadi dengan container probe ini, terjadi sesuatu pada container yang mengakibatkan web server tidak bisa meresponse dengan success atau response 200 maka container akan di restart dengan tujuan mengembalikan state semula atau fresh container.
