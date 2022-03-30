---
layout: post
title: "Build docker image for Angular Project"
date: 2021-07-09T07:13:20+07:00
lang: docker
authors:
- dimasm93
categories:
- DevOps
- Docker
- Dockerfile
- Study-Cases
refs: 
- https://docs.docker.com/
youtube: _EhpssR7izo
comments: true
catalog_key: study-cases-dockerfile
image_path: /resources/posts/docker/08g-angular-project
gist: dimMaryanto93/ff00f4fbaf9d03de33b9a9a1bd159f6a
downloads: []
---


Hai semuanya, di materi kali kita akan membahas tentang Build Docker image untuk salah satu teknologi yang paling sering digunakan pada Frontend Web aplikasi yaitu [Angular](https://angular.io/). Diantaranya yang kita akan bahas yaitu

1. Setup Software Development Kit for Angular Project
2. Create project
3. Setup deployment
4. Build & run docker image
5. Cleanup

## Setup SDK  for Angular Project

Untuk menggunakan angular project, kita memerlukan package dependency management yaitu

1. [nodeJs](https://nodejs.org/en/), kita tidak akan menggunakan nodejs secara langsung tetapi kita menbutuhkannya untuk melakukan compile source angular menjadi PWA (Progressive Web Apps) dan SPA (Single Page Applications).
2. `nvm` adalah Node Version Manager
    - [nvm for windows](https://github.com/coreybutler/nvm-windows), 
    - [nvm for linux/mac](https://github.com/nvm-sh/nvm)
3. [npm](https://www.npmjs.com/), adalah Node Package manager

Untuk menginstall nodeJs dan karena version dari NodeJs itu cepat sekali untuk update-nya serta cepat deprecated jadi kita di sarankan menggunakan [nvm](https://github.com/nvm-sh/nvm) yaitu **NodeJs Version Management** dengan tujuannya supaya kita mudah switch between version nodeJs. Untuk lebih detailnya, berikut saya sudah tulis juga [artilenya](https://www.dimas-maryanto.com/notes/nodejs/nvm-multiple-nodes-version)

```powershell
➜ 08-studi-kasus  nvm version
1.1.7

➜ 08-studi-kasus  nvm list

    16.0.0
    15.0.0
  * 14.15.0 (Currently using 64-bit executable)
    14.0.0

➜ 08-studi-kasus  node -v
v14.15.0

➜ 08-studi-kasus  npm -v
6.14.8
```

Setelah kita menginstall `nvm` dan `nodejs` sekarang kita install package `ng` (Angular CLI) dengan perintah seperti berikut:

{% highlight bash %}
npm install -g @angular/cli
{% endhighlight %}

Selanjutnya setelah kita install Angular CLI, sekarang kita bahas text-editornya. Text editor yang kita bisa gunakan di antaranya:

1. [Webstrom](https://www.jetbrains.com/webstorm/)
2. [Visual Studio Code](https://code.visualstudio.com/)
3. [Atom](atom.io)
4. Dan lain-lain

## Create project angular

Untuk menggunakan perintah angular cli, kita bisa lihat documentasinya dengan perintah berikut:

{% highlight bash %}
ng --help
{% endhighlight %}

Outputnya seperti berikut:

```powershell
➜ 08-studi-kasus  ng version

     _                      _                 ____ _     ___
    / \   _ __   __ _ _   _| | __ _ _ __     / ___| |   |_ _|
   / △ \ | '_ \ / _` | | | | |/ _` | '__|   | |   | |    | |
  / ___ \| | | | (_| | |_| | | (_| | |      | |___| |___ | |
 /_/   \_\_| |_|\__, |\__,_|_|\__,_|_|       \____|_____|___|
                |___/


Angular CLI: 12.1.1
Node: 14.15.0
Package Manager: npm 6.14.8
OS: win32 x64

Angular:
...

Package                      Version
------------------------------------------------------
@angular-devkit/architect    0.1201.1 (cli-only)
@angular-devkit/core         12.1.1 (cli-only)
@angular-devkit/schematics   12.1.1 (cli-only)
@schematics/angular          12.1.1 (cli-only)

➜ 08-studi-kasus  ng help
Available Commands:
  add Adds support for an external library to your project.
  analytics Configures the gathering of Angular CLI usage metrics. See https://angular.io/cli/usage-analytics-gathering.
  build (b) Compiles an Angular app into an output directory named dist/ at the given output path. Must be executed from within a workspace directory.
  deploy Invokes the deploy builder for a specified project or for the default project in the workspace.
  config Retrieves or sets Angular configuration values in the angular.json file for the workspace.
  doc (d) Opens the official Angular documentation (angular.io) in a browser, and searches for a given keyword.
  e2e (e) Builds and serves an Angular app, then runs end-to-end tests.
  extract-i18n (i18n-extract, xi18n) Extracts i18n messages from source code.
  generate (g) Generates and/or modifies files based on a schematic.
  help Lists available commands and their short descriptions.
  lint (l) Runs linting tools on Angular app code in a given project folder.
  new (n) Creates a new workspace and an initial Angular application.
  run Runs an Architect target with an optional custom builder configuration defined in your project.
  serve (s) Builds and serves your app, rebuilding on file changes.
  test (t) Runs unit tests in a project.
  update Updates your application and its dependencies. See https://update.angular.io/
  version (v) Outputs Angular CLI version.

For more detailed help run "ng [command name] --help"

➜ 08-studi-kasus  ng new --help
arguments:
  name
    The name of the new workspace and initial project.

options:
  --collection (-c)
    A collection of schematics to use in generating the initial application.
  --commit
    Initial git repository commit information.
  --create-application
    Create a new initial application project in the 'src' folder of the new workspace. When false, creates an empty workspace with no initial application. You can then use the generate application command so that all applications are created in the projects folder.
  --defaults
    Disable interactive input prompts for options with a default.
  --directory
    The directory name to create the workspace in.
  --dry-run (-d)
    Run through and reports activity without writing out results.
  --force (-f)
    Force overwriting of existing files.
  --help
    Shows a help message for this command in the console.
  --inline-style (-s)
    Include styles inline in the component TS file. By default, an external styles file is created and referenced in the component TypeScript file.
  --inline-template (-t)
    Include template inline in the component TS file. By default, an external template file is created and referenced in the component TypeScript file.
  --interactive
    Enable interactive input prompts.
  --legacy-browsers
    Add support for legacy browsers like Internet Explorer using differential loading.
  --minimal
    Create a workspace without any testing frameworks. (Use for learning purposes only.)
  --new-project-root
    The path where new projects will be created, relative to the new workspace root.
  --package-manager
    The package manager used to install dependencies.
  --prefix (-p)
    The prefix to apply to generated selectors for the initial project.
  --routing
    Generate a routing module for the initial project.
  --skip-git (-g)
    Do not initialize a git repository.
  --skip-install
    Do not install dependency packages.
  --skip-tests (-S)
    Do not generate "spec.ts" test files for the new project.
  --strict
    Creates a workspace with stricter type checking and stricter bundle budgets settings. This setting helps improve maintainability and catch bugs ahead of time. For more information, see https://angular.io/guide/strict-mode
  --style
    The file extension or preprocessor to use for style files.
  --verbose (-v)
    Add more details to output logging.
  --view-encapsulation
    The view encapsulation strategy to use in the initial project.
```

Sekarang kita buat projectnya dengan perintah berikut:

{% highlight bash %}
ng new docker-angular --routing --skip-git --skip-install --style css
{% endhighlight %}

Jika dijalankan maka outputnya seperti berikut:

```powershell
➜ 08-studi-kasus  ng new docker-angular --routing --skip-git --skip-install --style css
CREATE docker-angular/angular.json (3087 bytes)
CREATE docker-angular/package.json (1076 bytes)
CREATE docker-angular/README.md (1059 bytes)
CREATE docker-angular/tsconfig.json (783 bytes)
CREATE docker-angular/.editorconfig (274 bytes)
CREATE docker-angular/.gitignore (604 bytes)
CREATE docker-angular/.browserslistrc (703 bytes)
CREATE docker-angular/karma.conf.js (1431 bytes)
CREATE docker-angular/tsconfig.app.json (287 bytes)
CREATE docker-angular/tsconfig.spec.json (333 bytes)
CREATE docker-angular/src/favicon.ico (948 bytes)
CREATE docker-angular/src/index.html (299 bytes)
CREATE docker-angular/src/main.ts (372 bytes)
CREATE docker-angular/src/polyfills.ts (2820 bytes)
CREATE docker-angular/src/styles.css (80 bytes)
CREATE docker-angular/src/test.ts (743 bytes)
CREATE docker-angular/src/assets/.gitkeep (0 bytes)
CREATE docker-angular/src/environments/environment.prod.ts (51 bytes)
CREATE docker-angular/src/environments/environment.ts (658 bytes)
CREATE docker-angular/src/app/app-routing.module.ts (245 bytes)
CREATE docker-angular/src/app/app.module.ts (393 bytes)
CREATE docker-angular/src/app/app.component.html (24722 bytes)
CREATE docker-angular/src/app/app.component.spec.ts (1081 bytes)
CREATE docker-angular/src/app/app.component.ts (218 bytes)
CREATE docker-angular/src/app/app.component.css (0 bytes)
```

Setelah kita buat, sekarang kita install dependencies-nya menggunakan perintah seperti berikut:

{% highlight bash %}
cd docker-angular; npm install
{% endhighlight %}

Outputnya seperti berikut:

```powershell
➜ 08-studi-kasus  cd .\docker-angular\; npm install
npm WARN deprecated chokidar@2.1.8: Chokidar 2 will break on node v14+. Upgrade to chokidar 3 with 15x less dependencies.
npm WARN deprecated request@2.88.2: request has been deprecated, see https://github.com/request/request/issues/3142
npm WARN deprecated fsevents@1.2.13: fsevents 1 will break on node v14+ and could be using insecure binaries. Upgrade to fsevents 2.
npm WARN deprecated uuid@3.4.0: Please upgrade  to version 7 or higher.  Older versions may use Math.random() in certain circumstances, which is known to be problematic.  See https://v8.dev/blog/math-random for details.
npm WARN deprecated har-validator@5.1.5: this library is no longer supported
npm WARN deprecated querystring@0.2.0: The
npm WARN deprecated urix@0.1.0: Please see https://github.com/lydell/urix#deprecated
npm WARN deprecated resolve-url@0.2.1: https://github.com/lydell/resolve-url#deprecated

> core-js@3.15.1 postinstall C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-angular\node_modules\core-js
> node -e "try{require('./postinstall')}catch(e){}"

Thank you for using core-js ( https://github.com/zloirock/core-js ) for polyfilling JavaScript standard library!

The project needs your help! Please consider supporting of core-js on Open Collective or Patreon:
> https://opencollective.com/core-js
> https://www.patreon.com/zloirock

Also, the author of core-js ( https://github.com/zloirock ) is looking for a good job -)


> @angular/cli@12.1.1 postinstall C:\Users\dimasm93\Workspaces\youtube\docker\08-studi-kasus\docker-angular\node_modules\@angular\cli
> node ./bin/postinstall/script.js

npm notice created a lockfile as package-lock.json. You should commit this file.
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@~2.3.2 (node_modules\chokidar\node_modules\fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@2.3.2: wanted {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})
npm WARN optional SKIPPING OPTIONAL DEPENDENCY: fsevents@^1.2.7 (node_modules\webpack-dev-server\node_modules\chokidar\node_modules\fsevents):
npm WARN notsup SKIPPING OPTIONAL DEPENDENCY: Unsupported platform for fsevents@1.2.13: wanted {"os":"darwin","arch":"any"} (current: {"os":"win32","arch":"x64"})
npm WARN ajv-keywords@3.5.2 requires a peer of ajv@^6.9.1 but none is installed. You must install peer dependencies yourself.

added 1317 packages from 1162 contributors in 48.564s

87 packages are looking for funding
  run `npm fund` for details
```

Setelah kita install, kita bisa jalankan aplikasi development mode. menggunakan perintah:

{% highlight bash %}
ng serve
{% endhighlight %}

Outputnya seperti berikut:

```powershell

➜ docker-angular  ng serve --help
Builds and serves your app, rebuilding on file changes.
usage: ng serve <project> [options]

arguments:
  project
    The name of the project to build. Can be an application or a library.

options:
  --allowed-hosts
    List of hosts that are allowed to access the dev server.
  --aot
    Build using Ahead of Time compilation.
  --base-href
    Base url for the application being built.
  --browser-target
    A browser builder target to serve in the format of `project:target[:configuration]`. You can also pass in more than one configuration name as a comma-separated list. Example: `project:target:production,staging`.
  --common-chunk
    Generate a seperate bundle containing code used across multiple bundles.
  --configuration (-c)
    One or more named builder configurations as a comma-separated list as specified in the "configurations" section of angular.json.
    The builder uses the named configurations to run the given target.
    For more information, see https://angular.io/guide/workspace-config#alternate-build-configurations.
    Setting this explicitly overrides the "--prod" flag.
  --deploy-url
    URL where files will be deployed.
  --disable-host-check
    Don''t verify connected clients are part of allowed hosts.
  --help
    Shows a help message for this command in the console.
  --hmr
    Enable hot module replacement.
  --hmr-warning
    Show a warning when the --hmr option is enabled.
  --host
    Host to listen on.
  --live-reload
    Whether to reload the page on change, using live-reload.
  --open (-o)
    Opens the url in default browser.
  --optimization
    Enables optimization of the build output. Including minification of scripts and styles, tree-shaking, dead-code elimination, tree-shaking and fonts inlining. For more information, see https://angular.io/guide/workspace-config#optimization-configuration.
  --poll
    Enable and define the file watching poll time period in milliseconds.
  --port
    Port to listen on.
  --prod
    Shorthand for "--configuration=production".
    Set the build configuration to the production target.
    By default, the production target is set up in the workspace configuration such that all builds make use of bundling, limited tree-shaking, and also limited dead code elimination.
  --progress
    Log progress to the console while building.
  --proxy-config
    Proxy configuration file. For more information, see https://angular.io/guide/build#proxying-to-a-backend-server.
  --public-host
    The URL that the browser client (or live-reload client, if enabled) should use to connect to the development server. Use for a complex dev server setup, such as one with reverse proxies.
  --serve-path
    The pathname where the app will be served.
  --serve-path-default-warning
    Show a warning when deploy-url/base-href use unsupported serve path values.
  --source-map
    Output source maps for scripts and styles. For more information, see https://angular.io/guide/workspace-config#source-map-configuration.
  --ssl
    Serve using HTTPS.
  --ssl-cert
    SSL certificate to use for serving HTTPS.
  --ssl-key
    SSL key to use for serving HTTPS.
  --vendor-chunk
    Generate a seperate bundle containing only vendor libraries. This option should only used for development.
  --verbose
    Adds more details to output logging.
  --watch
    Rebuild on change.

➜ docker-angular  ng serve --disable-host-check
Warning: Running a server with --disable-host-check is a security risk. See https://medium.com/webpack/webpack-dev-server-middleware-security-issues-1489d950874a for more information.
✔ Browser application bundle generation complete.

Initial Chunk Files   | Names         |      Size
vendor.js             | vendor        |   2.38 MB
polyfills.js          | polyfills     | 508.82 kB
styles.css, styles.js | styles        | 381.01 kB
main.js               | main          |  57.32 kB
runtime.js            | runtime       |   6.58 kB

                      | Initial Total |   3.32 MB

Build at: 2021-07-08T21:28:59.708Z - Hash: 89ee0f7bce17085c8b61 - Time: 4974ms

** Angular Live Development Server is listening on localhost:4200, open your browser on http://localhost:4200/ **


√ Compiled successfully.
```

Hasilnya kita bisa lihat, pada alamat [localhost:4200](http://localhost:4200) seperti berikut:

![first-run]({{ page.image_path | prepend: site.baseurl }}/01-dev-mode.png)

## Setup deployment

Setelah kita membuat project dan berhasil menjalankan untuk development mode, tahap selanjutnya adalah kita setup deploymentnya. 

Untuk mendeploy aplikasi berbase Frontend Web Application kita membutuhkan yang namanya Web Server. Angular project ini pada dasarnya nanti akan di compile menjadi 3 component utama yaitu `html`, `css` dan `js`. Jadi secara minimal kita harus menggunkan yang dapat memproses ke tiga component tersebut. Salah satu Web Server yang popular saat ini adalah

1. [nginx](http://nginx.org/) 
2. [apache2/httpd](https://httpd.apache.org/)

Ok misalnya, studi kasus kali ini akan menggunakan nginx dulu ya. Untuk installnya cukup mudah download binary dari official website atau install melalui repository jika menggunakan linux

For Ubuntu distro

{% highlight bash %}
apt-get install nginx -y && \
systemctl enable --now nginx && \
iptables -I INPUT 1 -i <network-name> -p tcp --dport 80 -j ACCEPT && \
iptables -I INPUT 1 -i <network-name> -p tcp --dport 443 -j ACCEPT && \
{% endhighlight %}

For CentOS 7/8

{% highlight bash %}
yum install -y epel-release && \
yum install -y nginx && \
systemctl enable --now nginx && \
firewall-cmd --zone=public --add-service=http --permanent && \
firewall-cmd --zone=public --add-service=https --permanent && \
firewall-cmd --reload
{% endhighlight %}

For run from binary

{% highlight bash %}
cd nginx-path-binary; ./nginx
{% endhighlight %}

Setelah servicenya started, kita coba akses alamat [localhost:80](http://localhost) hasilnya seperti berikut:

![nginx]({{ page.image_path | prepend: site.baseurl }}/02-nginx.png)

Ok setelah itu, kita deploy source-code kita ke web-service nginx tersebut. caranya pertama kita build dulu dengan menggunakan perintah:

{% highlight bash %}
npm install @angular-devkit/build-angular --save-prod && \
ng build --stats-json --source-map --optimization --common-chunk --build-optimizer --aot
{% endhighlight %}

Berikut outputnya:

```powershell
➜ docker-angular  npm install @angular-devkit/build-angular --save-prod --silent
+ @angular-devkit/build-angular@12.1.1
updated 1 package in 5.979s

29 packages are looking for funding
  run `npm fund` for details

➜ docker-angular  ng build --help
Compiles an Angular app into an output directory named dist/ at the given output path. Must be executed from within a workspace directory.
usage: ng build <project> [options]

arguments:
  project
    The name of the project to build. Can be an application or a library.

options:
  --allowed-common-js-dependencies
    A list of CommonJS packages that are allowed to be used without a build time warning.
  --aot
    Build using Ahead of Time compilation.
  --base-href
    Base url for the application being built.
  --build-optimizer
    Enables '@angular-devkit/build-optimizer' optimizations when using the 'aot' option.
  --common-chunk
    Generate a seperate bundle containing code used across multiple bundles.
  --configuration (-c)
    One or more named builder configurations as a comma-separated list as specified in the "configurations" section of angular.json.
    The builder uses the named configurations to run the given target.
    For more information, see https://angular.io/guide/workspace-config#alternate-build-configurations.
    Setting this explicitly overrides the "--prod" flag.
  --cross-origin
    Define the crossorigin attribute setting of elements that provide CORS support.
  --delete-output-path
    Delete the output path before building.
  --deploy-url
    URL where files will be deployed.
  --extract-css
    Extract CSS from global styles into '.css' files instead of '.js'.
  --extract-licenses
    Extract all licenses in a separate file.
  --help
    Shows a help message for this command in the console.
  --i18n-missing-translation
    How to handle missing translations for i18n.
  --index
    Configures the generation of the application's HTML index.
  --inline-style-language
    The stylesheet language to use for the application's inline component styles.
  --localize
    Translate the bundles in one or more locales.
  --main
    The full path for the main entry point to the app, relative to the current workspace.
  --named-chunks
    Use file name for lazy loaded chunks.
  --ngsw-config-path
    Path to ngsw-config.json.
  --optimization
    Enables optimization of the build output. Including minification of scripts and styles, tree-shaking, dead-code elimination, inlining of critical CSS and fonts inlining. For more information, see https://angular.io/guide/workspace-config#optimization-configuration.
  --output-hashing
    Define the output filename cache-busting hashing mode.
  --output-path
    The full path for the new output directory, relative to the current workspace.

    By default, writes output to a folder named dist/ in the current project.
  --poll
    Enable and define the file watching poll time period in milliseconds.
  --polyfills
    The full path for the polyfills file, relative to the current workspace.
  --preserve-symlinks
    Do not use the real path when resolving modules. If unset then will default to `true` if NodeJS option --preserve-symlinks is set.
  --prod
    Shorthand for "--configuration=production".
    Set the build configuration to the production target.
    By default, the production target is set up in the workspace configuration such that all builds make use of bundling, limited tree-shaking, and also limited dead code elimination.
  --progress
    Log progress to the console while building.
  --resources-output-path
    The path where style resources will be placed, relative to outputPath.
  --service-worker
    Generates a service worker config for production builds.
  --show-circular-dependencies
    Show circular dependency warnings on builds.
  --source-map
    Output source maps for scripts and styles. For more information, see https://angular.io/guide/workspace-config#source-map-configuration.
  --stats-json
    Generates a 'stats.json' file which can be analyzed using tools such as 'webpack-bundle-analyzer'.
  --subresource-integrity
    Enables the use of subresource integrity validation.
  --ts-config
    The full path for the TypeScript configuration file, relative to the current workspace.
  --vendor-chunk
    Generate a seperate bundle containing only vendor libraries. This option should only used for development.
  --verbose
    Adds more details to output logging.
  --watch
    Run build when files change.
  --web-worker-ts-config
    TypeScript configuration for Web Worker modules.

➜ docker-angular  ng build --stats-json --source-map --optimization --common-chunk --build-optimizer --aot
⠋ Generating browser application bundles (phase: setup)...Compiling @angular/core : es2015 as esm2015
Compiling @angular/common : es2015 as esm2015
Compiling @angular/platform-browser : es2015 as esm2015
Compiling @angular/router : es2015 as esm2015
Compiling @angular/platform-browser-dynamic : es2015 as esm2015
✔ Browser application bundle generation complete.
✔ Copying assets complete.
✔ Index html generation complete.

Initial Chunk Files               | Names         |      Size
main.9258bb78f254718a586b.js      | main          | 213.93 kB
polyfills.66a6ee27a5b4801e3d29.js | polyfills     |  36.03 kB
runtime.5694b417c6f4c412fb7a.js   | runtime       |   1.07 kB
styles.31d6cfe0d16ae931b73c.css   | styles        |   0 bytes

                                  | Initial Total | 251.04 kB

Build at: 2021-07-08T22:33:17.219Z - Hash: e3df0ee4d005b7a08316 - Time: 21667ms
```

Sekarang kita pindahkan hasil build yang pada folder `dist` ke root folder nginx.

Root folder pada linux secara default jika menggunakan `/usr/share/nginx/html` tapi untuk menastikan kita bisa check pada `/etc/nginx/nginx.conf` atau `/etc/nginx/conf.d/default.conf`. Karena kita menggunakan binary zip. kita bisa check pada `nginx-install-path/conf/nginx.conf` biasanya menggunakan folder `html`. Kita pindakan semua file yang ada di folder `dist/docker-angular` ke root folder nginx. Jika sudah hasilnya seperti berikut

![angular-deployed]({{ page.image_path | prepend: site.baseurl }}/03-angular-nginx.png)

## Build docker images

Ok setelah kita mengetahui, workflow untuk deploymentnya. sekarang kita buat Docker Imagenya ya, seperti biasa yang kita butuhkan adalah 

1. `Dockerfile`, seperti berikut
    {% gist page.gist "08g-dockerfile" %}
2. `.dockerignore`, seperti berikut:
    {% gist page.gist "08g-dockerignore" %}

Setelah itu kita coba build dengan perintah seperti berikut:

{% gist page.gist "08g-docker-build.bash" %}

Jika dijalankan hasilnya seperti berikut:

```powershell
➜ docker-angular  docker build -t dimmaryanto93/docker-angular:2021.07.09.06.54-release .
[+] Building 93.2s (15/15) FINISHED
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 1.13kB                                                                             0.0s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 34B                                                                                   0.0s
 => [internal] load metadata for docker.io/library/node:14.15-alpine                                               4.8s
 => [internal] load metadata for docker.io/library/nginx:latest                                                    0.0s
 => [auth] library/node:pull token for registry-1.docker.io                                                        0.0s
 => [npm_install 1/5] FROM docker.io/library/node:14.15-alpine@sha256:5edad160011cc8cfb69d990e9ae1cb2681c0f280178  0.0s
 => CACHED [stage-1 1/3] FROM docker.io/library/nginx:latest                                                       0.0s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 2.19kB                                                                                0.0s
 => CACHED [npm_install 2/5] WORKDIR /var/www                                                                      0.0s
 => [npm_install 3/5] COPY . .                                                                                     0.0s
 => [npm_install 4/5] RUN npm install --prod --silent && npm install @angular-devkit/build-angular --silent       60.9s
 => [npm_install 5/5] RUN ./node_modules/@angular/cli/bin/ng build --aot --build-optimizer --common-chunk --opti  27.0s
 => [stage-1 2/3] COPY --from=npm_install /var/www/dist/docker-angular /var/www/html                               0.0s
 => [stage-1 3/3] RUN sed -i 's|/usr/share/nginx/html|/var/www/html|g' /etc/nginx/conf.d/default.conf              0.2s
 => exporting to image                                                                                             0.1s
 => => exporting layers                                                                                            0.1s
 => => writing image sha256:5a455d5e37e3dc69d5b8b82b5b3e81a1249bc2978575d97bc9ab8aed19388e28                       0.0s
 => => naming to docker.io/dimmaryanto93/docker-angular:2021.07.09.06.54-release

➜ docker-angular  docker image inspect dimmaryanto93/docker-angular:2021.07.09.06.54-release
[
    {
        "Id": "sha256:5a455d5e37e3dc69d5b8b82b5b3e81a1249bc2978575d97bc9ab8aed19388e28",
        "RepoTags": [
            "dimmaryanto93/docker-angular:2021.07.09.06.54-release"
        ],
        "Created": "2021-07-08T23:57:05.3086715Z",
        "Author": "",
        "Config": {
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.21.1",
                "NJS_VERSION=0.6.1",
                "PKG_RELEASE=1~buster",
                "APPLICATION_PORT=80"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Healthcheck": {
                "Test": [
                    "CMD-SHELL",
                    "curl -f http://localhost:${APPLICATION_PORT} || exit 1"
                ],
                "Interval": 120000000000,
                "Timeout": 3000000000
            },
            "Image": "",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "MAINTAINER": "Dimas Maryanto <software.dimas_m@icloud.com>",
                "dependency.node.version": "^14.15",
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>",
                "org.framework.name": "angular.io",
                "org.framework.version": "12.1.1"
            },
            "StopSignal": "SIGQUIT"
        },
        "Architecture": "amd64",
        "Os": "linux",
        "Size": 137959273,
        "Metadata": {
            "LastTagTime": "2021-07-08T23:57:05.4052456Z"
        }
    }
]
```

Setelah kita build, sekarang kita jalankan containernya dengan perintah seperti berikut:

For Bash script:

{% gist page.gist "08g-docker-run.bash" %}

For Powershell script:

{% gist page.gist "08g-docker-run.ps1" %}

Hasilnya seperti berikut:

```powershell
➜ docker-angular   docker run `
>>  -p 80:80 `
>>  --name angular-nginx `
>>  -d dimmaryanto93/docker-angular:2021.07.09.06.54-release
ac8f48b7fd312deeb4766308841cfb7060e7107bd818ad35fa89f4473d093879

➜ docker-angular  docker container ls
CONTAINER ID   IMAGE                                                   COMMAND                  CREATED          STATUS                             PORTS                               NAMES
ac8f48b7fd31   dimmaryanto93/docker-angular:2021.07.09.06.54-release   "/docker-entrypoint.…"   16 seconds ago   Up 16 seconds (health: starting)   0.0.0.0:80->80/tcp, :::80->80/tcp   angular-nginx

➜ docker-angular  docker top angular-nginx
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                5285                5263                0                   00:02               ?
00:00:00            nginx: master process nginx -g daemon off;
uuidd               5338                5285                0                   00:02               ?
00:00:00            nginx: worker process
uuidd               5339                5285                0                   00:02               ?
00:00:00            nginx: worker process

➜ docker-angular  docker stats angular-nginx --no-stream
CONTAINER ID   NAME            CPU %     MEM USAGE / LIMIT     MEM %     NET I/O     BLOCK I/O   PIDS
ac8f48b7fd31   angular-nginx   0.00%     3.238MiB / 3.842GiB   0.08%     906B / 0B   0B / 0B     3
```

Jika akses melalui browser, maka hasilnya seperti berikut:

![angular-docker-iamge]({{ page.image_path | prepend: site.baseurl }}/02-nginx.png)

## Cleanup

Seperti biasa, setelah kita mencoba schenario diatas. saatnya kita bersih-bersih dulu ya. Berikut perintahnya:

For Bash script:

{% gist page.gist "08g-cleanup.bash" %}

For Powershell script:

{% gist page.gist "08g-cleanup.ps1" %}