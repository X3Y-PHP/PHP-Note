## 4. 容器启动/停止命令 start/stop/kill/restart/pause/unpause
### 1. **run/create**：通过run指令可以把一个镜像起成一个容器
还有一个指令也可以启动容器，但是这个容器起完之后是一个create状态，它没有是up状态。
```
sudo docker run -i -t --name ubuntu01  -v /opt/software/:/mnt/software/ ubuntu:14.04 /bin/bash
```
### 2. **Start**：容器也可以进行停止，stop掉，我们可以把它再启动起来。
```
sudo docker start ubuntu01
```
### 3. **stop/kill**：停止容器有两个方法，一个是stop，另一个是kill。
```
sudo docker stop ubuntu01
sudo docker kill ubuntu01
```
### 4. **restart**：相当于把容器再重新启动一下。
```
sudo docker restart ubuntu01
```
### 5. **pause**：相当于把容器暂停。
```
sudo docker pause ubuntu01
```
### 6. **unpause**：再恢复。
```
sudo docker unpause ubuntu01
```
