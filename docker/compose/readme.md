# Docker-compose 

compose 是Docker官方的开源项目，负责对Docker容器集群的快速编排，从功能上看，跟OpenStak中的heat类似

compose 定位是定义和运行更多个docker容器的应用，通过一个单独的docker-compose.yml模板文件定义一组相关联的应用容器为一个项目

compose中有两个重要的概念:

* 服务(service): 一个应用的容器，可以包括若干运行相同镜像的容器实例

* 项目(project): 有一组关联的应用容器组成的一个完整的业务单元，在docker-compose.yml文件中定义

Compose 的默认管理对象是项目，通过子命令对项目中的一组容器进行便捷地生命周期管理。

Compose 项目由 Python 编写，实现上调用了 Docker 服务提供的 API 来对容器进行管理。因此，只要所操作的平台支持 Docker API，就可以在其上利用 Compose 来进行编排管理。

#### Install

* Linux

```
curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose

```

#### Command

* docker-compose [命令详解](compose-command.md)

#### docker-compose.yml

* compose模板文件docker-compose.yml[指令配置](yml.md)

