---
layout: post
title: "How to Install git on MacOS"
lang: gitlab
authors:
- dimasm93
categories:
- git
- gitops
- gitlab
refs: 
- https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- https://git-scm.com/download/mac
- https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01b-install-git-mac
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, sebelum kita hand-on menggunakan Git SCM kita harus siapkan dulu environment di MacOS seperti:

1. Installing Git SCM
2. Setup Terminal
3. Git initialization config

Ok langsung aja kita bahas materi yang pertama:

<!--more-->

## Installing Git SCM

There are several options for installing Git on macOS.

1. Package manager, such as (homebrew, macport)
2. Apple binary package, (build-in with Xcode)
3. Binary installer
4. Building from source

Sedangkan saya sendiri menggunakan Apple binary package dengan menggunakan perintah:

{% highlight bash %}
xcode-select --install
{% endhighlight %}

Setelah itu nanti akan muncul dialog seperti berikut yang kita execute di Terminal:

![Install dialog]({{ page.image_path | prepend: site.baseurl }}/01-install-dialog.png)

Kemudian muncul dialog aggrement to install commandline tools for developer, pilih Yes setelah itu akan mendownload softwarenya seperti berikut:

![download commandline tools]({{ page.image_path | prepend: site.baseurl }}/02-install-commandline.png)

Karena proses download & installasi lumayan lama, jadi monggo sambil ngopi atau santai dulu ja... :), jika sudah selesai seperti berikut:

![installing done]({{ page.image_path | prepend: site.baseurl }}/03-installing-done.png)

Sekarang kita bisa check di terminal apakah git sudah terinstall dengan menggunakan perintah seperti berikut:

{% highlight bash %}
git version
{% endhighlight %}

Jika sudah maka outputnya seperti berikut:

![git version apple]({{ page.image_path | prepend: site.baseurl }}/04-git-version.png)

## Setup Terminal for using Git

Setelah kita menginstall Git di local machine kita, sebelum kita menggunakan Git kita akan setup dulu commandline / terminal supaya lebih nyaman dan menyenangkan menggunakannya. Adapun yang perlu kita lakukan adalah:

1. Setup terminal application
2. Setup [oh-my-zsh](https://ohmyz.sh)
3. Install & setup package manager seperti [homebrew](https://brew.sh), portmac dan lainnya
4. Install commandline editor seperti `vim`, `nano`, `tmux`, dan lain-lain.

Ok untuk terminal application yang saya gunakan adalah [iTerm2](https://iterm2.com), iTerm2 is a replacement for Terminal and the successor to iTerm.  

![terminal application]({{ page.image_path | prepend: site.baseurl }}/05-iterm2.png)

iTerm2 brings the terminal into the modern age with features you never knew you always wanted. Ada banyak sekali feature yang bisa kita gunakan di iTerm2 seperti

1. Split Panes
2. Hotkey Windows
3. Search
4. Autocomplate
5. Copy Mode
6. Paste history
7. dan lain-lain.

Untuk shell dan theme yang terdapat pada iTerm2 tersebut adalah [oh-my-zsh](https://ohmyz.sh). Dengan menggunakan oh-my-zsh kita bisa menambahkan plugin special untuk git dengan menggunakan command seperti berikut:

{% highlight bash %}
# to see list all git plugins availables
omz plugin list | grep git

# to enabled it
omz plugin enable  git git-extras git-flow gitignore
{% endhighlight %}

Kemudian yang terakhir yang kita butuhkan adalah text editor via terminal seperti vim, atau nano. Untuk package tersebut kita bisa install menggunakan package manager seperti 

{% highlight bash %}
brew install vim tmux curl wget
{% endhighlight %}

## Git initialization config