>Machine是在虚拟机上运行docker，通过machine可以快速在虚拟机里面部署docker，因此如果是非linux环境，实际是启动一个虚拟机，然后远程上去的，适合学习和测试。

>Compose是docker自带的编排工具，最初处理多个容器在一台主机上的启动和依赖。

>Swarm是自带的集群管理工具，通过它可以把多个docker虚拟成一个集群，同时支持原生API，正因为如此compose结合swarm后就可以跨主机编排。不过swarm还是比较新的集群管理工具，稳定性还有待提高。国内的话，我们ghostcloud一直是致力于打造最专业的容器云平台，会在后续陆续支持compose和swarm.


>推荐网站：
>+ https://yeasy.gitbooks.io/docker_practice/content/compose/introduction.html
> 
