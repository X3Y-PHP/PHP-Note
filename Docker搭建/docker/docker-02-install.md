## 2. Docker 简单使用
### 1. Docker 安装
我们统一使用 Ubuntu apt 安装 Docker version 1.12.6-cs12

1.卸载旧版本： `docker`或`docker-engine`
```
sudo apt-get remove docker docker-engine
```
2.添加Docker CS包的公钥：
```
sudo curl -s 'https://sks-keyservers.net/pks/lookup?op=get&search=0xee6d536cf7dc86e2d7d56f59a178ac6c6238f52e' | sudo apt-key add --import
```
3.为apt安装HTTPS助手（你的系统可能已安装）
```
sudo apt-get update && sudo apt-get install apt-transport-https
```
4.安装 Docker的aufs存储驱动程序
```
sudo apt-get install -y linux-image-extra-virtual
```
更新LTS内核后，可能需要重启服务器。

5.添加新版本的存储库：（注意查看版本修改以下命令：发行版本名）

Ubuntu 15.10
```
sudo lsb_release -dc
Description:	Ubuntu 15.10
Codename:	wily

# echo "deb https://packages.docker.com/1.12/apt/repo ubuntu-wily main" | sudo tee /etc/apt/sources.list.d/docker.list

sudo add-apt-repository \
   "deb https://packages.docker.com/1.12/apt/repo/ \
   ubuntu-$(lsb_release -cs) \
   main"
```


Ubuntu 14.04
```
sudo lsb_release -dc
Description:	Ubuntu 14.04
Codename:	trusty

# echo "deb https://packages.docker.com/1.12/apt/repo ubuntu-trusty main" | sudo tee /etc/apt/sources.list.d/docker.list

sudo add-apt-repository \
   "deb https://packages.docker.com/1.12/apt/repo/ \
   ubuntu-$(lsb_release -cs) \
   main"
```
上边命令是为Ubuntu Trusty发行版添加了最新版本的CS Docker Engine的存储库。

如果是其它版本对应修改，将“ubuntu-trusty”字符串更改为您使用的发行版：
```
debian-jessie (Debian 8)
debian-stretch (future release)
debian-wheezy (Debian 7)

ubuntu-precise (Ubuntu 12.04)
ubuntu-trusty (Ubuntu 14.04)
ubuntu-utopic (Ubuntu 14.10)
ubuntu-vivid (Ubuntu 15.04)
ubuntu-wily (Ubuntu 15.10)
```
6.安装升级包：
```
sudo apt-get update
sudo apt-get upgrade docker-engine
sudo docker -v
```
