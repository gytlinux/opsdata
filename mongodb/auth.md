# mongodb --auth

## 创建用户[db.createUser()](https://docs.mongodb.com/manual/reference/method/db.createUser/) 

* 创建管理数据库用户的账户admin

MongoDB安装好之后，先要用localhost登录上去，创建一个admin，给予userAdminAnyDatabase的权限，可以管理所有数据库的用户：

```
use admin

db.createUser(
  {
    user: "admin",
    pwd: "admin",
    roles:
    [
      {
        role: "userAdminAnyDatabase",
        db: "admin"
      }
    ]
  }
)

```

* 创建数据库用户

用admin登录，创建其他用户，给予dbOwner的权限，可以对某个数据库进行所有操作：

```
use [db_name]
 
db.createUser(
  {
    user: "[user]",
    pwd: "[password]",
    roles:
    [
      {
        role: "dbOwner",
        db: "[db_name]"
      }
    ]
  }
)
```

* 启动


> --auth :开启用户认证 --fork :守护进程 --port : 指定端口启动，默认27017
 
```
mongod --dbpath /mnt/mongod/db --logpath /var/log/mongodb.log --logappend --auth --fork

```

## 用户权限[roles](https://docs.mongodb.com/manual/reference/built-in-roles/)

### 普通用户权限

* read :读取数据权限

> 可执行操作

```
collStats
dbHash
dbStats
find
killCursors
listIndexes
listCollections

``` 

* readWrite : 读写数据权限

> 可执行操作

```
collStats
convertToCapped
createCollection
dbHash
dbStats
dropCollection
createIndex
dropIndex
find
insert
killCursors
listIndexes
listCollections
remove
renameCollectionSameDB
update

```

### 管理用户权限

* dbOwner : 数据库所有者，可以对数据库进行任何管理操作


## 链接数据库[mongodb url](https://docs.mongodb.com/manual/reference/connection-string/)
 

```
mongodb://[username:password@]host1[:port1][,host2[:port2],...[,hostN[:portN]]][/[database][?options]]
```



