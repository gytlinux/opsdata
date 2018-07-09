# Docker - network 容器网络

## 外部访问

在运行容器时通过指定-P或-p参数指定端口映射，实现外部对容器网络的访问

* docker run  -P   //随机映射一个端口到容器内部开放的网络端口

* docker run -p  [ ip:port | ip: | port ]:[container-port]  //指定要映射的端口，可为指定ip及端口，仅指定端口，仅指定IP端口随机，三种映射

* docker port <container>  //查看当前映射的端口配置

## 容器互联

* 创建新Docker网络，-d参数指定网络类型，bridge和overlay

```
docker network create -d bridge <net-name>

```

* 运行容器并连接到新建的网络中

```
docker run -it --name test1 --network <net-name> <image> sh

```

* 运行多个容器都连接到同一个网络<net-name>中，在一个容器内部通过ping 其他容器检测是否连通

```
ping <container-name>

```

**建议多个容器互联推荐使用docker-compose**

## 配置DNS

* 在/etc/docker/daemon.json文件设置,启动容器时dns自动配置

```
{
    "dns" : [
        "114.114.114.114",
        "8.8.8.8"
        ]
}

```

* 手动配置

> docker run 命令启动容器添加参数:

```
-h <hostname> or --hostname=<hostname>  //设定容器主机名，会被写到容器内的额/etc/hostname和/etc/hosts。但在容器外部看不到，既不会再docker container ls中显示，也不会在其他容器的/etc/hosts中看到

--dns=<ip_addr>    //添加dns服务器到容器的/etc/resoly.conf中，让容器用这个服务器来解析所有不在/etc/hosts中的主机名

--dns-search=<domain>  //设定容器的搜索域，当搜索域设定为.example.com时，搜索host的主机，DNS不仅搜索host，还会搜索host.example.com

```

**如果在容器启动时没有指定最后两个参数，Docker 会默认用主机上的 /etc/resolv.conf 来配置容器。**

## 高级网络配置

Docker 启动时，会自动创建一个docker0的虚拟网桥，可以理解为一个软件交换机，会在挂载到它的网口之间进行转发。同时Docker随机分配一个本地为占有的私有网段中的一个地址给docker0接口，如:172.17.0.1,掩码为255.255.0.0。此后启动的容器内的网口也会自动分配一个同一个网段的地址，当创建一个Docker容器的时候，同时会创建一对veth pair接口，这对接口一段在容器内，即eth0;另一端在本地并挂载到docker0网桥，名称以veth开头。通过这种方式，主机和容器之间通信，容器之间也互相可以通信，这样就创建了一个在主机和所有的容器之间的一个虚拟共享网络。

#### 网络命令列表

> **在docker服务启动时配置，且不能马上生效**

* -b \<bridge\> **or** --bridge=\<bridge\>  //指定容器挂载的网桥

* --bip=\<cidr\>   //定制docker0的掩码

* -H \<scoket\> **or** --host=\<socket\>  //Docker 服务端接受命令的通道

* --icc=true|false  //是否支持容器之间的通信

* --ip-forward=true|false   //看下文容器之间的通信

* --iptables=true|false  //是否允许Docker添加iptables规则

* --mtu=\<bytes\>   //容器网络中的MTU(接口允许接受的最大传输单元)

> **既可以在启动服务时指定，也可以在启动容器时指定，在Docker服务启动的时候指定会成为默认值，后面指定docker run 时可以覆盖设置的默认值**

* --dns=\<ip_address\>   //使用指定的DNS服务器

* --dns-search=\<domain\>  //指定DNS搜索域

> **只在docker run 执行时使用，是针对容器的特性内容**

* -h \<hostname\> **or** --hostname=\<hostname\>  //配置容器的主机名

* --link=\<container-name:alias\>  //添加到另一个容器的连接

* --net=\<bridge|none|host|container:name-or-id\>   //配置容器的桥接模式

* -p \<spec\> **or** --publish=\<spec\>  //映射容器端口到宿主主机

* -P **or** --publish-all=true|false   //映射容器所有端口到宿主主机


#### 自定义网桥

> 除了默认的docker0网桥，也可以指定网桥来连接各个容器。在启动Docker服务时，使用-b \<bridge\> 或 --bridge=\<bridge\> 来指定使用的网桥

* 查看网桥和端口连接信息

```
brctl show

brctl命令安装: yum -y install bridge-utils

```

* 如服务已经运行，需要先停止服务，并删除旧的网桥

```
$ systemctl stop docker
$ ip link set dev docker0 down
$ brctl delbr docker0

```

* 创建一个新的网桥bridge0

```
$ brictl addbr bridge0
$ ip addr add 192.168.1.1/24 dev bridge0
$ ip link set dev bridge0 up

```

* 使用新创建的网桥

> 1.在Docker配置文件/etc/docker/daemon.json中添加内容,之后启动Docker服务即可

```
{
    "bridge": "bridge0",
    }

```

> 2.修改docker启动配置文件docker.service,之后重启docker服务

vi /usr/lib/systemd/system/docker.service

```
ExecStart=/usr/bin/dockerd -b bridge0

```

> 新运行一个容器，用命令docker inspect \<container:name or id\> 查看新建网桥是否生效

```
$ docker run ...
$ docker inspect name
...
"Gateway": "192.168.1.1",
"IPAddress": "192.168.1.2",
...

```


#### 创建点对点连接

默认情况下Docker会所有的容器连接到docker0提供的虚拟子网中，有时需要两个容器之间直连通信，而不通过主机网桥进行桥接

> 创建一对peer接口，分别放到两个容器中，配置成点到点的链路类型

* 启动需要直连的两个容器

```
$ docker run -it --rm --net=none centos /bin/bash
[root@9e9c15a95069 /]#
$ docker run -it --rm --net=none centos /bin/bash
[root@fc6e53c846a6 /]# 

```

* 找到进程号，创建网络命名空间的跟踪文件

```
$ docker inspect -f '{{.State.Pid}}' 9e9c15a95069
22629
$ docker inspect -f '{{.State.Pid}}' fc6e53c846a6
22770
$ mkdir -p /var/run/netns
$ ln -s /proc/22629/ns/net /var/run/netns/22629
$ ln -s /proc/22770/ns/net /var/run/netns/22770

```

* 创建一对per接口，配置路由

```
$ ip link add A type veth peer name B

$ ip link set A netns 22629
$ ip netns exec 22629 ip addr add 10.1.1.1/32 dev A
$ ip netns exec 22629 ip link set A up
$ ip netns exec 22629 ip route add 10.1.1.2/32 dev A

$ ip link set B netns 22770
$ ip netns exec 22770 ip addr add 10.1.1.2/32 dev B
$ ip netns exec 22770 ip link set B up
$ ip netns exec 22770 ip route add 10.1.1.1/32 dev B

```

> 现在两个容器之间可以相互ping通，成功建立连接，并与其他容器或主机之间无法连接，如不指定--net=none，则可以与其他容器及主机之间通信。

> 创建一个只与主机之间通信的容器，推荐使用--icc=false来关闭与其他容器之间的通信





