---
layout: post
title: "Install docker-machine on MacOS"
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Machine
refs: 
- https://github.com/docker/machine/blob/docs/docs/install-machine.md
youtube: 
comments: true
catalog_key: docker-machine
image_path: /resources/posts/docker/13a-docker-machine-mac
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya, di materi kali ini kita akan membahas Install docker-machine di MacOS dengan architecture processor Intel, unfortunately saat ini karena `docker-machine` sudah deprecated jadi belum ada support untuk Apple silicon tpi tenang nanti kita bahas alternative lainnya ya. Materi yang dibahas kali ini diantaranya:

1. Install docker-machine binary
2. Install VirtualBox as backend
3. Create and run a Docker host using VirtualBox provider
4. Troubleshooting

Ok langsung aja kita bahas materi yang pertama

<!--more-->

## Install docker-machine binary

n OS X and Windows, Machine is installed along with other Docker products when you install the Docker Toolbox / Docker Desktop.

Note: in Docker Desktop version 20.xx drop `docker-machine` from bundle, kita bisa install secara terpisah menggunakan package manager

{% highlight bash %}
brew install docker-machine
{% endhighlight %}

Jika di jalankan hasilnya seperti berikut:

```bash
➜  ~ brew install docker-machine
Warning: docker-machine has been deprecated because it has an archived upstream repository!
==> Downloading https://ghcr.io/v2/homebrew/core/docker-machine/manifests/0.16.2
######################################################################## 100.0%
==> Downloading https://ghcr.io/v2/homebrew/core/docker-machine/blobs/sha256:913
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sh
######################################################################## 100.0%
==> Reinstalling docker-machine
==> Pouring docker-machine--0.16.2.monterey.bottle.tar.gz
==> Caveats
zsh completions have been installed to:
  /usr/local/share/zsh/site-functions

To restart docker-machine after an upgrade:
  brew services restart docker-machine
Or, if you don''t want/need a background service you can just run:
  /usr/local/opt/docker-machine/bin/docker-machine start default
==> Summary
🍺  /usr/local/Cellar/docker-machine/0.16.2: 12 files, 27.4MB
==> Running `brew cleanup docker-machine`...
Disable this behaviour by setting HOMEBREW_NO_INSTALL_CLEANUP.
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`)

➜  ~ docker-machine -v
docker-machine version 0.16.2, build bd45ab13
```

Otherwise, download one of the releases from the [docker/machine release](https://github.com/docker/machine/releases/) page directly.

{% highlight bash %}
export DOCKER_MACHINE_VERSION=v0.16.2
curl -L https://github.com/docker/machine/releases/download/$DOCKER_MACHINE_VERSION/docker-machine-`uname -s`-`uname -m` >/usr/local/bin/docker-machine && \
  chmod +x /usr/local/bin/docker-machine
{% endhighlight %}

## Install VirtualBox as backend

Docker machine membutuhkan backend atau driver untuk virtualization, Ada beberapa driver yang kita bisa gunakan yaitu

1. [Virtualbox (`virtualbox`)](https://github.com/docker/machine/tree/master/drivers/virtualbox)
2. [VMWare Fuction (`vmwarefusion`)](https://github.com/docker/machine/tree/master/drivers/vmwarefusion)

ang telah saya test dan juga work well yaitu `virtualbox` jadi kita akan menggunakan VirtualBox ya sebagai drivernya. Untuk menginstall virtualbox di MacOS kita bisa pake package manager seperti `brew`, `macport` dan lain-lain

{% highlight bash %}
brew install virtualbox
{% endhighlight %}

Jika kita jalankan maka hasilnya seperti berikut:

```bash
➜  ~ brew reinstall virtualbox
==> Caveats
virtualbox requires a kernel extension to work.
If the installation fails, retry after you enable it in:
  System Preferences → Security & Privacy → General

For more information, refer to vendor documentation or this Apple Technical Note:
  https://developer.apple.com/library/content/technotes/tn2459/_index.html

==> Downloading https://download.virtualbox.org/virtualbox/6.1.32/VirtualBox-6.1
Already downloaded: /Users/dimasm93/Library/Caches/Homebrew/downloads/27dcc52623cd4b30f7ff19214f02f8a6bdc4514593de31e2fe271f096d788190--VirtualBox-6.1.32-149290-OSX.dmg
==> Uninstalling Cask virtualbox
==> Running uninstall script VirtualBox_Uninstall.tool

Welcome to the VirtualBox uninstaller script.

Executing: /usr/bin/kmutil showloaded --list-only --bundle-identifier org.virtualbox.kext.VBoxUSB
No variant specified, falling back to release
Executing: /usr/bin/kmutil showloaded --list-only --bundle-identifier org.virtualbox.kext.VBoxNetFlt
No variant specified, falling back to release
Executing: /usr/bin/kmutil showloaded --list-only --bundle-identifier org.virtualbox.kext.VBoxNetAdp
No variant specified, falling back to release
Executing: /usr/bin/kmutil showloaded --list-only --bundle-identifier org.virtualbox.kext.VBoxDrv
No variant specified, falling back to release
The following files and directories (bundles) will be removed:
    /Users/dimasm93/Library/LaunchAgents/org.virtualbox.vboxwebsrv.plist
    /usr/local/bin/VirtualBox
    /usr/local/bin/VirtualBoxVM
    /usr/local/bin/VBoxManage
    /usr/local/bin/VBoxVRDP
    /usr/local/bin/VBoxHeadless
    /usr/local/bin/vboxwebsrv
    /usr/local/bin/VBoxBugReport
    /usr/local/bin/VBoxBalloonCtrl
    /usr/local/bin/VBoxAutostart
    /usr/local/bin/VBoxDTrace
    /usr/local/bin/vbox-img
    /Library/LaunchDaemons/org.virtualbox.startup.plist
    /Library/Application Support/VirtualBox/LaunchDaemons/
    /Library/Application Support/VirtualBox/VBoxDrv.kext/
    /Library/Application Support/VirtualBox/VBoxUSB.kext/
    /Library/Application Support/VirtualBox/VBoxNetFlt.kext/
    /Library/Application Support/VirtualBox/VBoxNetAdp.kext/
    /Applications/VirtualBox.app/

And the following KEXTs will be unloaded:
    org.virtualbox.kext.VBoxUSB
    org.virtualbox.kext.VBoxNetFlt
    org.virtualbox.kext.VBoxNetAdp
    org.virtualbox.kext.VBoxDrv

And the traces of following packages will be removed:
    org.virtualbox.pkg.vboxkexts
    org.virtualbox.pkg.virtualbox
    org.virtualbox.pkg.virtualboxcli

The uninstallation processes requires administrative privileges
because some of the installed files cannot be removed by a normal
user. You may be prompted for your password now...

unloading org.virtualbox.kext.VBoxUSB
Executing: /usr/bin/kmutil unload -b org.virtualbox.kext.VBoxUSB
unloading org.virtualbox.kext.VBoxNetFlt
Executing: /usr/bin/kmutil unload -b org.virtualbox.kext.VBoxNetFlt
unloading org.virtualbox.kext.VBoxNetAdp
Executing: /usr/bin/kmutil unload -b org.virtualbox.kext.VBoxNetAdp
unloading org.virtualbox.kext.VBoxDrv
Executing: /usr/bin/kmutil unload -b org.virtualbox.kext.VBoxDrv
Successfully unloaded VirtualBox kernel extensions.
Forgot package 'org.virtualbox.pkg.vboxkexts' on '/'.
Forgot package 'org.virtualbox.pkg.virtualbox' on '/'.
Forgot package 'org.virtualbox.pkg.virtualboxcli' on '/'.
Done.
==> Uninstalling packages; your password may be necessary:
==> Removing files:
/usr/local/bin/vboximg-mount
==> Purging files for version 6.1.32,149290 of Cask virtualbox
==> Installing Cask virtualbox
==> Running installer for virtualbox; your password may be necessary.
Package installers may write to any location; options such as `--appdir` are ignored.
installer: Package name is Oracle VM VirtualBox
installer: choices changes file '/private/tmp/choices20220401-36013-1y7lv1t.xml' applied
installer: Installing at base path /
installer: The install was successful.
==> Changing ownership of paths required by virtualbox; your password may be nec
🍺  virtualbox was successfully installed!
```