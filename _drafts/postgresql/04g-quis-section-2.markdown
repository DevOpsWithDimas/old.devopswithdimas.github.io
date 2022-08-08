---
layout: post
title: "Time your practice (part 2)"
lang: postgresql
authors:
- dimasm93
categories:
- RDBMS
- PostgreSQL
- sql
- select
refs: 
- https://www.postgresql.org/docs/14/queries.html
youtube: 
image_path: /resources/posts/postgresql/04g-quis-section-2
comments: true
gist: dimMaryanto93/7ae7632f9418feb724bc431eff412a3f
catalog_key: select-statement
downloads: []
---

Hai semuanya di materi sebelumnya kita sudah membahas beberapa hal basic sepert SQL Select statement, build-in Functions and Operators, WHERE clause, dan limit serta offset. Untuk memahami materi sebelumnya saatnya temen-temen untuk mencoba dengan mengerjakan soal seperti berikut: 

<!--more-->

1. buatlah _query_ untuk menampilkan data sebagai berikut:
![Hasil soal no 1]({{ page.image_path | prepend: site.baseurl }}/soal1.png)
Dengan ketentuan:
    1. `Nama Lengkap`: pengabungan antara `first_name` dan `last_name` dari tabel `employees`
    2. `Nama Department`: diambil dari table `departements`
    3. `Gaji sebulan`: diabil dari colomn `salary` dalam table `employees` yang diformat dipisahkan dengan `,` (koma)
    4. `Mendapatkan Komisi`: Jika column `commission_pct` bernilai `null` tampilkan `Tidak punya komisi` tetapi jika memiliki komisi maka tampilkan berapa komisi yang karyawan tersebut dapatkan berdaksarkan `salary`.
    5. `gaji_terima`: Gaji yang harus diterima oleh karyawan tersebut setelah ditambakan dengan komisi.
2. Buatlah query untuk menampilkan data, karyawan berserta nama managernya tetapi jika tidak punya manager tampilkan 'Saya Tidak punya manager' seperti berikut contohnya:
![Hasil soal no 2]({{ page.image_path | prepend: site.baseurl }}/soal2.png)
Ketentuannya:
    1. `nama_karyawan`: gabungkan ke dua kolom `last_name` dan `fist_name`
    2. `Nama Bagian`: diambil dari kolom `depertment_name` di tabel `departments`
    3. `manager_name`: diambil dari kolom `first_name` dan `last_name` berdasarkan `manager_id` di tabel `employees`, jika tidak punya manager tampilkan 'Saya tidak punya manager'
    4. `Nama Jabatan`: dimabil dari kolom `job_title` di tabel `jobs`
    5. Diurutkan `manager_name` dan `nama_karyawan`
3. Buatlah query, untuk menampilkan data total gaji seluruh karyawan dari setiap department kemudian urutkan berdasarkan gaji terbesar ke terkecil seperti berikut:
![Hasil soal no 3]({{ page.image_path | prepend: site.baseurl }}/soal3.png)
4. Buatlah query untuk menampilkan data, jumlah karyawan yang dikategorikan berdasarkan gaji setahun kemudian diurutkan berdasarkan kategori gaji tersebut dari terbesar hingga terkecil tetapi hanya yang memiliki komisi saja seperti berikut:
![Hasil no 4]({{ page.image_path | prepend: site.baseurl }}/soal4.png)
5. Buatlah sebuah query untuk menampilkan semua data karyawan yang memiliki gaji lebih besar sama dengan nilai maximum setiap karyawan yang bekerja di department `IT_PROG` contohnya seperti berikut:
![hasil no 5]({{ page.image_path | prepend: site.baseurl }}/soal5.png)
6. Buatlah sebuah query (**Menggunakan `WITH` query**) untuk menampikan semua manager yang menjabat pada suatu department di suatu `country_id = 'US'` yang di urutkan menggunakan salary terbesar, tampikan dengan format seperti berikut:
![hasil no 6]({{ page.image_path | prepend: site.baseurl }}/soal6.png)
