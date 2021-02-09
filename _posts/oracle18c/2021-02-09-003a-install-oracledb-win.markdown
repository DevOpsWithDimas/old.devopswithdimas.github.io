---
layout: post
title: "Install Oracle 18c Express Edition (Windows 10)"
date: 2021-02-09T15:46:03+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
- https://www.oracle.com/database/technologies/appdev/xe.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/003a-install-win
gist: 
downloads: []
---

Hai pada kesempatan kali ini saya mau membahas cara install Oracle Database 18c Express Edition pada sistem operasi Windows 10

## Install Oracle 18c Express Edition

Setelah selesai donwloadnya, kemudian di extract saja file `.zip` kemudian buka file `setup.exe` maka akan muncul dialog seperti berikut:

![welcome-page]({{ page.image_path | prepend: site.baseurl }}/1a-welcome-pages.png)

Kemudian klick `Next`, 

![user-aggrement]({{ page.image_path | prepend: site.baseurl }}/1b-user-aggrement.png)

Kita pilih `aggree` lalu klick `Next`,

![location]({{ page.image_path | prepend: site.baseurl }}/1c-location-installation.png)

Kemudian kita pilih lokasi install yang kita inginkan, klo saya biarkan default dan klick `Next`

![password]({{ page.image_path | prepend: site.baseurl }}/1d-password-system.png)

Nah dibagian ini hal yang paling penting yaitu mengisi `password` untuk management database oracle. jadi temen-temen **harus ingat ya password yang di isi**. nah klo saya di isi `admin` kemudian klick `Next`

![confirm-install]({{ page.image_path | prepend: site.baseurl }}/1e-install-confirm.png)

Kemudian klick `Install`

![loading-screen.png]({{ page.image_path | prepend: site.baseurl }}/1e-install-confirm.png)

Setelah sampai ini, mungkin installasi akan berjalan lumayan lama kurang lebih 15menit-an. jadi silahkan di tunggu aja ya, setelah itu klick `Finish`

![finish]({{ page.image_path | prepend: site.baseurl }}/1g-finish.png)

## Set service run as manualy

Untuk service oracle ini memang cukup memakan resource PC kita, jadi akan lebih enak jika servicenya kita hidupkan kalau kita butuh saja. untuk mengesetnya kita ke `Services` kemudian cari service dengan prefix `oracle` seperti berikut:

![service-oracle]({{ page.image_path | prepend: site.baseurl }}/2a-service-oracle.png)

Kemudian kita `klick kanan` -> `OracleServiceXE` -> `Properties` kita set manual seperti berikut:

![manual-service]({{ page.image_path | prepend: site.baseurl }}/2b-service-set-to-manual.png)

Kemudian apply.

## Test Connection

Untuk mencoba install kita sudah sukses atau belum kita bisa coba test connection menggunakan program `SQL Plus` coba input user `system` dan passwordnya yang temen-temen masukan tadi waktu install seperti berikut:

![test-connection]({{ page.image_path | prepend: site.baseurl }}/3a-sqlplus.png)

Jika success maka hasilnya seperti berikut:

![connected]({{ page.image_path | prepend: site.baseurl }}/3b-connected.png)

Jika failed coba periksa service oraclenya sudah jalan atau belum!!
