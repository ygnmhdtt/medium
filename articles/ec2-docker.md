---
title: "EC2にdocker環境を構築するときにやったこと"
date: 2017-02-11T18:00:00+09:00
tags:
- AWS
- EC2
- Docker
---
無事dockerが入れられたのでメモ。

<!--more-->

MacのターミナルからEC2へ繋ぐコマンドが↓。
test.pemは、EC2インスタンスを構築するときダウンロードする鍵。
my.public.ip.addressは、EC2 Management Consoleから見られる。

```
$ ssh -i path/to/pem/test.pem ''my.public.ip.address'' -l ec2-user
```

つなぎ先のIPはインスタンスを起動し直すたび変わるので、ElasticIPを設定すれば永続化できる。(お金かかるのでやってない)

最初にやれと言われるのでやる。

```
$ sudo yum update -y
```

サーバのOSを確認しておく。

```
$ cat /etc/*release*


NAME="Amazon Linux AMI"
VERSION="2016.09"
ID="amzn"
ID_LIKE="rhel fedora"
VERSION_ID="2016.09"
PRETTY_NAME="Amazon Linux AMI 2016.09"
ANSI_COLOR="0;33"
CPE_NAME="cpe:/o:amazon:linux:2016.09:ga"
HOME_URL="http://aws.amazon.com/amazon-linux-ami/"
Amazon Linux AMI release 2016.09
cpe:/o:amazon:linux:2016.09:ga
```

ちゃんとAmazonLinuxAMIが入っている。

### dockerをinstall

```
$ sudo yum install -y docker
```

### dockerを立ち上げる

```
sudo service docker start
```

sudoなしでdockerを立ち上げるために、ec2-userをgroupに入れる。

```
$ sudo usermod -a -G docker ec2-user
```

ここで

```
$ exit
```

でEC2を抜ける。
もう一回最初のコマンドを叩いてログインし直す。(上で設定したgroupのpermissionを反映させるためらしい(?))

### dockerが生きてるか(sudoなしで叩けるか)確認
```
docker info


Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 1.12.6
Storage Driver: devicemapper
 Pool Name: docker-202:1-395189-pool
 Pool Blocksize: 65.54 kB
 Base Device Size: 10.74 GB
 Backing Filesystem: xfs
 Data file: /dev/loop0
 Metadata file: /dev/loop1
 Data Space Used: 11.8 MB
 Data Space Total: 107.4 GB
 Data Space Available: 7.001 GB
 Metadata Space Used: 581.6 kB
 Metadata Space Total: 2.147 GB
 Metadata Space Available: 2.147 GB
 Thin Pool Minimum Free Space: 10.74 GB
 Udev Sync Supported: true
 Deferred Removal Enabled: false
 Deferred Deletion Enabled: false
 Deferred Deleted Device Count: 0
 Data loop file: /var/lib/docker/devicemapper/devicemapper/data
 WARNING: Usage of loopback devices is strongly discouraged for production use. Use `--storage-opt dm.thinpooldev` to specify a custom block storage device.
 Metadata loop file: /var/lib/docker/devicemapper/devicemapper/metadata
 Library Version: 1.02.93-RHEL7 (2015-01-28)
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge overlay null host
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Security Options:
Kernel Version: 4.4.41-36.55.amzn1.x86_64
Operating System: Amazon Linux AMI 2016.09
OSType: linux
Architecture: x86_64
CPUs: 1
Total Memory: 995.4 MiB
```

# docker-composeもinstall

docker-composeは、複数コンテナを簡単に扱うためのdockerのモジュール(?)らしい
大体の場合、docker上にはアプリケーション以外にもmysqlなど複数のコンテナを構築する。docker-composeなしだとそれらの立ち上げが面倒だし、順番なども考慮しなきゃいけない。それらを楽にするのがdocker-compose。docker-compose.ymlに設定を書くことでいい感じにコンテナを立ち上げてくれる。(という理解)

```
curl -L --fail https://github.com/docker/compose/releases/download/1.13.0/run.sh > /usr/local/bin/docker-compose
```

ここで `/usr/local/bin` のpermissionで弾かれたので、以下でpermission付与

```
sudo chmod a+rwx /usr/local/bin/
```

docker-composeにもpermission付与

```
chmod +x /usr/local/bin/docker-compose
```

docker-composeがいけてるか確認

```
docker-compose -v

docker-compose version 1.11.1, build 7c5d5e4
```

ここまでできれば余裕。
あとは ~/.ssh/ に鍵を作ったり、configファイルを作ったりして、好きなところにプロジェクトをcloneして開発する。

docker for macは遅いし、リソースを食う。
macのストレージを45GB近く取ってて、辛くなる。EC2上にdockerを入れられれば、ホストとなるmacのリソースを食われないし、Linux上だとやはりdockerが速い。速いのは正義で、生産性にダイレクトに関わってくる要素なので、こだわりたい。

リモートサーバ上で開発することのデメリットがひとつあって、Macにあるファイルをリモートサーバに持っていくのが面倒くさい。
