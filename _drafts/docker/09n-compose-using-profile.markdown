---
layout: post
title: "Using profiles with Compose"
lang: docker
categories:
- DevOps
- Docker
- Compose
refs: 
- https://docs.docker.com/compose/profiles/
youtube: 
comments: true
image_path: /resources/posts/docker/09d-compose-using-profile
gist: dimMaryanto93/d92bd18da1c73c230d7762361f738524
downloads: []
---


Hai semuanya di materi kali ini kita akan membahas tentang profiles pada compose file. Diantaranya 

1. What is profiles?
2. Assigning profiles to services
3. Enabling profiles
4. Auto-enabling profiles and dependency resolution

Ok langsung aja kita ke pembahasan yang pertama 

## What is profiles

Profiles allow adjusting the Compose application model for various usages and environments by selectively enabling services. This is achieved by assigning each service to zero or more profiles. If unassigned, the service is always started but if assigned, it is only started if the profile is activated.

This allows one to define additional services in a single `docker-compose.yml` file that should only be started in specific scenarios, e.g. for debugging or development tasks.

Valid profile names follow the regex format of `[a-zA-Z0-9][a-zA-Z0-9_.-]+`:

1. Diawali dengan huruf (in-case-sensitive), dan angka
2. Sisannya yang boleh hanya huruf (ignore-case), angka, underscore (`_`), titik (`.`) dan dash (`-`). 

Basic of usage profile, here are example of `docker-compose.yaml`:

{% gist page.gist "09n-basic-profile.docker-compose.yaml" %}

Berikut adalah `.env` file:

{% gist page.gist "09n-basic-profile.dotenv" %}

Sekarang kita coba jalankan dengan perintah berikut:

{% highlight bash %}
docker-compose -f docker-compose --profile debug -p myapp up -d
{% endhighlight %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ docker  docker-compose -f .\09-docker-compose\profiles\basic-profile.docker-compose.yaml -p default-profile up -d
Creating network "default-profile_default" with the default driver
Creating volume "default-profile_mysql_data" with default driver
Creating default-profile_db_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\basic-profile.docker-compose.yaml -p default-profile ps
        Name                     Command             State          Ports
--------------------------------------------------------------------------------
default-profile_db_1   docker-entrypoint.sh mysqld   Up      3306/tcp, 33060/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\basic-profile.docker-compose.yaml -p default-profile down --volumes
Stopping default-profile_db_1 ... done
Removing default-profile_db_1 ... done
Removing network default-profile_default
Removing volume default-profile_mysql_data

➜ docker  docker-compose -f .\09-docker-compose\profiles\basic-profile.docker-compose.yaml -p debug-profile --profile debug up -d
Creating network "debug-profile_default" with the default driver
Creating volume "debug-profile_mysql_data" with default driver
Creating debug-profile_db_1 ... done
Creating debug-profile_phpmyadmin_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\basic-profile.docker-compose.yaml -p debug-profile --profile debug ps
           Name                         Command               State                   Ports
------------------------------------------------------------------------------------------------------------
debug-profile_db_1           docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
debug-profile_phpmyadmin_1   /docker-entrypoint.sh apac ...   Up      0.0.0.0:33306->80/tcp,:::33306->80/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\basic-profile.docker-compose.yaml -p debug-profile --profile debug down --volumes
Stopping debug-profile_phpmyadmin_1 ... done
Stopping debug-profile_db_1         ... done
Removing debug-profile_phpmyadmin_1 ... done
Removing debug-profile_db_1         ... done
Removing network debug-profile_default
Removing volume debug-profile_mysql_data
```

## Assigning profiles to services

Services are associated with profiles through the `profiles` attribute which takes an array of profile names:

{% gist page.gist "09n-assign-profile.docker-compose.yaml" %}

Here the services `webapp` and `phpmyadmin` are assigned to the profiles `frontend` and `debug` respectively and as such are only started when their respective profiles are enabled.

Services without a profiles attribute will always be enabled, i.e. in this case running `docker-compose up` would only start `backend` and `db`.