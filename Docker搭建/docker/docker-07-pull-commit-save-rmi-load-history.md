## 7. 镜像操作命令

### 1. **pull**：从一个镜像仓库里面把它拉下来
```
sudo docker pull ubuntu
```

### 2. **commit** (把容器 commit 成镜像)
这个方法不是最为推荐的

把 ubuntu01 commit 成一个镜像
```
sudo docker commit -a demo@admin.com -m "demo commit image" ubuntu01 ubuntu-web:2.0
sudo docker images
```

### 3. **save** (把镜像保存成tar文件)
如果没有save镜像仓库的话，或者一些企业内网的环境不允许有外网访问的情况，我们可以把这个保存成tar文件拷到U盘里面，到那边再把这个文件拷贝出来
把 ubuntu-web 镜像 Save 成了tar文件。
```
sudo docker save ubuntu-web > ubuntu-web.tar
```
### 4. **rmi** 删除本地镜像
```
sudo docker rmi ubuntu-web
```
### 5. **load** (把save镜像tar文件导入到镜像列表)
我们可以把ubuntu-web删了
```
sudo docker rmi ubuntu-web:2.0
```
删了以后，再把它导入进来。
```
sudo docker load < ubuntu-web.tar
sudo docker images
```
### 6. **history** ：可以查看到这个镜像做了哪些操作，哪些命令执行过
查看web2.0进行过哪些操作，它的作者，它的变量，做了哪一些软链接，开放了哪些端口，已经添加了文件到镜像里面，我们可以通过history可以查看到镜像里面都做过哪些东西和操作。
```
sudo docker history ubuntu-web:2.0
```
