---
layout: post
title: "Multiple Compose files to Add & Override attribute"
date: 2021-08-31T04:12:07+07:00
lang: docker
categories:
- DevOps
- Docker
- Compose
- Workflows
refs: 
- https://docs.docker.com/compose/extends/
youtube: 
comments: true
image_path: /resources/posts/docker/09e-multiple-compose-files
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---

Hai semuanya di materi kali ini kita akan membahas lebih detail tentang multiple compose files untuk Add & Override attribute

Using multiple Compose files enables you to customize a Compose application for different environments or different workflows. By default, Compose reads two files, a `docker-compose.yml` and an optional `docker-compose.override.yml` file. By convention, the `docker-compose.yml` contains your base configuration. The override file, as its name implies, can contain configuration overrides for existing services or entirely new services.

When you use multiple configuration files, you must make sure all paths in the files are relative to the base Compose file (the first Compose file specified with `-f`). This is required because override files need not be valid Compose files. Override files can contain small fragments of configuration. Tracking which fragment of a service is relative to which path is difficult and confusing, so to keep paths easier to understand, all paths must be defined relative to the base file.

Compose copies configurations from the original service over to the local one. If a configuration option is defined in both the original service and the local service, the local value replaces or extends the original value.

For **single-value options** like `image`, `command` or `mem_limit`, the new value replaces the old value.

berikut adalah `docker-compose.yaml` file:

{% highlight yaml %}
services:
    myservice:
        # ...
        command: python app.py
{% endhighlight %}

berikut adalah `docker-compose.override.yaml` file:

{% highlight yaml %}
services:
    myservice:
        # ...
        command: python otherapp.py
{% endhighlight %}

Ketika dijalankan dengan perintah `docker-compose config` maka hasilnya seperti berikut:

{% highlight yaml %}
services:
    myservice:
        # ...
        command: python otherapp.py
{% endhighlight %}

For the **multi-value options** `ports`, `expose`, `external_links`, `dns`, `dns_search`, and `tmpfs`, Compose concatenates both sets of values:

berikut adalah `docker-compose.yaml` file:

{% highlight yaml %}
services:
  myservice:
    # ...
    ports:
      - "80:80"
{% endhighlight %}

berikut adalah `docker-compose.override.yaml` file:

{% highlight yaml %}
services:
  myservice:
    # ...
    ports:
      - "8000:8000"
{% endhighlight %}

Ketika dijalankan dengan perintah `docker-compose config` maka hasilnya seperti berikut:

{% highlight yaml %}
services:
  myservice:
    # ...
    ports:
      - "8000:8000"
      - "80:80"
{% endhighlight %}

In the case of `environment`, `labels`, `volumes`, and `devices`, Compose “merges” entries together with locally-defined values taking precedence. 

For environment and `labels`, the `environment` variable or **label name determines** which value is used:

berikut adalah `docker-compose.yaml` file:

{% highlight yaml %}
services:
  myservice:
    # ...
    environment:
      - FOO=original
      - BAR=original
{% endhighlight %}

berikut adalah `docker-compose.override.yaml` file:

{% highlight yaml %}
services:
  myservice:
    # ...
    environment:
      - BAR=local
      - BAZ=local
{% endhighlight %}

Ketika dijalankan dengan perintah `docker-compose config` maka hasilnya seperti berikut:

{% highlight yaml %}
services:
  myservice:
    # ...
    environment:
      - FOO=original
      - BAR=local
      - BAZ=local
{% endhighlight %}

Entries for `volumes` and `devices` are merged **using the mount path** in the container:

berikut adalah `docker-compose.yaml` file:

{% highlight yaml %}
services:
  myservice:
    # ...
    volumes:
      - ./original:/foo
      - ./original:/bar
{% endhighlight %}

berikut adalah `docker-compose.override.yaml` file:

{% highlight yaml %}
services:
  myservice:
    # ...
    volumes:
      - ./local:/bar
      - ./local:/baz
{% endhighlight %}

Ketika dijalankan dengan perintah `docker-compose config` maka hasilnya seperti berikut:

{% highlight yaml %}
services:
  myservice:
    # ...
    volumes:
      - ./original:/foo
      - ./local:/bar
      - ./local:/baz
{% endhighlight %}

Berikut contohnya, file `docker-compose.yaml`:

{% gist page.gist "09o-extend.docker-compose.yaml" %}

Serta berikut file `docker-compose.override.yaml`:

{% gist page.gist "090-extend.docker-compose.override.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:

```powershell
➜ docker  cd .\09-docker-compose\extends\diff-envs\
➜ diff-envs  docker-compose config
networks:
  frontend: {}
services:
  webapp:
    build:
      args:
        NGINX_VERSION: mainline
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\extends\diff-envs
      dockerfile: Dockerfile
    environment:
      NGINX_DOMAIN_NAME: dev01.dimas-maryanto.com
      NGINX_PORT: '80'
      NGINX_ROOT_DOCUMENT: /var/www/html
    image: dimmaryanto93/nginx:latest
    networks:
      frontend: {}
    ports:
    - published: 8080
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\extends\diff-envs\html:/usr/share/nginx/html:rw
version: '3.9'

## changed directory to root directory
## override using --project-directory option
➜ diff-envs  cd ../..
➜ docker  docker-compose --project-directory .\09-docker-compose\extends\diff-envs config
networks:
  frontend: {}
services:
  webapp:
    build:
      args:
        NGINX_VERSION: mainline
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\extends\diff-envs
      dockerfile: Dockerfile
    environment:
      NGINX_DOMAIN_NAME: dev01.dimas-maryanto.com
      NGINX_PORT: '80'
      NGINX_ROOT_DOCUMENT: /var/www/html
    image: dimmaryanto93/nginx:latest
    networks:
      frontend: {}
    ports:
    - published: 8080
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\extends\diff-envs\html:/usr/share/nginx/html:rw
version: '3.9'

## override using specify file compose
➜ docker  docker-compose -f .\09-docker-compose\extends\diff-envs\docker-compose.yaml `
>> -f .\09-docker-compose\extends\diff-envs\docker-compose.override.yaml `
>> config
networks:
  frontend: {}
services:
  webapp:
    build:
      args:
        NGINX_VERSION: mainline
      context: C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\extends\diff-envs
      dockerfile: Dockerfile
    environment:
      NGINX_DOMAIN_NAME: dev01.dimas-maryanto.com
      NGINX_PORT: '80'
      NGINX_ROOT_DOCUMENT: /var/www/html
    image: dimmaryanto93/nginx:latest
    networks:
      frontend: {}
    ports:
    - published: 8080
      target: 80
    volumes:
    - C:\Users\dimasm93\Workspaces\youtube\docker\09-docker-compose\extends\diff-envs\html:/usr/share/nginx/html:rw
version: '3.9'
```