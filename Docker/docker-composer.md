## 8. lnmp 环境，使用 Docker-composer
`Docker-composer`可以把多个容器连接到一起同时运行

### 1. 安装`Docker-composer `
安装 Python pip（用于安装docker-composer）// 通常情况下Ubuntu都会自带
```
sudo apt-get install python-pip python-dev
```
使用 pip 安装 docker-composer
```
sudo pip install -U docker-compose
```
### 2. 安装 ubuntu 容器，并配置 lnmp 环境
通过 docker，从网上 pull 镜像，用镜像构建容器（linux系统）

#### 1. 安装基础镜像 : `ubuntu:14.04`
```
sudo docker pull ubuntu:14.04
```
设置 ubuntu 以守护进程在后台运行
```
sudo docker run -dit --name my-lnmp ubuntu:14.04
```
进入容器内部
```
sudo docker exec -it my-lnmp bin/bash
```
如果需要退出容器使用`exit`即可
更新
```
apt-get update
```
#### 2. 安装常用工具
```
apt-get install -y curl vim
sudo apt-get install -y zip unzip php-zip

# 安装软件源仓库
sudo apt-get install -y software-properties-common
```
解决有可能存在的语言问题
```
 apt-get install -y language-pack-en-base
 locale-gen en_US.UTF-8
 export LANG=en_US.UTF-8
 export LC_ALL=en_US.UTF-8
```
#### 3. 安装Nginx
添加 Nginx 版本 PPA 源添加到系统中
```
sudo add-apt-repository ppa:ondrej/nginx
sudo apt-get update
```
安装Nginx
```
apt-get install -y nginx
service nginx start
```
nginx 配置文件位置: `/etc/nginx/nginx.conf`,  `/etc/nginx/conf.d/*.conf`

项目主目录位置:  `/usr/share/nginx/html/` 或 `/var/www/html`

测试 nginx
```
curl localhost
```
如果出现 Welcome to nginx! 类似的字样，说明nginx安装成功

#### 4. 安装 PHP7
添加 PHP 版本 PPA 源添加到系统中
```
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
```
安装PHP
```
sudo apt-get install -y php7.0 php7.0-mysql php7.0-fpm php7.0-curl php7.0-xml php7.0-mcrypt php7.0-json php7.0-gd php7.0-mbstring php-mongodb php-memcached php-redis

# 查看php版本
php -v
```

配置 `php.ini` ：
```
sudo vi /etc/php/7.0/fpm/php.ini

# 修改 760行 ： `;cgi.fix_pathinfo=1`去掉注释，改为`cgi.fix_pathinfo=0`
```
配置 `php-fpm`：
```
sudo vi /etc/php/7.0/fpm/pool.d/www.conf

#修改如下：
# 36行： listen = /var/run/php/php7.0-fpm.sock
# 107行： pm.max_children = 50
# 112行： pm.start_servers = 20
# 117行： pm.min_spare_servers = 10
# 122行： pm.max_spare_servers = 30
```
重启 php-fpm
```
# 检查语法
sudo php-fpm7.0 -t

# 重启 php
sudo service php7.0-fpm restart
```

配置 nginx

```
sudo vi /etc/nginx/sites-enabled/default
```
在`server{...}`里面修改配置
```

        # root 指向你的项目目录
        root /var/www/html;

        # 增加 index.php 到默认文档，如下行：
        index index.php index.html index.htm;


        # 在 `location /{}` 下行，增加以下配置
        location ~ \.php$ {
          fastcgi_split_path_info ^(.+\.php)(/.+)$;
          # NOTE: You should have "cgi.fix_pathinfo = 0;" in php.ini
          # With php5-cgi alone:
          # fastcgi_pass 127.0.0.1:9000;
          # With php5-fpm:
          fastcgi_pass unix:/var/run/php/php7.0-fpm.sock;
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
          include fastcgi_params;
        }

```
ThinkPHP 框架（对应修改）
```

        location / {
          try_files $uri $uri/ =404;
          if (!-e $request_filename) {
            rewrite  ^(.*)$  /index.php?s=$1  last;
            break;
          }
        }

```
PHP Laravel 框架（对应修改）
```

        location / {
          try_files $uri $uri/ /index.php?$query_string;
        }

```

检测配置是否成功，重新加载 Nginx 配置
```
sudo nginx -t
sudo service nginx reload
```

#### 5. 安装 MySQL
安装过程中会提示输入密码及确认密码，输入即可
```
sudo apt-get update
sudo apt-get install -y mysql-server-5.6
```
重启测试，连接测试
```
sudo service mysql start
```
输入密码后进入到mysql表示安装成功
```
mysql -uroot -pmoma

# 退出
mysql> exit
```

#### 6. 设置容器开机启动项
在`.bashrc`里写入开机启动项
```
sudo vim ~/.bashrc
```
在文件末尾写入以下内容，保存

开机启动项
```

service php7.0-fpm restart
service mysql start
service nginx start
tail -f /var/log/nginx/error.log
```
### 3. 将配置好的Docker容器，打包上传仓库
#### 1. 将容器打包成镜像
查看当前容器对应CONTAINER ID
```
sudo docker ps -a
```

将容器打包成镜像
```
sudo docker commit d039bf77903f new-lnmp
```
#### 2. 运行最终镜像
将 my-lnmp 容器暂停
```
sudo docker stop my-lnmp
```
使用刚打包的镜像，创建容器
```
sudo docker run -dit -p 8000:80 -p 3308:3306 -v /usr/share/nginx/html/:/var/www/html/  --name nginx-mysql-php7-composer new-lnmp /bin/bash

# -p 端口映射
# -v 本地目录映射到容器内
```
