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

Untuk windows user kita bisa menggunakan `cmd.exe` atau `powershell.exe` tapi disini saya mau menggunakan [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701) yang bisa di install melalui Microsoft Store. Tampilanya seperti berikut:

![windows terminal]({{ page.image_path | prepand: site.baseurl }}/windows-terminal.png)

Dengan default settings seperti berikut:

```json
{
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "copyOnSelect": false,
    "copyFormatting": false,
    "profiles":
    {
        "defaults": {},
        "list":
        [
            {
                "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                "name": "Windows PowerShell",
                "commandline": "powershell.exe",
                "colorScheme": "One Half Dark",
                "fontFace": "Cascadia Code",
                "hidden": false
            }
        ]
    },
    "schemes": [],
    "actions":
    [
        { "command": {"action": "copy", "singleLine": false }, "keys": "ctrl+c" },
        { "command": "paste", "keys": "ctrl+v" },
        { "command": "find", "keys": "ctrl+shift+f" },
        { "command": { "action": "splitPane", "split": "auto", "splitMode": "duplicate" }, "keys": "alt+shift+d" }
    ]
}
```

Dengan setting di atas, saya menggunakan PowerShell sebagai default command line dalam belajar docker. Selain itu juga kita bisa pasang plugin seperti:

1. [Powerline Theme for PowerShell](https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup)
2. [Cascadia Code](https://github.com/microsoft/cascadia-code)
3. [Auto Compleation for docker command](https://github.com/samneirinck/posh-docker)
