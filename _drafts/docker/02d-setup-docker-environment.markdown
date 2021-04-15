---
layout: post
title: "Setup Development Env for Docker"
lang: docker
categories:
- Containerization
- DevOps
- Docker
refs: 
- https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup
- https://ohmyposh.dev/docs/themes/
- https://github.com/microsoft/cascadia-code
- https://docs.docker.com/compose/completion/
youtube: 
comments: true
image_path: /resources/posts/docker/02d-setup-env
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas tentang Setup Development Environtment untuk kita belajar Docker, yang akan di bahas diantaranya adalah:

1. Setup Command Prompt, Terminal for Docker
    1. Windows Users
    2. Linux Users
    3. Mac Users
2. Recommendation Text Editor for docker

<!--more-->

## Setup Command prompt for windows user

Untuk windows user kita bisa menggunakan `cmd.exe` atau `powershell.exe` tapi disini saya mau menggunakan [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701) yang bisa di install melalui Microsoft Store.

Dengan default settings seperti berikut:

{% gist page.gist "02d-windows-terminal-setting.json" %}

Dengan setting di atas, saya menggunakan PowerShell sebagai default command line dalam belajar docker. Selain itu juga kita bisa pasang plugin seperti:

1. [Powerline Theme for PowerShell](https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup)
2. [Font Cascadia Code](https://github.com/microsoft/cascadia-code)
3. [Auto Compleation for docker command](https://github.com/samneirinck/posh-docker)

Buka Powershell, kita akan memasang plugin tersebut dengan perintah seperti berikut:

{% gist page.gist "02d-powershell-install-plugin.powershell" %}

Setelah itu kita include ke profile dengan menjalankan perintah `notepad $profile` kemudian masukan script berikut ke notepad: 

{% gist page.gist "02d-powershell-include.config" %}

Maka hasilnya seperti berikut:

![windows terminal]({{ page.image_path | prepand: site.baseurl }}/windows-terminal-docker.gif)

## Setup Terminal for linux

Untuk linux user, kita bisa menggunakan Terminal bawaan OS dan juga kita bisa install plugin

1. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
2. [Docker Command-line completion](https://docs.docker.com/compose/completion/)

## Setup Terminal for Mac

Untuk mac user, kita bisa menggunakan Terminal bawaan OS atau aplikasi external seperti `iTerm2` dan juga plugin seperti berikut

1. [iTerm2](https://iterm2.com/)
2. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
3. [Docker Command-line completion](https://docs.docker.com/compose/completion/)