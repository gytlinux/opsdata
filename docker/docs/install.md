#Docker-install

## Centos 7

* Centos-7 yum源直接装的docker版本为1.13的旧版本，要安装新版本docker-ce，需要centos-extras库启用，默认情况是启用的，如未启用请启用它

* 未安装旧版本docker略过，已安装旧版本docker先卸载旧版本及其依赖

```
yum -y remove docker*

or

yum -y remove docker \
              docker-client \
              docker-client-latest \
              docker-common \   
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-selinux \
              docker-engine-selinux \
              docker-engine

```

### yum源安装docker-ce

* 设置yum库

```
//安装所需包yum-utils , device-mapper-persistent-data , lvm2
yum -y install yum-utils device-mapper-persistent-data lvm2

//设置稳定库
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

//可选择启动最新和测试存储库:

yum-config-manager --enable docker-ce-edge

yum-config-manager --enable docker-ce-test

```

* 安装docker-ce

```
yum install docker-ce   //如果开启多个库，yum安装最新版而不是稳定版

//列出库中可用的docker-ce版本

yum list docker-ce --showduplicates | sort -r

```


