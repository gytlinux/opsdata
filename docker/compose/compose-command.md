# Compose 命令

```
docker-compose [-f=<arg>...] [options] [COMMAND] [ARGS...]

```

### 基本选项

* -f, --file \<file\>   //指定使用compose模板文件，默认为docker-compose.yml,可以多次指定

* -p, --project-name \<name\>  //指定项目名称，默认使用所在目录名称作为项目名    

* --x-networking   //使用Docker的可拔插网络后端特性

* --verbose  //输出更多的调试信息

* -v, --version   //打印版本

### 命令使用

##### build :构建项目中的服务器

```
docker-compose build [options] [service...]

```

> 服务容器构建后，将会带上一个标记名，如web项目中的db容器，可以是web_db，可以随时在项目目录下运行docker-compose build重建服务

> options:

* --force-rm   //删除构建过程中的临时容器

* --no-cache  //构建镜像过程中不使用cache(这回加长构建过程)

* --pull   //始终尝试通过pull来获取更新版本的镜像

##### config :验证compose文件格式是否正确，正确显示配置，格式错误显示错误的原因

##### down : 停止up命令启动的容器，并移除网络

##### exec : 进入指定的容器

##### help : 获取命令帮助

##### images : compose文件中包含的镜像

##### kill : 发送SIGKILL信号强制停止服务容器

```
docker-compose kill [options] [service...]

```

> options:

* -s  //指定发送的信号，如SIGINT信号


##### logs : 查看服务容器输出

```
docker-compose logs [options] [service...]

```

> options:

* --no-color  //默认情况下，docker-compose对不同的服务输出使用不同的颜色区分，通过--no-color 关闭颜色

##### pause : 暂停一个服务容器

```
docker-compose pause [service...]

```

##### port : 打印某个容器端口所映射的公共端口

```
docker-compose port [options] <service> <private-port>

```

> options:

* --protocol=proto   //指定端口协议，tcp(默认)或者udp

* --index=index  //如果同意服务存在多个容器,指定命令对象的容器序号(默认为1)

##### ps : 列出项目中目前所有的容器

```
docker-compose ps [optins] [service...]

```

> options:

* -q   //只打印容器的ID信息

##### pull : 拉取服务依赖的镜像

```
docker-compose pull [options] [service...]

```

> options:

* --ignore-pull-failures  //忽略拉取镜像过程中的错误

##### push : 推送服务依赖的镜像到Docker镜像仓库

##### restart : 重启项目服务

```
docker-compose restart [options] [service...]

```

> options:

* -t, --timeout [tiomeout]  //指定重启前停止容器的超时(默认为10秒)

##### rm : 删除所有停止状态的服务容器，先执行docker-compose stop停止容器

```
docker-compose rm [options] [service...]

```

> options:

* -f, --force  //强制直接删除，包括非停止状态的容器。

* -v   //删除容器所挂载的数据卷

##### run : 在指定服务上执行一个命令

```
docker-compose run [options] [-p PORT...] [-e KEY=VAL...] <service> [command] [args...]

```

> 默认情况下，如果存在关联，则所有关联的服务将会自动被启动，命令类似启动容器后运行指定的命令，相关卷，连接等都会按照配置自动创建。

> 两点不同点:

* 给定命令将会覆盖原有的自动运行命令

* 不会自动创建端口，避免冲突

> options:

* -d   //后台运行容器

* --name  [name]   //为容器指定名字

* --entrypoint [CMD]  //覆盖默认的容器启动命令

* -e KEY=VAL    //设置环境变量值，多次使用选项来设置多个环境变量

* -u, --user=""   //指定运行容器的用户或者uid

* --no-deps   //不自动启动关联的服务容器

* --rm   //运行命令后自动删除容器，-d模式下忽略

* -p, --publish=[]   //映射容器端口到本地主机

* --service-ports   //配置服务端口并映射到本地主机

* -T   //不分配伪tty,意味着依赖tty的指令无法进行

##### scale : 设置指定服务运行的容器个数

```
docker-compose scale  [options]  [service=num...]

```

> 当制定数目多用于该服务当前实际运行容器，将新创建并启动容器，反之，将停止容器

> options:

* -t,--timeout  [timeout]  //停止容器时的超时(默认10秒)

##### start : 启动已经存在的服务容器

```
docker-compose start [service...]

```

##### stop : 停止处于运行状态的容器，但不删除，通过start命令可再次启动

```
docker-compose stop [options]  [service...]

```

> options:

* -t,--timeout  [timeout]  //停止容器时超时(默认10秒)

##### top : cat看各个容器内运行的进程

##### unpause : 恢复处于暂停状态中的服务

```
docker-compose unpause [service...]

```

##### up : 尝试自动完成包括构建镜像,创建服务，启动服务，并关联服务相关容器的一系列操作

```
docker-compose up [optins] [service...]

```

> 大部分和时候都可以直接通过该命令启动一个项目。默认情况下，up命令启动的容器在前台，控制台将会同时打印所有容器的输出信息，可以方便调试，通过Ctrl-c停止命令时，所有容器停止。

> 使用docker-compose up -d 会在后台启动并运行所有容器，推荐在生产环境下使用

> 如果服务器已经存在，up命令将会尝试停止容器，然后重建，保证新启动的服务匹配docker-compose.yml文件的最新内容。

> options:

* -d  //后台运行服务容器

* --no-color  //不使用颜色来区分不同的服务的控制台输出

* --no-deps  //不启动服务所链接的容器

* --force-recreate  //强制重建容器，不能与--no-recreate同用

* --no-recreate   //如果容器已经存在，则不重建，不与--force-recreate 同用

* --no-build   //不自动构建确实的服务镜像

* -t,--timeout  [timeout]  //停止容器时的超时(默认10秒)


##### version : 打印版本信息















