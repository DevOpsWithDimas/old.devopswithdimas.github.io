---
layout: post
title: "Get started with Docker Compose"
date: 2021-08-11T08:15:45+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
refs: 
- https://docs.docker.com/compose/install/
- https://docs.docker.com/compose/completion/
- https://docs.docker.com/compose/gettingstarted/
youtube: C5BYAkbFPvs
comments: true
image_path: /resources/posts/docker/09a-compose-getting-started
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya, di materi kali ini kita akan membahas untuk memulai menggunakan Docker compose diataranya:

1. Install Compose
2. Command-line completion (Optional for linux & mac)
3. Getting started

## Install docker compose

You can run Compose on macOS, Windows, and 64-bit Linux. Prerequisites:

1. **On desktop systems like Docker Desktop for Mac and Windows**, Docker Compose is included as part of those desktop installs.
2. **On Linux systems**, first install the Docker Engine for your OS as described on the Get Docker page, then come back here for instructions on installing Compose on Linux systems.

For installing docker-compose on linux

{% gist page.gist "09a-install-compose-linux.bash" %}

Setelah kita install kita bisa coba test, menggunakan perintah seperti berikut:

{% highlight bash %}
docker-compose -v
{% endhighlight %}

## Command-line completion

Compose comes with command completion for the bash and zsh shell.

### Using Bash

For Linux:

{% gist page.gist "09a-install-cli-completion-for-linux.bash" %}

For Mac:

{% gist page.gist "09a-install-cli-completion-for-mac.bash" %}

then add the following to your `~/.bash_profile`:

{% gist page.gist "09a-mac-bash-profile" %}

### Using Zsh

Make sure you have installed [oh-my-zsh](https://ohmyz.sh/) on your computer. Add `docker` and `docker-compose` to the plugins list in `~/.zshrc` to run autocompletion within the oh-my-zsh shell.

{% gist page.gist "09a-zshrc-docker-plugin" %}

## Getting started

Untuk memulai kita akan membuat container menggunakan Docker compose, sebagai contoh menjalankan image `nginx` dan `postgresql` secara bersamaan. Tahapnya adalah

1. Buat file dengan nama `docker-compose.yaml` seperti berikut:

    {% gist page.gist "09a-docker-compose.yaml" %}

2. Kemudian jalankan containernya dengan menggunakan perintah seperti berikut:

    {% gist page.gist "09a-docker-compose-up.bash" %}

3. Jika sudah kita bisa stop containernya dengan menggunakan perintah seperti berikut:

    {% gist page.gist "09a-docker-compose-down.bash" %}

Jika di jalankan maka outputnya seperti berikut:

```powershell
➜ 09-docker-compose  docker-compose pull
Pulling webapp ... done
Pulling db     ... done

➜ 09-docker-compose  docker-compose up -d
Creating 09-docker-compose_webapp_1 ... done
Creating 09-docker-compose_db_1     ... done

➜ 09-docker-compose  docker-compose ps
           Name                         Command               State                    Ports
--------------------------------------------------------------------------------------------------------------
09-docker-compose_db_1       docker-entrypoint.sh postgres    Up      0.0.0.0:5432->5432/tcp,:::5432->5432/tcp
09-docker-compose_webapp_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:80->80/tcp,:::80->80/tcp

➜ 09-docker-compose  curl localhost


StatusCode        : 200
StatusDescription : OK
Content           : <!DOCTYPE html>
                    <...
RawContent        : HTTP/1.1 200 OK
                    Connection: keep-alive
                    Accept-Ranges: bytes
                    Content-Length: 612
                    Content-Type: text/html
                    Date: Wed, 11 Aug 2021 01:13:48 GMT
                    ETag: "60e46fc5-264"
                    Last-Modified: Tue, 06 Jul 2021 ...
Headers           : {[Connection, keep-alive], [Accept-Ranges, bytes], [Content-Length, 612], [Content-Type,
                    text/html]...}
ParsedHtml        : System.__ComObject
RawContentLength  : 612

➜ 09-docker-compose  docker-compose down
Stopping 09-docker-compose_webapp_1 ... done
Stopping 09-docker-compose_db_1     ... done
Removing 09-docker-compose_webapp_1 ... done
Removing 09-docker-compose_db_1     ... done
Removing network 09-docker-compose_default
```

## Conclusion

Jadi dengan menggunakan `docker-compose` kita bisa mempersingkat dan mendokumentasikan perintah yang kita jalankan, jika kita menggunakan `docker` command seperti biasa maka sama seperti kita menulis seperti berikut:

{% gist page.gist "09a-docker-command-eq.bash" %}