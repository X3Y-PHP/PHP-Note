# https://yeasy.gitbooks.io/docker_practice/content/compose/yaml_file.html
# this docker iamge uses ubuntu:14.04 image
# VERSION 0.0.1
# USERNAME changhongbo
# For Learn dockerfile
# 指定基础镜像
From ubuntu:14.04

＃ 维护者信息
MAINTAINER x3y 18812671662@163.com

# 镜像的操作指令
RUN echo "LEARN"
RUN apt-get update && apt-get install -y nginx

# 暴露指定端口号
EXPOSE 22 80 8000

# 格式为ENV <key> <value>,指定一个环境变量，会被后续RUN指令使用，并在运行时保持
ENV　PHP_VERSION 7.1

# 格式为ADD <src> <dest>
# 复制指定的<src>到容器中的<dest>,其中<src>可以是Dockerfile所在目录的相对路径（文件或目录）;
# 也可以是一个URL;还可以是一个tar文件（自动解压为目录）
ADD　

# 格式为COPY <src> <dest>
# 复制本地主机的<src>（为Dockerfile所在目录的相对路径，文件或目录）为容器的<dest>。
# 目标路径不存在时会主动创建。
COPY

# 容器启动时执行命令
CMD
