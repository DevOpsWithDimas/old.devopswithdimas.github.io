---
layout: post
title: "Index - Bitmap"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/indexes-and-index-organized-tables.html#GUID-B15C4817-7748-456D-9740-8B9628AF9F47
- https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/Chunk559441123.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/017b-bitmap-index
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Bitmap Index sedikit berbeda dengan normal index (b-tree) yang menyimpan satu index entry merepresentasi suatu baris, Suatu Bitmap Index biasanya di setiap index entry bisa mewakili banyak baris atau memiliki tingkat keragamannya rendah (low cardinality). Sebagai contoh berikut adalah tabelnya yang akan kita gunakan:

{% gist page.gist "017b-create-table-for-bitmap.sql" %}

Jadi pada table tersebut kita bisa gunakan index bitmap column `jenis_kelamin` karena secara data hanya memungkinkan ada `L` dan `P` saja.

Untuk membuat index bitmap, berikut contohnya:

{% gist page.gist "017b-create-index-bitmap.sql" %}