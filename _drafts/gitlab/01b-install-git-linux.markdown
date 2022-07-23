---
layout: post
title: "How to Install git on Linux"
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
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
youtube: 
comments: true
catalog_key: introduction
image_path: /resources/posts/git/01b-install-git-linux
gist: dimMaryanto93/8f9f0ba4caf5a28c56111246499e97d0
downloads: []
---

Hai semuanya, sebelum kita hand-on menggunakan Git SCM di Linux ada beberapa hal yang perlu kita siapkan. Diantaranya

1. Install Git SCM
2. Setup Terminal
3. Git initialization config

Ok tanpa berlama-lama. langsung saja kita bahas materi yang pertama:

<!--more-->

## Install Git SCM

There are several options for installing Git on Linux distribution:

1. Package manager, such as (apt, yum, zyper,etc)
2. Binary installer
3. Build from source

Untuk saya sendiri meng-install git menggunakan package manager. Karena saya di sini menggunakan Ubuntu Desktop v22.04 Unity. Untuk step-by-stepnya simple sekali, kita buka Terminal dan menggunakan command seperti berikut:

{% highlight bash %}
apt-get update && \
apt-get install git vim tmux -y
{% endhighlight %}

Jika sudah, temen-temen bisa check menggunakan perintah seperti berikut

{% highlight bash %}
git version
{% endhighlight %}

## Setup Terminal

Setelah kita menginstall Git di local machine kita, sebelum kita menggunakan Git kita akan setup dulu commandline / terminal supaya lebih nyaman dan menyenangkan menggunakannya. Adapun yang perlu kita lakukan adalah:

1. Setup terminal application
2. Install & Setup oh-my-zsh
3. Install tools yang berguna seperti `curl`, `wget`.

Untuk terminal aplikasinya sendiri kami menggunakan default `Terminal` jadi secara feature pun gak aneh-aneh tapi juga cukup powerfull untuk pengguna linux sendiri. Nah sekarang kita akan setup Aplikasi Terminal ini supaya lebih powerfull lagi yaitu menggunakan theme dan plugin dari [oh-my-zsh](https://ohmyz.sh/)

{% highlight bash %}
# install zsh engine
sudo apt-get install zsh curl wget

# download theme and plugins
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# set default to zsh
chsh -s $(which zsh)
{% endhighlight %}

Setelah itu temen-temen bisa logout dulu dari session, setelah itu login lagi supaya theme berubah menjadi `zsh` bukan `bash` atau `shell`.

Setelah temen-temen install kita bisa setting themenya dan pluginnya dengan menggunakan perintah:

{% highlight bash %}
# set theme to minimal
omz theme set minimal

# to see list all git plugins availables
omz plugin list | grep git

# to enabled it
omz plugin enable git git-extras git-flow gitignore
{% endhighlight %}

Nah sekarang kalo kita lihat tampilan theme seperti berikut

![terminal oh-my-zsh]({{ page.image_path | prepend: site.baseurl }}/01-ohmyzsh-theme-minimal.jpg)

## Git initialization config

Setelah kita setup terminal / commandline tools untuk berinteraksi dengan Git, Sebelum mulai ada beberapa hal yang perlu kita setting/config pada internal git seperti

1. Setup your identity (username & email)
2. Setup default editor
3. Setup default branch pada git
4. Setup generate ssh key untuk ssh-connection to git repository

Git comes with a tool called `git config` that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

1. `[path]/etc/gitconfig` file: Contains values applied to every user on the system and all their repositories. If you pass the option `--system` to `git config`, it reads and writes from this file specifically. Because this is a system configuration file, you would need administrative or superuser privilege to make changes to it.
2. `~/.gitconfig` or `~/.config/git/config` file: Values specific personally to you, the user. You can make Git read and write to this file specifically by passing the `--global` option, and this affects all of the repositories you work with on your system.
3. `config` file in the Git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. You can force Git to read from and write to this file with the `--local option`, but that is in fact the default. Unsurprisingly, you need to be located somewhere in a Git repository for this option to work properly.

{% highlight bash %}
# set your username & email
git config --global user.name "dimasm93"
git config --global user.email "software.dimas_m@icloud.com"

# set your default editor
git config --global core.editor vim

# set default branch name is main
git config --global init.defaultBranch main

# check all config
git config --list
{% endhighlight %}

Dan kemudian yang terakhir, kita akan setup untuk generate ssh key jika kita mau menggunakan ssh connection ke git repository seperti GitHub, Gitlab, Bitbucket atau hosted repository lainnya dengan cara seperti berikut:

{% highlight bash %}
ssh-keygen -t ed25519 -C "your_email@example.com"
{% endhighlight %}

This creates a new SSH key, using the provided email as a label. 

1. When you're prompted to "Enter a file in which to save the key," press Enter. This accepts the default file location.
2. At the prompt, type a secure passphrase.
3. Adding your SSH key to the ssh-agent
4. Add your SSH private key to the ssh-agent and store your passphrase in the keychain.

Start the ssh-agent in the background.

{% highlight bash %}
eval "$(ssh-agent -s)"
{% endhighlight %}

after that Add your SSH private key to the ssh-agent

{% highlight bash %}
ssh-add ~/.ssh/id_ed25519
{% endhighlight %}

And finaly you can add public key to git repository, But i will do it later on next capter.