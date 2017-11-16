# VERSION 0.0.1
# USERNAME changhongbo
From ubuntu:14.04

RUN apt-get update
RUN apt-get install -y curl vim
RUN apt-get install -y zip unzip php-zip

RUN sudo apt-get install -y software-properties-common
    apt-get install -y language-pack-en-base && \
    locale-gen en_US.UTF-8 && \
    export LANG=en_US.UTF-8 && \
    export LC_ALL=en_US.UTF-8

RUN sudo add-apt-repository ppa:ondrej/nginx && \
    sudo apt-get update

RUN apt-get install -y nginx
RUN service nginx start

# 添加PHP镜像并安装PHP
RUN sudo add-apt-repository ppa:ondrej/php && \
    sudo apt-get update

RUN sudo apt-get install -y php7.0 php7.0-mysql php7.0-fpm php7.0-curl && \
    php7.0-xml php7.0-mcrypt php7.0-json php7.0-gd php7.0-mbstring && \
    php-mongodb php-memcached php-redis php-zip

# 安装mysql
RUN sudo apt-get update && \
    sudo apt-get install -y mysql-server-5.6 && \
    sudo service mysql start

CMD PHP -v && \ nginx -v && \mysql -v
