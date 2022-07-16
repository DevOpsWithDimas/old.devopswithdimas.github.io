---
layout: post
title: "How to Install git on MacOS"
date: 2022-07-16T13:08:14+07:00
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
- https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
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

{% highlight bash %}
eval "$(ssh-agent -s)"
{% endhighlight %}

If you're using macOS Sierra 10.12.2 or later, you will need to modify your `~/.ssh/config` file to automatically load keys into the ssh-agent and store passphrases in your keychain. Open your `~/.ssh/config` file, then modify the file to contain the following lines. If your SSH key file has a different name or path than the example code, modify the filename or path to match your current setup.

{% highlight config %}
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
{% endhighlight %}

Then save and exit, after that Add your SSH private key to the ssh-agent

{% highlight bash %}
ssh-add -K ~/.ssh/id_ed25519
{% endhighlight %}

And finaly you can add public key to git repository, But i will do it later on next capter.