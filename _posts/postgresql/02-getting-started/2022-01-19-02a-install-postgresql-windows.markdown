---
layout: post
title: "Install PostgreSQL for Windows users"
date: 2022-01-19T06:53:44+07:00
lang: postgresql
categories:
- RDBMS
- PostgreSQL
- getting-started
refs: 
- https://www.postgresql.org/download/
- https://bitnami.com/stack/postgresql
- https://www.percona.com/software/postgresql-distribution
youtube: 
image_path: /resources/posts/postgresql/02a-install-postgres-windows
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: getting-started
downloads: 
- name: "schema-hr"
  type: "sql"
  url: /resources/downloads/file/postgresql/psql-schema.sql
---

Hai semuanya, di materi kali ini kita akan membahas Install PostgreSQL di Windows 10/11. Diantaranya

1. Install PostgreSQL Server for Learning environtment
2. Test connection to PostgreSQL
3. Tips for Using PostgreSQL
4. Create user & database for Learning environtment

Ok langsung aja kita bahas materi yang pertama 

## Install PostgreSQL Server for Learning environtment

Untuk melakukan installasi PostgreSQL server ada 2 cara yaitu Installer dan compile sendiri dari source. 

![installer]({{ page.image_path | prepend: site.baseurl}}/00-downloads.png)

Kita akan membahas yang paling mudah ya yaitu menggunakan Installer. Untuk distribution installernya pun ada banyak sekali beberapa vendor yang paling popular diantaranya

1. [Official distribution open-source](https://www.postgresql.org/download/)
2. [PostgreSQL package by bitnami](https://bitnami.com/stack/postgresql)
3. [Percona distribution for PostgreSQL](https://www.percona.com/software/postgresql-distribution)
4. dan masih banyak lagi

Karena tujuan kita adalah untuk belajar atau Learning environtment maka kita bisa manfaatkan yang free dan opensource seperti Official distribution. Ok langsung ja kita download dulu installernya dari [Official distribution](https://www.postgresql.org/download/)

Setelah itu pilih platform yang sesuai dengan Operation System yang kita gunakan misalnya `Windows x86_64` dan pake versi yang terbaru saja in my case version `v14.1`,

![installer]({{ page.image_path | prepend: site.baseurl}}/00-installer.png)

kemudian kita jalankan file `.exe` maka akan muncul welcome page seperti berikut:

![welcome-page]({{ page.image_path | prepend: site.baseurl}}/01-welcome.png)

Kemudian klik **Next** untuk melanjutkan, setelah itu maka akan muncul form untuk lokasi installation seperti berikut:

![location-dir]({{ page.image_path | prepend: site.baseurl}}/02-install-location.png)

Kemudian kita pilih lokasi install untuk PostgreSQL, klo saya **biarkan aja default** seperti itu, Klik **Next** lalu maka akan muncul lagi form seperti berikut:

![components]({{ page.image_path | prepend: site.baseurl}}/03-choosing-component.png)

Nah kita tinggal pilih SQL Editornya, klo saya udah terbiasa dengan menggunakan `pgAdmin4` dan `command-line` jadi saya cheklist seperti gambar diatas, Kemudian klik **Next** untuk menanjutkan:

![data-location]({{ page.image_path | prepend: site.baseurl}}/03-data-directory-location.png)

Setelah itu akan muncul form untuk menyimpan data seperti gambar diatas, konfigurasi ini **biarkan default** aja atau temen-temen juga bisa simpan di partisi lain jika partisin default terlalu kecil. langsung klik **Next**. setelah ikut akan tampil form seperti berikut:

![postgres-password]({{ page.image_path | prepend: site.baseurl}}/04-postgres-password.png)

Nah di form ini kita diminta untuk **memasukan password default untuk schema postgres**. User `postgres` ini adalah superuser yang bertujuan untuk membuat user baru, database, dan objek-objek lain di Database Management Sistemnya PostgreSQL. Jadi saran saya **gunakan password yang mudah di ingat** contohnya `admin`, nama-anda atau lain-lain. klo saya passwordnya `admin`. Setelah password di isi kita klik **Next** untuk melanjutkan:

![default-port]({{ page.image_path | prepend: site.baseurl}}/05-port-binding.png)

Nah di form ini juga kita **diminta untuk input port** yang digunakan untuk PostgreSQL Server berkomunikasi dengan client melalu exposed port, kalau saya **biarkan default** yaitu `5432` kemudian **Next** untuk menampilkan konfirmasi atas konfigurasi yang udah di setup barusan maka formnya seperti berikut:

![summary]({{ page.image_path | prepend: site.baseurl}}/07-summary.png)

Kemudian kita clik **Install** maka akan melakukan installing component yang sudah di pilih seperti berikut:

![installing]({{ page.image_path | prepend: site.baseurl}}/08-installing.png)

Jika sudah selesai maka seperti berikut:

![finishing]({{ page.image_path | prepend: site.baseurl}}/09-finish.png)

## Test connection to PostgreSQL

Untuk melakukan testing login ada 2 cara yaitu dengan menggunakan command prompt dan juga tools yang telah kita tambahkan tadi yaitu `pgAdmin4`. sekarang kita coba dulu login dengan command prompt maka gunakan perintah seperti berikut:

{% highlight powershell %}
psql -h localhost -U postgres -W
{% endhighlight %}

jika berhasil login maka tampilannya seperti berikut:

![psql]({{ page.image_path | prepend: site.baseurl}}/10-psql.png)

Selain itu juga kita bisa menggunakan `pgAdmin4` berikut caranya:

![pgadmin4]({{ page.image_path | prepend: site.baseurl}}/10-pgadmin4.png)

Secara default jika kita install menggunakan EDB serta mengaktfikan pgAdmin4 dan Server di hosts yang sama kita sudah di register. kita tidak perlu register lagi kita cukup click Servers dan connect PostgreSQL 14 dan input password untuk user `postgres` maka hasilnya seperti berikut:

![pgadmin4-connected]({{ page.image_path | prepend: site.baseurl}}/11-pgadmin4-connected.png)

## Tips for Using PostgreSQL

Untuk mode Learning environment kita khan tidak secara terus menerus menggunakan Database PostgreSQL seperti pada Production mode yang harus terus on event ketika server di restart, ada baiknya kita set service PostgreSQL run manualy caranya kita ke `View Local Services` -> setelah itu anda cari service namenya `PostgreSQl 14.x Server` atau `postgresql-x64-xx` seperti gambar berikut ini:

![pg-service]({{ page.image_path | prepend: site.baseurl}}/12-local-view-service.png)

kemudian pilih **Properties** maka akan tampil konfigurasi seperti berikut:

![manual]({{ page.image_path | prepend: site.baseurl}}/13-manual-service.png)

Jadi konfigurasi secara default servicenya adalah `Automatic` jadi ketika komputer dihidupkan service PostgreSQL Server auto runing juga. Karena kita mau cuman jalankan ketika digunakan saja maka pilih saja `Manual` kemudian klick **Apply** dan **OK**

## Create user & database for Learning environtment

Setelah melakukan proses installasi _software_ PostgreSQL Server dan PgAdmin4, tahap selanjutnya kita akan membuat scema atau role, berikut adalah caranya.

Login sebagai user `postgres`, yang pertama harus di ingat adalah _password_ postgres didapatkan ketika melakukan installasi software PostgreSQL. setelah itu baru bisa login sebagai user postgres dengan cara seperti berikut:

{% highlight psql %}
psql -h localhost -U postgres -W
{% endhighlight %}

Kemudian kita buat schema & database dengan perintah seperti berikut:

{% gist page.gist "02a-create-user-schema.sql" %}

Setelah membuat user dengan _username_ `hr` dan passwornya sama dengan _username_ yaitu `hr`, tahap selanjutnya kita login sebagai user `hr`, dengan perintah seperti berikut:

{% highlight psql %}
psql -h localhost -U hr -W
{% endhighlight %}

Setelah login sebagai `hr` kemudian download [file ini]({{ site.baseurl }}/resources/downloads/file/postgresql/psql-schema.sql) setelah itu import file sql tersebut ke database `hr` dengan perintah seperti berikut:

{% highlight psql %}
psql -h localhost -d hr -U hr -W -f .\psql-schema.sql
{% endhighlight %}

Kemudian kita check dengan cara login menggunakan user dan database `hr` perintah seperti berikut:

{% highlight psql %}
psql -h localhost -d hr -U hr -W
{% endhighlight %}

Kemudian check datanya dengan perintah seperti berikut:

{% highlight psql %}
\dt

select count(*) from employees;
{% endhighlight %}

Maka hasilnya seperti berikut:

![migration]({{ page.image_path | prepend: site.baseurl}}/14-migration.sql.png)

Jika sudah seperti gambar diatas, selamat anda sudah sukses dan siap untuk mulai belajar Database PostgreSQL Fundamental.