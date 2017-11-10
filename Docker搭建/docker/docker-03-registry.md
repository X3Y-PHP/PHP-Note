## 3. Docker私有仓库
### 1. 查看当前本地镜像
```
sudo docker images
```
如果没有 registry 的话就去官方pull一下。
```
sudo docker pull registry
```
### 2. 启动 registry 容器（在服务器上启动）
```
sudo docker run -d -p 5000:5000 --restart=always --name moma_registry  -v /opt/docker_registry:/var/lib/registry registry
```
`docker run`：把镜像创建成容器

`-d `：把镜像创建成容器之后，把进程启动到后台，这个进程就相当于一直进行，容器的状态也一直是up的。

`-p`：进行端口验证的时候，前面所有机子端口，后面是容器服务的端口，推荐大家用-p。
`--restart=always`：如果容器有异常会重新启动一次

`--name registry`：创建这个容器的时候，会给它起一个名字，叫registry。

`-v /data/registry:/var/lib/registry` ：我会映射一个容器的目录到所有机下，最终是通过registry:2这个镜像生成这个容器。
`-i`：表示以“交互模式”运行容器
`-t`：表示容器启动后会进入其命令行
### 3. 查看是否启动
```
sudo docker ps
```
我们启动动了一个容器，如地址为：`192.168.8.240:5000`
### 4. 本地推送，上传镜像测试
推送本地镜像到服务器`192.168.8.240:5000`仓库

pull一个比较小的镜像来测试（此处使用的是busybox）。
```
sudo docker pull busybox
```
更改 busybox 镜像 tag，并查看镜像:
```
sudo docker tag busybox 192.168.8.240:5000/busybox
sudo docker images
```
把打了 tag 的镜像上传到私有仓库（注意）
```
sudo docker push 192.168.8.240:5000/busybox
```
可以看到 push 失败了，错误如下：
```
The push refers to a repository [192.168.8.240:5000/busybox]
Get https://192.168.8.240:5000/v1/_ping: http: server gave HTTP response to HTTPS client
```
因为Docker从1.3.X之后，与docker registry交互默认使用的是https，然而此处搭建的私有仓库只提供http服务，所以当与私有仓库交互时就会报上面的错误。为了解决这个问题需要在启动docker server时增加启动参数为默认使用http访问。

我们在`/etc/docker/daemon.json`（本地客户机）目录下，创建`daemon.json`文件。在文件中写入：
```
{ "insecure-registries":["192.168.8.240:5000"] }
```
保存退出后重启docker，再次推送成功。
```
sudo systemctl restart docker
sudo docker push 192.168.8.240:5000/busybox
```
删除本地已经上传过的镜像，并查看
```
sudo docker rmi 192.168.8.240:5000/busybox
sudo docker images
```
从私有仓库下载已删除的镜像:
```
sudo docker pull 192.168.8.240:5000/busybox
```
