---
layout: post
title: "Install Database Editor untuk Oracle 18c"
date: 2021-02-10T17:12:11+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://www.oracle.com/tools/downloads/sqldev-downloads.html
youtube: 9orXTthlCrM
comments: true
image_path: /resources/posts/oracle12c/003d-sqldeveloper
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Untuk Text editor, kita akan menggunakan Oracle SQL Developer. jadi langsung aja kita install ya. Ok pertama download dulu dari website resminya [disini](https://www.oracle.com/tools/downloads/sqldev-downloads.html)

Setelah di download, kemudian extract dan jalankan

- `sqldeveloper.exe` untuk Windows
- `./sqldeveloper.sh` untuk linux
- `sqldeveloper.app` untuk Mac

## Create Connection

Untuk membuat connection, klick button `+` pada tab `connections` maka muncul dialog seperti berikut:

![create-connect]({{ page.image_path | prepend: site.baseurl }}/1-create-connection.png)

Setelah itu coba, klick `test` jika sukses hasilnya seperti berikut:

![test-success]({{ page.image_path | prepend: site.baseurl }}/2-test-connect.png)

Sekarang kita bisa menggunakan editor dengan user connection `system`,

![navigator]({{ page.image_path | prepend: site.baseurl }}/3-explore.png)