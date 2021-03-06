## 1. Docker 前言（介绍）
> Docker官方对自己的定位一直很简单：an open platform to build, ship, and run any app, anywhere。

What can Docker do for me，我贴几个重要的：

- Get a well-defined, reproducible environment
- Define this environment in a Dockerfile
- Build this Dockerfileinto a container image
- Run this container image anywhere

我们知道一般大型企业的业务比较多，开发、测试、运维的环境都不能统一。从开发到上线，会有相当多的时间用于一遍遍搭建环境。当然，以前的VM也是能够做到。但是VM的效率跟容器会有一些差距。
同时，容器由于是**轻量级**，能够将容器**快速迁移**，**秒级HA**（High Availability）等。这也是VM做不到的。
而且容器的**资源限制**也能够对于不同级别的业务进行更好的规划。

综合来看，docker的最引人注意的是统一环境，保证效率，HA、资源限制。
Dockerfile的使用比较少（重新构建镜像时使用）。代码发布的话暂时还不会使用这种方式。至于分层，以后业务迭代开发时候会进一步利用起来。

Docker 容器主要是用作应用容器，包括两方面的功能：

1. 静态打包：把应用程序及其运行时打包为一个镜像；
2. 动态运行：以一个应用容器的形式运行这个应用。

这样，用户，不管是大企业还是普通人想在服务端跑程序，只需要这二步就完了。不用去操心一堆的数据库、消息队列、中间件、配置参数、等等等的所有麻烦的事情。

## 二. Docker镜像分层技术
### 1. 什么是docker 镜像

　　就是把业务代码和可运行环境进行整体的打包

### 2. 如何创建docker镜像

　　现在docker官方共有仓库里面有大量的镜像，所以最基础的镜像，我们可以在共有仓库直接拉取，因为这些镜像都是原厂维护，可以得到即使的更新和修护。

### 3. Dockerfile

　　我们如果想去定制这些镜像，我们可以去编写Dockerfile，然后重新bulid，最后把它打包成一个镜像，这种方式是最为推荐的方式包括我们以后去企业当中去实践应用的时候也是推荐这种方式。
　　
![这里写图片描述](http://images2015.cnblogs.com/blog/815181/201611/815181-20161108115424858-614325566.png)

### 4. Commit

　　当然还有另外一种方式，就是通过镜像启动一个容器，然后进行操作，最终通过commit这个命令commit一个镜像，但是不推荐这种方式，虽然说通过commit这个命令像是操作虚拟机的模式，但是容器毕竟是容器，它不是虚拟机，所以大家还是要去适应用Dockerfile去定制这些镜像这种习惯。

　　镜像的概念主要就是把把运行环境和业务代码进行镜像的打包，我们重点是了解镜像的分层技术，我们先来看一个Ubuntu系统的镜像。
![这里写图片描述](http://images2015.cnblogs.com/blog/815181/201611/815181-20161108115431889-1561276188.png)

　　我们可以镜像可以分层很多个layer，并且他们都有大小和ID，我们可以看到这里有4个layer ID号，最终这个镜像是由他们layer组合而成，并且这个镜像它是只读的，它不能往里面写数据，如果想写数据怎么办呢？我们会在镜像上启一层contain layer，其实就是相当于把镜像启动成一个容器，那么在容器这一层，我们是可写的。
　　
![这里写图片描述](http://images2015.cnblogs.com/blog/815181/201611/815181-20161108115439452-327513465.png)

　　比如我们想在这个Ubuntu这个系统上加一层，只能在上面继续叠加，这些工作其实都是由COW（写时复制）机制来实现的。

　　**子镜像**
![这里写图片描述](http://images2015.cnblogs.com/blog/815181/201611/815181-20161108115448811-722309228.png)

　　下载的时候只会下载子镜像最上面的一层，因为其它层已经有了，那么它可以做到一个节约空间的作用。

　　**父镜像**

![这里写图片描述](http://images2015.cnblogs.com/blog/815181/201611/815181-20161108115455639-1438133571.png)

最为典型的就是镜像的分层技术—— **aufs**

![这里写图片描述](http://images2015.cnblogs.com/blog/815181/201611/815181-20161108115501577-1451244189.png)

　　Aufs是Another Union File System的缩写，支持将多个目录挂载到同一个虚拟目录下。

　　已构建的镜像会设置成只读模式，read-write写操作是在read-only上的一种增量操作，固不影响read-only层。

这个研究有一个好处，比如我们现在可以看到手机里面的APP，在命令里面都会用APP字段下回来，在下回来之前它就是一个静态的，我们没有往里面写东西，但是我们启动起来以后，我们就可以往里面写东西，进行各种各样的操作。但是如果我们把它关掉了以后，或者删除了以后，它的这个镜像是存在远端的，所以在这个镜像里面是不会去修改的。并且这样也会有一个非常好的地方，这个场景非常适合我们去实现测试环境，因为我们的测试环境经常会有一个操作就是灌数据，我们可以提前把这个镜像数据打包到测试里面，那么这个镜像软件里面包含了，最上面是nginx，比如它里面会有一些数据，我们可以在往上面打一层数据，打完之后把它起成一个容器就可以去测试，测试完之后这个容器里面会生成各种各样的数据，也就是脏数据，这样的话，我们就可以把这个容器删掉，删掉以后我们镜像里面的容器是不会受影响的。如果说它想再创建一套，我们可以把这个镜像再启一个容器，就可以是一个一模一样的，并且是一个干净的环境。
## 三. 容器是什么
### 1. docker 容器管理

Docker本身是容器管理技术，不是虚拟化技术。我们来看一下，容器和虚拟机vm的区别：

![这里写图片描述](http://www.maiziedu.com/uploads/new_img/NY0QnwhgWKsiFn2yOb.png)￼

可以看到两个技术解决的问题以及他的侧重点是不一样的。容器的操作模式是，它没有虚拟机和操作系统这一层，它直接相当于在系统上面运行一个二进制容器。容器它本身不是虚拟化技术。我们也可以看出来，虚拟机是服务器 硬件 和 操作系统 之间的解耦，并且虚拟机这个操作系统是比较重，比较大，相对于容器来说它启动比较慢。而docker更靠近应用这个层，所以它是应用和操作系统之间的解耦。但是容器本身是一个进程。比如我们这个操作系统上面运行了10个程序，其实就是这个操作系统上面又多了10个进程而已。

其实docker最关键的地方是docker镜像和docker nginx，nginx是标准化，促进了上下游的发展，比如说最简单的一个例子，可以让开发，测试，运营，这个三个部门协作更加方便。

### 2. 容器是什么

1）容器本质上是进程，我们原先是在一个操作系统上装很多个服务，比如nginx，mysql，或者其他服务，掺杂到系统里面，现在有了容器后，我会在操作系统中运行mysql容器，nginx容器，或者tomcat容器，会把这个3个进程全部打包到容器里面，这样的话，如果这个进程想要的话，我们就把这个容器启动起来，我们不要这个进程时就把这个容器删掉。所以很显而易见docker它不是虚拟化技术。

2）docker不是虚拟化技术，docker最关键的点是提出了docker image 标准化，image 打包了应用
如：nginx镜像，通过镜像启动一个nginx容器，其实就是在主机上启动一个nginx进程。

### 3. 容器!=微服务

1）容器中推荐只运行一个服务
2）容器也不等于微服务
3）容器中如果运行多个服务，需要结合进程管理工具（supervisor或S6）
4）因为容器本身就是进程，所以数据库容器也可以运行，但需要对数据做好保护。

如果容器的最上面一层不要了或者删掉了，那么里面的数据是被删掉了，但是docker有一个数据是-v，我们会在后面讲到，docker的数据管理是多人管理实现。就是通过多人管理把数据做好保护，这样的话我们的容器删掉以后，我们的数据也是在的。如果我们在新创建一个容器，这样的话那个数据又可以换回去，和原来的一模一样。

我们再强调一下，容器其实就是虚拟机上的一个进程。

### 4. Docker的优点

1）更轻量
镜像尺寸小 ，资源利用率高 。
我们方便去牵引，牵引的话如果已经有一些镜像存在的话，镜像尺寸就比较小。同时因为它没有虚拟机那么重，所以它的健壮率会很高。
2）更快速
直接运行在宿主机上，没有IO转换负担。
它就是宿主机上的一个进程，启一个进程是非常快的，没有像虚拟机还要进行CPU，内存的这些时间的消耗，并且docker它利用率高也体现在它没有一个资源的损耗。
3）更便捷
易安装，易使用，迁移方便，数据量小。
安装docker就通过一个命令，一个脚本就把docker装起来，也很方便去使用，我们只有熟悉docker的命令，我们就可以把它运用起来，迁移的时候，我们不要去迁移docker，我们去迁移的是容器的镜像，数据量小也体现在镜像的分层技术，同一批镜像，如果有很多个，它是重复的，它只会占用一个磁盘空间。

## 四. 镜像
### 1. 查看当前本地主机已下载的镜像列表
```
sudo docker images
```
### 2. 下载镜像
**镜像仓库**
Docker 官方镜像中心（hub.docker.com）
官方镜像源地址：https://hub.docker.com/explore/

镜像可以分为本地镜像和中心镜像。
中心镜像主要存放的是镜像仓库里面，公开的hub.docker.com是官方提供的。

![这里写图片描述](http://www.maiziedu.com/uploads/new_img/hqHuoH92jOFsL7Asjw.png)

还有另外一种镜像是本地镜像，从中心镜像仓库下载到宿主机本地如第一次下载镜像，会把镜像所有层都下载回来，利用镜像分层技术，如果主机上已有的layer（层）存在，下载新增加的layer（层）类似git代码提交机制，有父镜像和子镜像这样的概念，如果镜像的父镜像已经下载下来，那么再下载子镜像的时候，那么父镜像的层是不需要下载的，再下载子镜像就下载子镜像的层就可以了，一个是可以达到节省空间的效果，另一个是可以加快镜像的下载速度，这样我们在更新业务的时候，可以提前把这些下发到主镜像，并且它下发的时候包的大小就是根镜的大小，而不是像虚拟机几百G的镜像每次都是全部下回去，Docker pull push 类似 git 代码提交机制，只取回更新新下发的层。

测试：下载一个非常小的镜像 busybox
```
sudo docker pull busybox
```
Docker官方的仓库是不需要认证的，也就是你不需要认证也可以去下，但是如果想要网上上传这个镜像的时候是需要认证的。

**加版本号下载**
```
sudo docker pull nginx:1.12.0
```

### 3. 删除镜像
**什么情况下不能删除镜像**
　　1. 有容器使用镜像已经被创建
　　2. 此镜像是其他镜像的父镜像，这个内容不会提示删除失败，这个不删除时为了保证我们在做持续集成交互的时候的一个好处，因为我们镜像去构建的时候都会观望一个我们的父镜像，如果这个父镜像被删了的话，我们就会构建失败，它就会找不到这个镜像，这样就会从网络补挖，这样我们可能就会导致一些错误，所以如果有其他镜像去接这个父镜像的时候，这个镜像尽量不要删除。

**删除本地镜像**
```
sudo docker rmi nginx
```
**查找出现镜像构建的原因**
如果我在构建这个APP的时候这个父镜像原来是在的，直接写入这个镜像就可以构建，如果这个镜像被删掉了以后，那么我的这个APP构建的时间就比较长，如果父镜像在国外，那么下载的时间和速度就会更慢，所以说如果有镜像依赖父镜像的时候，千万不要删除。
```
sudo docker inspect nginx:1.12.0
```
查看当前本地主机有哪些容器是在运行的
```
sudo docker ps -a
```
如果把这个镜像删掉，就会提示是否强制删除，因为已经有容器使用这个镜像创建了，那么如果这个镜像被删掉了，那么我这个容器下启动的时候就会失败。
### 4. 上传镜像
Registry Server

Registry Server = 镜像中央存储仓库

Docker hub是docker官方提供的，这里面存在着大量的镜像，这些镜像包含如下，这些镜像都是由各个厂商来推送到这hub上面的，所以我们可以放心的去使用这些镜像，因为这些镜像的版本和安全性是有一些保证的，所以我们尽量去使用这些原厂的镜像。

![这里写图片描述](http://www.maiziedu.com/uploads/new_img/Wiqb3MC4MOcYqj2gSn.png)

如何把自己本地的镜像，同步docker官方镜像到企业私有镜像仓库。需要具备3个条件
1）docker hub 账号
2）docker login
3）docker push

先有一个账号，然后去网上pull一个镜像。

![这里写图片描述](http://www.maiziedu.com/uploads/new_img/84YlYHCa0Lsx0d4eOb.png)

查看本地主机有什么镜像
```
sudo docker images
```
命令行登录 Docker hub。
```
sudo docker login
```
docker push
```
sudo docker push <$ImageName>
```
已经上传成功，这样我们可以把自己的镜像贡献给其他人，这样就可以共同使用。

![这里写图片描述](http://www.maiziedu.com/uploads/new_img/3vbpadRrP8PgYeQIib.png)

Pull命令可以把这个镜像下载下来。下载这个命令有几个点，如果这个已经有了，就不会下了，如果没有的话就会提醒你下载。
