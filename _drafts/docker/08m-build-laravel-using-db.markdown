---
layout: post
title: "Study Kasus: Laravel - Using Database"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.docker.com/
- https://laravel.com/docs/8.x/database
- https://laravel.com/docs/8.x/queries
- https://laravel.com/docs/8.x/migrations
youtube: 
comments: true
image_path: /resources/posts/docker/08l-laravel-db
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---

Hai semuanya, di materi study kasus kali ini kita akan membahas tentang menggunakan Database pada project Laravel. Diantaranya 

1. Setup and Configure connection to Database
2. Basic CRUD using fluent query builder
3. Build & Running Docker Image
4. Cleanup

Ok langsung aja kita ke pembahasan yang pertama 

## Setup and Configure connection to Database

Almost every modern web application interacts with a database. Laravel makes interacting with databases extremely simple across a variety of supported databases using raw SQL, a fluent query builder, and the Eloquent ORM. Currently, Laravel provides first-party support for four databases:

1. MySQL `5.7+`
2. PostgreSQL `9.6+`
3. SQLite `3.8.8+`
4. SQL Server `2017+`

Sebagai study kasus kali ini kita akan menggunakan database [MySQL 5.7](https://hub.docker.com/_/mysql) yang akan saya jalankan menggunakan docker seperti berikut:

For Bash script:

{% gist page.gist "08m-docker-mysql-run.bash" %}

For Powershell script:

{% gist page.gist "08m-docker-mysql-run.ps1" %}

The configuration for Laravel's database services is located in your application's `config/database.php` configuration file. Most of the configuration options within this file are driven by the values of your application's environment variables

Kita edit file `.env` menjadi seperti berikut:

{% highlight .env %}
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=docker_laravel
DB_USERNAME=docker_laravel
DB_PASSWORD=docker_laravel
{% endhighlight %}

Setelah itu kita bisa check connectionnya menggunakan perintah 

{% highlight bash %}
php artisan migrate:install && \
php artisan migrate:status && \
php artisan migrate
{% endhighlight %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker-laravel git:(master)✗  php artisan migrate:install
Migration table created successfully.

➜ docker-laravel git:(master) php artisan migrate:status
+------+------------------------------------------------+-------+
| Ran? | Migration                                      | Batch |
+------+------------------------------------------------+-------+
| No   | 2014_10_12_000000_create_users_table           |       |
| No   | 2014_10_12_100000_create_password_resets_table |       |
| No   | 2019_08_19_000000_create_failed_jobs_table     |       |
+------+------------------------------------------------+-------+

➜ docker-laravel git:(master) php artisan migrate
Migrating: 2014_10_12_000000_create_users_table
Migrated:  2014_10_12_000000_create_users_table (34.42ms)
Migrating: 2014_10_12_100000_create_password_resets_table
Migrated:  2014_10_12_100000_create_password_resets_table (26.96ms)
Migrating: 2019_08_19_000000_create_failed_jobs_table
Migrated:  2019_08_19_000000_create_failed_jobs_table (28.19ms)

➜ docker-laravel git:(master) php artisan migrate:status
+------+------------------------------------------------+-------+
| Ran? | Migration                                      | Batch |
+------+------------------------------------------------+-------+
| Yes  | 2014_10_12_000000_create_users_table           | 1     |
| Yes  | 2014_10_12_100000_create_password_resets_table | 1     |
| Yes  | 2019_08_19_000000_create_failed_jobs_table     | 1     |
+------+------------------------------------------------+-------+
```

Dengan konfigurasi seperti berikut, kita sudah bisa connect antara PHP Laravel dengan Database MySQL v5.7