一般来说，一个 PHP 项目会需要以下工具：
+ Web 服务器: Nginx/Tengine
+ Web 程序: PHP-FPM
+ 数据库: MySQL/PostgreSQL
+ 缓存服务: Redis/Memcache



##  docker-php-ext-configure、docker-php-ext-enable、docker-php-ext-install

### docker-php-ext-install
官方镜像版本：7.1.1-fpm-alpine，可以从daocloud下载

该镜像中没有make命令，甚至没有gcc、g++，虽然有pecl，但是由于没有gcc编译器，所以也不能运行phpize。

其实在该镜像的/usr/local/bin目录下有一个docker-php-ext-install程序专门用来安装php扩展。
运行它即可显示出能够安装的扩展，配合docker-php-ext-enable程序可以控制扩展的启动/禁用。
例如：在该镜像中没有pdo_mysql，我们如何安装呢？
```
# cd /usr/local/bin  
# ./docker-php-ext-install pdo_mysql  
```
完成后已经load进配置文件
