---
layout: post
title: "Natural Join di Oracle"
date: 2021-02-15T06:55:48+07:00
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/database/121/index.htm
- https://docs.oracle.com/en/bigdata/index.html
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---


Natural join, query yang paling mudah untuk menerapkan join tetapi ada syaratnya yaitu:

1. Column name harus sama di antara ke dua tables
2. Harus memiliki `constraint foreign key`

Contohnya saya ingin menampilakan. selurauh data location  yang ditampilkan adalah `location_id`, `city`, `state_province`, `country_name` yang diambil dari table `countries`. Berikut querynya:

{% gist page.gist "010a-natural-join.sql" %}

Berikut hasilnya:

{% highlight sql %}
KODE_LOKASI KOTA                            PROVINSI                    NEGARA
----------- ------------------------------  -------------------------   ---------------------------
       1000 Roma                            <null>                      Italy
       1100 Venice                          <null>                      Italy
       1200 Tokyo                           Tokyo Prefecture            Japan
       1300 Hiroshima                       <null>                      Japan
       1400 Southlake                       Texas                       United States of America
       1500 South San Francisco             California                  United States of America
       1600 South Brunswick                 New Jersey                  United States of America
       1700 Seattle                         Washington                  United States of America
       1800 Toronto                         Ontario                     Canada

23 rows selected.
{% endhighlight %}