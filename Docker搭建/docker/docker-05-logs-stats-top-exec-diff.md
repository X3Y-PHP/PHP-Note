## 5. 窗口查看统计命令
### 1.  **logs**：查看这个容器的信息
```
sudo docker logs ubuntu01
```
-f：表示查看实时日志
-t：表示查看日志产生的日期
–tail=n：表示查看从尾部看的n条日志

### 2. **Stats**：统计显示 Cpu/Memory/IO/Network 使用状态
```
sudo docker stats ubuntu01
```
### 3. **top**：可以查看到容器，因为容器里面可以跑多个进程，可以看到当前容器最消耗的是那个进程。
```
sudo docker top ubuntu01
```
### 4. **Port**：容器和主机映射的端口信息
```
sudo docker port ubuntu01
```
### 5. **exec/attach**：attach这个命令不做过多的解释，因为这个命令不好用，后面会把它废弃掉，主要讲一下exec这个命令。
```
sudo docker attach ubuntu01
```
使用 attach 命令有一个问题。当多个窗口同时使用该命令进入该容器时，所有的窗口都会同步显示。如果有一个窗口阻塞了，那么其他窗口也无法再进行操作。

docker在1.3.X版本之后还提供了一个新的命令exec用于进入容器，这种方式相对更简单一些
```
sudo docker exec -it ubuntu01 bash
```
### 6. **diff**：可以看到当前这个里面有什么文件，有哪些一样的，或者不一样的。
```
sudo docker diff ubuntu01
```
