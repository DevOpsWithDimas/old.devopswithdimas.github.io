---
layout: post
title: "Inner Join di Oracle"
lang: oracle18c
categories:
- RDBMS
- Oracle18c
refs: 
- https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/Joins.html#GUID-794F7DD5-FB18-4ADC-9E46-ADDA8C30C3C6
youtube: 
comments: true
image_path: /resources/posts/oracle12c/
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Selain menggunakan `Natural join` kita bisa menggunakan klausa `on` dan juga `where` atau lebih dikenal dengan **Inner JOIN**. Dengan menggunakan klausa `on` kita bisa bebas menentukan column mana yang akan di relasikan contohnya seperti berikut:

Contoh kasusnya, saya mau mencari data setiap department dan tampilkan siapa nama managernya. Berikut querynya:

{% gist page.gist "010c-inner-join-on.sql" %}

Berikut hasilnya:

{% highlight sql %}
 DEP_ID    DEP_NAME                       MANAGER_NAME
---------- ------------------------------ ----------------------------------------------
        10 Administration                 Jennifer Whalen
        20 Marketing                      Michael Hartstein
        30 Purchasing                     Den Raphaely
        40 Human Resources                Susan Mavris
        50 Shipping                       Adam Fripp
        60 IT                             Alexander Hunold
        70 Public Relations               Hermann Baer
        80 Sales                          John Russell
        90 Executive                      Steven King
       100 Finance                        Nancy Greenberg
       110 Accounting                     Shelley Higgins

11 rows selected.
{% endhighlight %}
