# volume 数据卷

数据卷是一个可供一个或多个容器使用的特殊目录

* 数据卷可以在容器之间共享和重用

* 对数据卷的修改会立马生效

* 对数据卷的更新，不会影响镜像

* 数据卷默认会一直存在，即使容器被删除

**注:数据卷的使用类似于Linux下对目录或文件进行mount，镜像中的被指定为挂载点的目录中的文件会被隐藏，显示的是挂载的数据卷**


## 应用

#### 创建查看

* docker volume  create  \< volume-name \>  #创建数据卷

* docker volume ls #查看所有数据卷

* docker volume inspect \< volume-name \>  # 查看指定的数据卷信息

#### 启动

> docker run启动容器时指定挂载

* --mount source=\< volume \>,target=\< container-path \>

* -v or --volume  \< volume \>:\< container-path \> 

#### 删除数据卷

* docker volume rm \< vol-name \>

数据卷是被实际用来持久化数据的，它的生命周期独立于容器，Docker不会在容器被删除后自动删除数据卷，并且也不存在垃圾回收这样的集智来处理没有任何容器引用的数据卷。

**如果需要在删除容器的同时移除数据卷。可以在删除容器的时候使用docker rm -v 命令**

* docker volume prune  //清除所有无主数据卷


#### 挂载主机目录为数据卷

* docker run --mount source=\< localpath \>,target=\< container-path \>

* docker run  -v  \< locatpath \>:\< container-path \>

**本地目录的路径必须是绝对路径，使用 -v 参数时如果本地目录不存在 Docker 会自动为你创建一个文件夹，现在使用 --mount 参数时如果本地目录不存在，Docker 会报错。**

* 挂载默认的目录权限为读写，添加readonly指定为只读: docker run --mount source=\<loaclpath\>,target=\<container-path\>,**readonly**

**也可以挂载一个本地文件为数据卷,命令相同，将目录改为文件即可**



