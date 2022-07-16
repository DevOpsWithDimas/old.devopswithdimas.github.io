---
layout: post
title: "How to Install git on Windows"
lang: gitlab
authors:
- dimasm93
categories:
- git
- gitops
- gitlab
refs: 
- https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
- https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01b-install-git-windows
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, sebelum kita hand-on menggunakan Git SCM di Windows 10/11 ada beberapa hal yang perlu kita siapkan. Diantaranya

1. Install Git SCM
2. Setup Terminal / Powershell
3. Git initialization config

Ok tanpa berlama-lama. langsung aja kita bahas materi yang pertama:

<!--more-->

## Installing Git SCM

There are several options for installing Git on Windows:

1. Package manager, such as (chocolaty, winget, etc)
2. Binary installer

Untuk saya sendiri meng-install git menggunakan Binary installer. Pertama kita download dulu di official [Git website](https://git-scm.com/download/win). Untuk step-stepnya sama halnya dengan installasi software di Windows seperti berikut:

Kita double klik installer `Git-version.exe` maka akan muncul welcome-page seperti berikut:

![git welcome-page]({{ page.image_path | prepend: site.baseurl }}/01-welcome-page.png)

Kemudian klik Next, maka muncul select directory untuk install git seperti berikut:

![git select-directory]({{ page.image_path | prepend: site.baseurl }}/02-select-directory.png)

Kalau saya biarkan default, kemudian Next. Maka akan muncul component yang akan di install seperti berikut:

![git select-component]({{ page.image_path | prepend: site.baseurl }}/03-select-components.png)

Untuk component yang saya pilih adalah minimal saja seperti `Git Bash Here`, `Gitl LSF`, `Associate git files` dan `Add a git path to Windows Terminal`. Setelah itu kita Next maka akan muncul dialog Start menu seperti berikut:

![git start-menu]({{ page.image_path | prepend: site.baseurl }}/04-select-start-menu.png)

Biarkan default saja, kemudian kita Next maka akan muncul dialog Default text editor seperti berikut:

![git select-editor]({{ page.image_path | prepend: site.baseurl }}/05-select-editor.png)

Untuk editor default git yang saya pilih adalah `Vim`, klo temen-temen terbiasa dengan editor lainnya boleh pilih yang lainnya seperti nodepad, nano ataupun lainnya, Selanjutnya Next akan muncul dialog default branch name seperti berikut:

![git select-branch-name]({{ page.image_path | prepend: site.baseurl }}/06-select-default-branch.png)

Untuk default branch name, saya biarkan default saja kemudian Next maka akan muncul dialog path env pada windows system seperti berikut:

![git select-path-env]({{ page.image_path | prepend: site.baseurl }}/07-select-path-env.png)

pada dialog ini saya menggunakan recommendation dari git atau biarkan saja default kemudian klick Next maka akan muncul dialog SSH Connection settings seperti berikut:

![git select-ssh]({{ page.image_path | prepend: site.baseurl }}/08-select-bundle-ssh.png)

Karena disini saya belum menginstall ssh, kita biarkan menggukan SSH bundle saja kemudian klick Next maka selanjutnya akan muncul dialog openssh setting seperti berikut:

![git select-openssh]({{ page.image_path | prepend: site.baseurl }}/09-select-openssh.png)

Biarkan default saja kemudian kita Next maka selanjutnya akan muncul dialog Commit style seperti berikut:

![git select-commit-style]({{ page.image_path | prepend: site.baseurl }}/10-select-commit-style.png)

Untuk commit style yang perlu diperhatikan adalah bagaimana nantinya temen-temen menggunakan git tersebut apakah menggunakan Powershell style atau unix style klo saya sendiri lebih sering menggunakan unix style jadi saya pilih `checkout as-is, convert to unix-style ending` selanjutnya Next maka muncul dialog Emulator seperti berikut:

![git select-emulator]({{ page.image_path | prepend: site.baseurl }}/11-select-emulator.png)

Biarkan default saja, selanjutnya Next maka akan muncul dialog Default Pull Policy seperti berikut:

![git select-pull-policy]({{ page.image_path | prepend: site.baseurl }}/12-select-default-pull.png)

Biarkan default saja, selanjutnya Next maka akan muncul dialog Credential Manager seperti berikut:

![git select-cred-manager]({{ page.image_path | prepend: site.baseurl }}/13-select-cred-manager.png)

Biarkan default saja, selanjutnya Next maka akan muncul dialog Extra Config seperti berikut:

![git select-extra-config]({{ page.image_path | prepend: site.baseurl }}/14-extra-config.png)

Biarkan default, selanjutnya Next dan yang terakhir akan muncul dialog Experiment Feature seperti berikut:

![git select-experiment-features]({{ page.image_path | prepend: site.baseurl }}/15-experiments-features.png)

Saya saat ini tidak membutuhkan feature tersebut jadi saya gak checklist and Install jika sudah selesai hasilnya seperti berikut:

![git installed]({{ page.image_path | prepend: site.baseurl }}/16-finish.png)

Sekarang kita bisa check menggunakan Windows terminal atau powershell apakah gitnya sudah terdeteksi pada system dengan perintah 

{% highlight powershell %}
git -v
{% endhighlight %}

Maka hasilnya seperti berikut:

![git installed]({{ page.image_path | prepend: site.baseurl }}/17-git-powershell.png)

## Setup Terminal / Powershell

Setelah kita menginstall Git di local machine kita, sebelum kita menggunakan Git kita akan setup dulu commandline / terminal supaya lebih nyaman dan menyenangkan menggunakannya. Adapun yang perlu kita lakukan adalah:

1. Setup terminal application
2. Setup [oh-my-posh](https://ohmyposh.dev)

Ok, untuk terminal di Windows operation system terdiri dari `cmd`, dan Powershell. Temen-temen boleh bebas pilih kalau saya sendiri lebih sering menggunakan Powershell karena secara perintah lebih mirip UNIX dibandingkan cmd yang pure perintah windows. Untuk Powershell editor sendiri saya biasanya menggunakan [Windows Terminal](https://github.com/microsoft/terminal)

By default Windows Terminal build-in with Windows 11 but in Windows 10 or above you can download from Windows Store. look like:

![windows terminal]({{ page.image_path | prepend: site.baseurl }}/17-git-windows-terminal.png)

Windows Terminal is a new, modern, feature-rich, productive terminal application for command-line users. It includes many of the features most frequently requested by the Windows command-line community including support for tabs, rich text, globalization, configurability, theming & styling, and more.

Sebelum kita setup Windows Terminalnya, kita perlu aktifkan dulu developer mode dan execute any command from powershell seperti berikut:

![windows-dev-mode]({{ page.image_path | prepend: site.baseurl }}/18-developer-mode.png)

Buka Powershell as Adminstrator, jalankan perintah berikut:

{% highlight powershell %}
Set-ExecutionPolicy RemoteSigned | `
Set-ExecutionPolicy Restricted
{% endhighlight %}

Kemudian restart, setelah restart buka kembali Powershell as normal user, kita akan memasang plugin dan theme tersebut dengan perintah seperti berikut:

{% highlight powershell %}
# install git plugin
Install-Module posh-git -Scope CurrentUser

# install oh-my-posh
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))
{% endhighlight %}

Setelah itu kita include ke profile dengan menjalankan perintah `notepad $profile` kemudian masukan script berikut ke notepad:

{% highlight config %}
Import-Module posh-git
oh-my-posh init pwsh --config $env:POSH_THEMES_PATH\robbyrussel.omp.json | Invoke-Expression
{% endhighlight %}

Maka hasil looknya sekarang seperti berikut:

![windows theme oh-my-posh]({{ page.image_path | prepend: site.baseurl }}/19-windows-terminal-git.png)