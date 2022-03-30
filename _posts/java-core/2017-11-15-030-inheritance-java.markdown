---
layout: post
title: "Mengenal lebih jauh tentang inheritance"
date: 2017-11-15T20:19:57+07:00
lang: java-core
authors:
- dimasm93
categories:
- Java
- Core
refs: []
youtube: c3JKsRiBgJA
comments: true
image_path: /resources/posts/java-core/java-konsep-oop
downloads: []
---

Mungkin _inheritance_ di Java agak _anti-mainstream_ artinya beda dari teknologi pesaingnya seperti `.NET`, `PHP` dan lain-lain, yang menerapkan _single extends_. Seperti di konsep sebelumya yaitu seperti berikut:

![Single extends]({{ page.image_path | prepend: site.baseurl }}/inheritance.jpg)

Sedangkan untuk _multiple extends_ di Java digantikan dengan sistem _interface_ atau lebih dikenal dengan _abstract class_. Kalau digambarkan jadi seperti berikut:

![Multiple extends]({{ site.baseurl }}/resources/posts/java-inherintance/multi-inherintance.jpg)

Di Java tidak mengenal _multiple inherintace_ dalam _class_ sebagai gantinya menggunakan sebuah _interface_ seperti berikut contohnya:

### Engine

{% highlight java linenos %}
package tdi.training.java.core;

public interface Engine{
    String engineBlock = "V4 inline";
    Integer cylinder = 4;
}
{% endhighlight %}

### BreakCPU

{% highlight java linenos %}
package tdi.training.java.core;

public interface BreakCPU{
    boolean ktrc = true;
    boolean abs = true;
}
{% endhighlight %}

### SportBike

{% highlight java linenos %}
package tdi.training.java.core;

public interface SportBike extends Engine, BreakCPU{
    boolean raceMode();
}
{% endhighlight %}

### ZX10RR

{% highlight java linenos %}
package tdi.training.java.core;

public class ZX10RR implements SportBike {

    public boolean raceMode(){
        return true;
    }

    public static void main(String[] args){
        ZX10RR rea = new ZX10RR();
        System.out.println(
            "Engine : [ engineBlock : " + rea.engineBlock + ", cylinder : " + rea.cylinder + "], breaking system : [ abs : " + rea.abs + "], profile race mode is " + rea.raceMode()
        ); 	
    }
}
{% endhighlight %}

