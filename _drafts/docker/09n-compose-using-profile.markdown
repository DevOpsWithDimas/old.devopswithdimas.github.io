---
layout: post
title: "Using profiles with Compose file"
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
3. Auto-enabling profiles and dependency resolution

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

```powershell
## default profile
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p default up -d
Creating network "default_default" with the default driver
Creating default_db_1 ... done
Creating default_backend_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p default ps
      Name                     Command               State                  Ports
-------------------------------------------------------------------------------------------------
default_backend_1   docker-php-entrypoint apac ...   Up      0.0.0.0:8080->80/tcp,:::8080->80/tcp
default_db_1        docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p default down
Stopping default_backend_1 ... done
Stopping default_db_1      ... done
Removing default_backend_1 ... done
Removing default_db_1      ... done
Removing network default_default
Removing volume default_mysql_data

## debug profile enabled
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-mode --profile debug up -d
Creating network "debug-mode_default" with the default driver
Creating volume "debug-mode_mysql_data" with default driver
Creating debug-mode_db_1 ... done
Creating debug-mode_phpmyadmin_1 ... done
Creating debug-mode_backend_1    ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-mode --profile debug ps
         Name                        Command               State               Ports
-------------------------------------------------------------------------------------------------
debug-mode_backend_1      docker-php-entrypoint apac ...   Up      0.0.0.0:8080->80/tcp,:::8080->
                                                                   80/tcp
debug-mode_db_1           docker-entrypoint.sh mysqld      Up      3306/tcp, 33060/tcp
debug-mode_phpmyadmin_1   /docker-entrypoint.sh apac ...   Up      0.0.0.0:33306->80/tcp,:::33306
                                                                   ->80/tcp
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-mode --profile debug down --volumes
Stopping debug-mode_phpmyadmin_1 ... done
Stopping debug-mode_backend_1    ... done
Stopping debug-mode_db_1         ... done
Removing debug-mode_phpmyadmin_1 ... done
Removing debug-mode_backend_1    ... done
Removing debug-mode_db_1         ... done
Removing network debug-mode_default
Removing volume debug-mode_mysql_data

## debug & dev mode profile enabled using --profile
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-dev-mode --profile debug --profile dev up -d
Creating network "debug-dev-mode_default" with the default driver
Creating volume "debug-dev-mode_mysql_data" with default driver
Creating debug-dev-mode_db_1 ... done
Creating debug-dev-mode_migrate-tools_1 ... done
Creating debug-dev-mode_phpmyadmin_1    ... done
Creating debug-dev-mode_backend_1       ... done
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-dev-mode --profile debug --profile dev ps
            Name                         Command             State               Ports
-------------------------------------------------------------------------------------------------
debug-dev-mode_backend_1       docker-php-entrypoint apac    Up       0.0.0.0:8080->80/tcp,:::808
                               ...                                    0->80/tcp
debug-dev-mode_db_1            docker-entrypoint.sh mysqld   Up       3306/tcp, 33060/tcp
debug-dev-mode_migrate-        flyway -user=perpus -passw    Exit 1
tools_1                        ...
debug-dev-mode_phpmyadmin_1    /docker-entrypoint.sh apac    Up       0.0.0.0:33306->80/tcp,:::33
                               ...                                    306->80/tcp
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-dev-mode --profile debug --profile dev down --volumes
Stopping debug-dev-mode_backend_1    ... done
Stopping debug-dev-mode_phpmyadmin_1 ... done
Stopping debug-dev-mode_db_1         ... done
Removing debug-dev-mode_backend_1       ... done
Removing debug-dev-mode_phpmyadmin_1    ... done
Removing debug-dev-mode_migrate-tools_1 ... done
Removing debug-dev-mode_db_1            ... done
Removing network debug-dev-mode_default
Removing volume debug-dev-mode_mysql_data

## debug & dev mode profile enabled using COMPOSE_PROFILE env variable
➜ docker  $env:COMPOSE_PROFILES="debug,dev"
➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-dev-mode up -d
debug-dev-mode_db_1 is up-to-date
debug-dev-mode_backend_1 is up-to-date
Creating debug-dev-mode_phpmyadmin_1    ... done
Creating debug-dev-mode_migrate-tools_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-dev-mode ps
            Name                         Command             State               Ports
-------------------------------------------------------------------------------------------------
debug-dev-mode_backend_1       docker-php-entrypoint apac    Up       0.0.0.0:8080->80/tcp,:::808
                               ...                                    0->80/tcp
debug-dev-mode_db_1            docker-entrypoint.sh mysqld   Up       3306/tcp, 33060/tcp
debug-dev-mode_migrate-        flyway -user=perpus -passw    Exit 0
tools_1                        ...
debug-dev-mode_phpmyadmin_1    /docker-entrypoint.sh apac    Up       0.0.0.0:33306->80/tcp,:::33
                               ...                                    306->80/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\assign-profile.docker-compose.yaml -p debug-dev-mode down
Stopping debug-dev-mode_phpmyadmin_1 ... done
Stopping debug-dev-mode_backend_1    ... done
Stopping debug-dev-mode_db_1         ... done
Removing debug-dev-mode_migrate-tools_1 ... done
Removing debug-dev-mode_phpmyadmin_1    ... done
Removing debug-dev-mode_backend_1       ... done
Removing debug-dev-mode_db_1            ... done
Removing network debug-dev-mode_default
Removing volume debug-dev-mode_mysql_data

➜ docker  Remove-Item Env:COMPOSE_PROFILES
```

## Auto-enabling profiles and dependency resolution

When a service with assigned `profiles` is explicitly targeted on the command line its profiles will be enabled automatically so you don’t need to enable them manually. This can be used for one-off services and debugging tools. As an example consider this configuration:

{% gist page.gist "09n-implicit-profile.docker-compose.yaml" %}

Jika kita jalankan maka hasilnya seperti berikut:

```powershell
# will only start only db
➜ docker  docker-compose -f .\09-docker-compose\profiles\implicit-profile.docker-compose.yaml -p default up -d
Creating network "default_default" with the default driver
Creating volume "default_mysql_data" with default driver
Creating default_db_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\implicit-profile.docker-compose.yaml -p default ps
    Name                 Command             State          Ports
------------------------------------------------------------------------
default_db_1   docker-entrypoint.sh mysqld   Up      3306/tcp, 33060/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\implicit-profile.docker-compose.yaml -p default down --volumes
Stopping default_db_1 ... done
Removing default_db_1 ... done
Removing network default_default
Removing volume default_mysql_data

# this will run phpmyadmin (and - if necessary - start db)
# by implicitly enabling profile `debug`
➜ docker  docker-compose -f .\09-docker-compose\profiles\implicit-profile.docker-compose.yaml -p implicit-enabled up -d phpmyadmin
Creating network "implicit-enabled_default" with the default driver
Creating volume "implicit-enabled_mysql_data" with default driver
Creating implicit-enabled_db_1 ... done
Creating implicit-enabled_phpmyadmin_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\implicit-profile.docker-compose.yaml -p implicit-enabled ps
           Name                       Command             State             Ports
-------------------------------------------------------------------------------------------
implicit-enabled_db_1        docker-entrypoint.sh         Up      3306/tcp, 33060/tcp
                             mysqld
implicit-                    /docker-entrypoint.sh apac   Up      0.0.0.0:33306->80/tcp,:::
enabled_phpmyadmin_1         ...                                  33306->80/tcp1

➜ docker  docker-compose -f .\09-docker-compose\profiles\implicit-profile.docker-compose.yaml -p implicit-enabled down --volumes
Stopping implicit-enabled_phpmyadmin_1 ... done
Stopping implicit-enabled_db_1         ... done
Removing implicit-enabled_phpmyadmin_1 ... done
Removing implicit-enabled_db_1         ... done
Removing network implicit-enabled_default
Removing volume implicit-enabled_mysql_data
```

But keep in mind that `docker-compose` will only **automatically enable the profiles of the services on the command line and not of any dependencies**. This means that all services the targeted service `depends_on` must have a common profile with it, be always enabled (by omitting profiles) or have a matching profile enabled explicitly:

{% gist page.gist "09n-explicit-profile.docker-compose.yaml" %}

Jika dijalankan maka hasilnya seperti berikut:


```powershell
# will only start "db"
➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p default up -d
Creating network "default_default" with the default driver
Creating volume "default_mysql_data" with default driver
Creating default_db_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p default ps
    Name                 Command             State          Ports
------------------------------------------------------------------------
default_db_1   docker-entrypoint.sh mysqld   Up      3306/tcp, 33060/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p default down --volumes
Stopping default_db_1 ... done
Removing default_db_1 ... done
Removing network default_default
Removing volume default_mysql_data

# this will start phpmyadmin (and - if necessary - db)
# by implicitly enabling profile `debug`
➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p debug-mode up -d phpmyadmin
Creating network "debug-mode_default" with the default driver
Creating volume "debug-mode_mysql_data" with default driver
Creating debug-mode_db_1 ... done
Creating debug-mode_phpmyadmin_1 ... done

➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p debug-mode ps
         Name                       Command             State              Ports
-------------------------------------------------------------------------------------------
debug-mode_db_1           docker-entrypoint.sh mysqld   Up      3306/tcp, 33060/tcp
debug-mode_phpmyadmin_1   /docker-entrypoint.sh apac    Up      0.0.0.0:33306->80/tcp,:::33
                          ...                                   306->80/tcp

➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p debug-mode down --volumes
Stopping debug-mode_phpmyadmin_1 ... done
Stopping debug-mode_db_1         ... done
Removing debug-mode_phpmyadmin_1 ... done
Removing debug-mode_db_1         ... done
Removing network debug-mode_default
Removing volume debug-mode_mysql_data

# this will fail because profile "prod" is disabled by migrate-tools
➜ docker  docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p profile-missing up -d backend
Creating network "profile-missing_default" with the default driver
Creating volume "profile-missing_mysql_data" with default driver
ERROR: Service "migrate-tools" was pulled in as a dependency of service "backend" but is not enabled by the active profiles. You may fix this by adding a common profile to "migrate-tools" and "backend".
```

Although targeting `backend` will automatically enable its profiles - i.e. `prod` - it will not automatically enable the profile(s) required by `migrate-tools` - i.e. `dev`. To fix this you either have to add the `dev` profile to the `backend` service:

{% highlight yaml %}
backend:
    image: php:8.0-apache
    ports:
      - 8080:80
    depends_on:
      - db
      - migrate-tools
    profiles: [ "prod", "dev" ]
{% endhighlight %}

or enable a profile of db explicitly:

{% highlight bash %}
docker-compose -f .\09-docker-compose\profiles\explicit-profile.docker-compose.yaml -p debug-mode --profile dev up -d phpmyadmin
{% endhighlight %}