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

