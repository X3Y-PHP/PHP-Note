## 6. 容器操作命令 inspect/cp/update/export/import/rm
### 1. **inspect**（查看容器/镜像详细信息）
```
sudo docker inspect ubuntu01
```
### 2. **cp**（拷贝文件）
把容器里面的文件copy出来
```
sudo docker cp ubuntu01:/usr/share/nginx/html/index.html .
```
把文件cp 到容器里
```
sudo docker cp index.html ubuntu01:/tmp/
```
### 3. **update**（更新容器信息）
**-m 128M:** 创建容器时，限制内存只能使用128M
```
sudo docker run -d -p 88:80 --name demo -m 128m nginx:1.11.1
```
做完限制之后，我们可以看一下，可以看到它的内存是128M。
```
sudo docker inspect demo | grep -i memory
```
我们可以更新一下配置
```
sudo docker update -m 256m demo
```
### 4. **export**（把容器保存成tar文件）
```
sudo docker export b707d0dee65c > ubuntu01.tar
```
### 5. **Import**（把tar文件导会到镜像列表）
```
cat ubuntu01.tar | sudo docker import - test/ubuntu:v1.0
```
此外，也可以通过指定 URL 或者某个目录来导入，例如
```
sudo docker import http://example.com/exampleimage.tgz example/imagerepo
```
### 6. **rm**（删除一个或多个容器）

```
$ sudo docker rm ubuntu01 nginx ...
```
