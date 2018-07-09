# MongoDB

## Install

* yum-repo

> /etc/yum.repos.d/mongodb.repo

```
[mongodb-org-3.4]
name=MongoDB Repository
baseurl=http://mirrors.aliyun.com/mongodb/yum/redhat/7Server/mongodb-org/3.4/x86_64/
gpgcheck=0
enabled=1

```

* yum install

```
yum -y install mongodb-org

```

## USE

* [简单操作](command.md)

* [加密认证](auth.md)

