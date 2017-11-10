Vagrant 入门教程。Vagrant 安装、配置管理、打包分发

## Vagrant 介绍
Vagrant 可以为你提供可配置、可再生、便携的工作环境，它主要是一个中间层技术，它的下层是 VirtualBox，VMware，AWS 或者其他 provider，它的上层是 provisioning 工具，比如 shell scripts，Chef or Puppet 等可以自动化安装和配置软件的工具。

简单说：Vagrant 是虚拟机管理工具。

对于开发人员来说，Vagrant 可以帮你统一团队成员的开发环境。如果你或者你的伙伴创建了一个 Vagrantfile，那么你只需要执行 vagrant up 就行了，所有的软件都会统一安装并且配置好。同时还避免令人烦躁的 “在我的机器上是可以的” 问题。

实战环境：Ubuntu 16.04、IBM X200 laptops

## Vagrant 文档
- [Vagrant Documentation](https://www.vagrantup.com/docs/index.html)

## 安装 Virtual Box 和 Vagrant
下载 [链接](https://www.virtualbox.org/wiki/Downloads) 并安装 Virtual Box

下载 [链接](https://www.vagrantup.com/downloads.html) 并安装 Vagrant

## Enable Virtualization Technolog
在刚启动电脑时，按 F1 进入 BIOS，Config->CPU->Intel Virtualization Technology 中 `Intel VT-d Feature` 改成 `Enabled`，保存退出
**注意：** 这里有一个坑，修改后需要 **关机再启动**，直接重启电脑，配置不生效

<!-- more -->

## 新建虚拟机
### 下载 Ubuntu box
在 [Discover Vagrant Boxes](https://atlas.hashicorp.com/boxes/search?utf8=%E2%9C%93&sort=&provider=&q=ubuntu) 查找 Ubuntu Server 14.04 64 box 安装命令
```
vagrant init ubuntu/trusty64; vagrant up --provider virtualbox
```
下载速度缓慢，可以在命令行中看到 box 链接，建议直接在游览器中下载
```
https://atlas.hashicorp.com/ubuntu/boxes/trusty64/versions/20170405.0.0/providers/virtualbox.box
```

### 添加镜像
```
vagrant box add ubuntu1404 ubuntu1404.box
```

### 初始化虚拟机配置
```
vagrant init ubuntu1404
```
可以在 Vagrantfile 中增加
```
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end
```

### 启动虚拟机
```
vagrant up
```
没有的话则新建。这里也可在 VM VirtualBox 中可以看到新的虚拟机。

## 配置虚拟机环境
### SSH 登陆虚拟机
```
vagrant ssh
```

### 替换国内源
备份旧源
```
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
```
修改使用 aliyun 源
```
sudo vim /etc/apt/sources.list
```
替换为
```
deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
```
更新源
``` bash
sudo apt-get update
```

### LNMP
#### Ngnix
``` bash
# search
apt-cache search nginx
# install
sudo apt-get install nginx
# show version
nginx -v
#nginx version: nginx/1.4.6 (Ubuntu)

# test nginx
curl -I 'http://127.0.0.1'
```

#### MySQL
``` bash
sudo apt-get install mysql-server-5.6
```

#### PHP
``` bash
sudo apt-get install php5-cli
php -v
#PHP 5.5.9-1ubuntu4.21 (cli)
# install extend
sudo apt-get install php5-mcrypt php5-mysql php5-gd
# install support nginx fastcgi
sudo apt-get install php5-cgi php5-fpm -y
```

## Vagrant 高级
### 端口转发
#### 使用 VirtualBox 设置
首先挂起虚拟机
``` bash
vagrant suspend
```
在 VirtualBox 选择 Settings->Network->Advenced->Port Forwarding->adds
`Host IP` 宿主机端口
`Guest Port` 虚拟机端口
 重启后失效，因为 Vagrant 会去读自己的配置文件

#### 使用 Vagrant 配置
> [Forwarded Ports - Networking](https://www.vagrantup.com/docs/networking/forwarded_ports.html)

This will allow accessing port 80 on the guest via port 8080 on the host.
``` ruby
Vagrant.configure("2") do |config|
  config.vm.network "forwarded_port", guest: 80, host: 8080
end
```
``` bash
vagrant reload
```
重启虚拟机

### 网络配置
#### Private Networks
> [Private Networks - Networking](https://www.vagrantup.com/docs/networking/private_network.html)

Static IP
``` ruby
Vagrant.configure("2") do |config|
  config.vm.network "private_network", ip: "192.168.50.4"
end
```
Host 访问 Guest machine 将不需要端口转发

#### Public Networks
> [Public Networks - Networking](https://www.vagrantup.com/docs/networking/public_network.html)

```
config.vm.network "public_network", ip: "192.168.0.17"
```
要和 Host machine 在同一网段，同一路由下的计算机也可访问

### Synced Folders 共享目录
> [Basic Usage - Synced Folders](https://www.vagrantup.com/docs/synced-folders/basic_usage.html)

``` ruby
Vagrant.configure("2") do |config|
  # other config here

  config.vm.synced_folder "src/", "/srv/website"
end
```
Enabling NFS Synced Folders, To enable NFS, just add the `type: "nfs"` flag onto your synced folder:
``` ruby
Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", type: "nfs"
end
```
使用 NFS 需要配置 private network，如果遇到：
``` bash
It appears your machine doesn't support NFS, or there is not an
adapter to enable NFS on this machine for Vagrant. Please verify
that `nfsd` is installed on your machine, and try again.
It appears your machine doesn't support NFS
```
try to
``` bash
sudo apt-get install nfs-common nfs-kernel-server
```
Caveats
> [Synced Folders VirtualBox](https://www.vagrantup.com/docs/synced-folders/virtualbox.html)

There is a VirtualBox bug related to sendfile which can result in corrupted or non-updating files. You should deactivate sendfile in any web servers you may be running.

In Nginx:
```
sendfile off;
```

### Provider VirtualBox Configuration
> [Provider VirtualBox Configuration](https://www.vagrantup.com/docs/virtualbox/configuration.html)

#### Virtual Machine Name
```
config.vm.provider "virtualbox" do |vb|
   vb.name = "my_vm"
end
```

#### VBoxManage Customizations
```
config.vm.provider "virtualbox" do |vb|
  vb.memory = 1024
  vb.cpus = 2
end
```

#### Virtual hostname
```
config.vm.hostname = "mooc"
```

### Overwrite host locale in ssh session
``` ruby
ENV["LC_ALL"] = "en_US.UTF-8"

Vagrant.configure("2") do |config|
  # ...
end
```

## Vagrant 打包分发
关闭虚拟机：
``` bash
vagrant halt
```
打包时注意：Vagrantfile 中固定的 IP，可以先注释；打包：
``` bash
vagrant package --output mooc.box
```
启动 box：
``` bash
vagrant box add mooc mooc.box
vagrant init mooc
vagrant up
```

### 通过 Vagrantfile 升级
```
config.vm.provision "shell", inline: <<-SHELL
   apt-get update
   apt-get install -y redis-server
SHELL
```

``` bash
vagrant reload --provision
```

> Reference
> - [mooc/vagrant at master · apanly/mooc](https://github.com/apanly/mooc/tree/master/vagrant)
> - [vagrant打造跨平台可移动的开发环境](http://www.imooc.com/learn/805)
> - [Vagrant介绍](http://weizhifeng.net/learn-vagrant-01.html)

