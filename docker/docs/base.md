# Docker

## docker版本信息

* docker info  

* docker version

## docker镜像仓库加速器

* 修改/etc/docker/daemon.json文件

```
{
    "registry-mirrors": ["https://registry.docker-cn.com"]
}

```


* 设置dockers开机自启，编辑docker.service文件设置加速器

> systemctl enable docker 

> 编辑/etc/systemd/system/multi-user.target.wants/docker.service

```
...

ExecStart=/usr/bin/dockerd --registry-mirror=https://registry.docker-cn.com
...

```

## 镜像image

* docker search \<image-name\> #从远程仓库搜索镜像

* docker pull \<image-nmae\> #从远程镜像仓库抓取镜像文件

* docker images 或 docker image ls #列出本地image列表

* docker rmi \<image-ID\>  #删除指定的image

* docker build -t \<image-name\> \<dockerfile-path\> #根据Dokcerfile文件创建docker镜像

* docker history \<image-ID\>   #查看镜像生成容器的历史

### 推送镜像

```
docker tag <image:tag> <username/image:tag>

docker push <username/image:tag>

```

### 镜像包

* docker export #将一个容器打包成镜像

```

docker export -o xxx.tar <container-name>

or 

docker export <container-name> xxx.tar

压缩:

docker export <container-name>  | [gzip|bzip2] [level] > xxx.tar.[gz|bz2]

```

**docker export 将容器保存，通过import导入，导入成为以打包前容器为基础的镜像**

**应用场景主要为制作基础镜像**

**docker export 将容器保存为新的镜像**


* docker import xxx.tar \<image:tag\> #导入docker export保存的容器镜像并指定新的image-name

<hr>

* docker save  #将一个或多个image打包保存

```

docker save -o xxx.tar < image | image1 image2 ...>

or

docker save < image | image1 image2 ...>  > xxx.tar

压缩:

docker save image | [gzip bzip2] [level] > xxx.tar.[gz|gz2|bz|bz2]

```

**建议指定镜像通过镜像名指定，通过镜像ID指定，加载后镜像名称和标签为<NONE>**

**主要应用场景:应用为docker-compose.yml配置的多个镜像组合，但部署的服务器无法连接外网，可通过save打包所需镜像，拷贝到要部署的服务器上使用docker load载入。**

**docker save 主要为单个或多个镜像的保存**

* docker load -i xxx.tar  #载入docker save保存的镜像包，无法对打包的额镜像进行重命名，如打包时指定镜像ID打包则载入后的镜像name为<none>


## 容器container

* docker run [options] [image-name] [command] #依托镜像文件启动生成容器，本地无所需镜像文件，自动从远程仓库拉取

> 选项[options](非全部，仅为常用):

```
--rm              #指定容器运行停止后自动删除容器

-p lport:cport    #指定将容器端口与本地主机端口映射

-P                #大写P，将容器暴露的端口随机映射到主机任意空闲端口

-i                #开启控制台交互，与-t选项合用，启动容器后自动登陆终端交互界面

-t                #分配tty，支持终端登陆

-d                #容器启动后后台运行

-v ldir:cdir      #将本地存储目录挂载到指定的容器目录

--name            #指定容器名称

-e                #向容器传递环境变量

--link            #连接到其他容器，并可设定别名

-workdir          #指定容器工作目录

--net=host        #使用主机网络

--net=bridge      #使用docker daemon指定的网桥

--net=container:\<name or ID\>  #使用其他容器的网络，共享IP和port等网络资源

```

* docker ps [-a] #查看正在运行的容器，-a选项查看所有包含已停止的容器

* docker kill \<container-ID\>  #强行终止运行的容器

* docker rm   \<container-ID\>  #删除已停止的容器，释放所占有的系统资源

* docker start \<container-ID\> #启动已生成但停止的容器

* docker stop \<container-ID\>  #停止运行的容器

* docker logs [-f] \<container-ID\>  #查看容器运行的输出，即容器shell的标准输出，如容器为使用-it指定终端交互，则可使用此命令查询输出，-f选项实时输出

* docker cp \<container-ID\>:\<file\> \<localdir\>  #将容器内的文件复制到本地指定的目录

* docker port \<container-ID\> #查看容器的端口映射情况

* docker exec [-i|-t|-d] \<command\> #在运行的容器中执行命令,使用exit退出，容器不会停止,执行多条命令加bash -c "command1 && command2 &&..."

* docker attach \<container-ID\>  #进入运行的容器中，使用exit退出，容器停止

* docker diff [options]  [container]  #查看容器的文件结构更改

* docker container prune   #删除所有停止的容器 











