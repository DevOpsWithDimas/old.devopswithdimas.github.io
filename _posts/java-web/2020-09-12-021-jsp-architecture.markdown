---
layout: post
title: "JSP Architecture"
date: 2020-09-12T21:15:36+07:00
lang: java-web
authors:
- dimasm93
categories:
- java
- web
- war
refs: 
- http://tomcat.apache.org/whichversion.html
youtube: 442-W6LvC-8
comments: true
gist: dimMaryanto93/c0a51e92e23ada4ecb71f9c18c803fea
image_path: /resources/posts/java-web/java-web-021
downloads: []
---

JSP membutuhkan Web Server dengan spesifikasi JSP Proccessing tertentu, Contohnya seperti Apache Tomcat 7 yang kita gunakan yaitu memiliki spesifikasi servlet version `3.0`, JSP version `2.2` dan JDK yang disupport yaitu `7 or later`.

Berikut adalah diagram dimana posisi JavaServer Page dalam container Web Server dalam Web Aplikasi

![jsp inside container]({{ page.image_path | prepend: site.baseurl }}/java-web-deployment-env.jpg)

## JavaServer Pages Processing

Bagaimana JSP di proses dalam web server, berikut diagram untuk menjelaskan flow proses JSP di proses oleh web server:

![jsp processing]({{ page.image_path | prepend: site.baseurl }}/jsp-processing.jpg)