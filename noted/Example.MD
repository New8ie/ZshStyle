## Sample command Curl

* You can verify this by using the -I flag, which displays the request headers rather than the contents of the file:
```sh

$ curl -I www.digitalocean.com/robots.txt
```

Output
```sh

HTTP/1.1 301 Moved Permanently
Cache-Control: max-age=3600
Cf-Ray: 65dd51678fd93ff7-YYZ
Cf-Request-Id: 0a9e3134b500003ff72b9d0000000001
Connection: keep-alive
Date: Fri, 11 Jun 2021 19:41:37 GMT
Expires: Fri, 11 Jun 2021 20:41:37 GMT
Location: https://www.digitalocean.com/robots.txt
Server: cloudflare
. . .
```

* Execute the following command to download the remote file to the locally named do-bots.txt file:
```sh

$ curl -o do-bots.txt  https://www.digitalocean.com/robots.txt
```

Output
```sh


  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   286    0   286    0     0   6975      0 --:--:-- --:--:-- --:--:--  7150

```

Name download file changes to :

do-bots.txt

## Sample Curl SOCKS proxy

SOCKS is a protocol used for proxies and curl supports it. curl supports both SOCKS version 4 as well as version 5, and both versions come in two flavors.
You can select the specific SOCKS version to use by using the correct scheme part for the given proxy host with -x, or you can specify it with a separate option instead of -x.

* SOCKS4 is for the version 4 but curl resolves the name:
```sh

curl -x socks4://proxy.example.com http://www.example.com/
curl --socks4 proxy.example.com http://www.example.com/
```

* SOCKS4a is for the version 4 with resolving done by the proxy:
```sh

curl -x socks4a://proxy.example.com http://www.example.com/
curl --socks4a proxy.example.com http://www.example.com/
```

* SOCKS5 is for the version 5 and SOCKS5-hostname is for the version 5 without resolving the hostname locally:
```sh

curl -x socks5://proxy.example.com http://www.example.com/
curl --socks5 proxy.example.com http://www.example.com/
```

* The SOCKS5-hostname versions. This sends the hostname to the proxy so there is no name resolving done by curl locally:
```sh
curl -x socks5h://proxy.example.com http://www.example.com/
```



* The Git with SOCKS5
SOCKS4, SOCKS4a, SOCKS5, and HTTP/HTTPS. In order to connect through any proxy supported by libcurl, you can set the http.proxy option
```sh
git config --global http.proxy socks5://localhost:1080
```

## DISABLE APT PROTECTION TRUNAS 
```sh
/usr/local/libexec/disable-rootfs-protection
```
Output 
```sh
Flagging root dataset as developer mode
Setting readonly=off on dataset boot-pool/ROOT/24.10.0.2/opt
Setting readonly=off on dataset boot-pool/ROOT/24.10.0.2/usr
/usr/bin/apt-key: setting 0o755 on file.
/usr/bin/apt-extracttemplates: setting 0o755 on file.
/usr/bin/apt-ftparchive: setting 0o755 on file.
/usr/bin/apt-mark: setting 0o755 on file.
/usr/bin/apt-sortpkgs: setting 0o755 on file.
/usr/bin/dpkg: setting 0o755 on file.
/usr/bin/apt-config: setting 0o755 on file.
/usr/bin/apt: setting 0o755 on file.
/usr/bin/apt-get: setting 0o755 on file.
/usr/bin/apt-cache: setting 0o755 on file.
/usr/bin/apt-cdrom: setting 0o755 on file.
/usr/local/bin/pkg_mgmt_disabled: setting 0o644 on file.
```

