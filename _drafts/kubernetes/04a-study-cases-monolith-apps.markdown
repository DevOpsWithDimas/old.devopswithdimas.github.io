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
youtube: 
comments: true
catalog_key: pod-container
image_path: /resources/posts/kubernetes/04a-study-cases-monolith-apps
gist: dimMaryanto93/a3a01b83910cf07914935a25a62d30ce
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
    2. Run initContainer for database migration
    3. Using container probe
    4. Using resource request and limit

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
--memory 2G \
--cpus 2

minikube profile laravel-monolith

minikube addons enable registry-creds && \
minikube addons configure registry-creds
{% endhighlight %}

Nah sambil nungguin cluster kubernetes di-provision oleh minikube, kita akan buat kuberentes resourcenya dulu untuk deploy laravel seperti berikut:

{% gist page.gist "04a-pod-laravel-monolith.yaml" %}