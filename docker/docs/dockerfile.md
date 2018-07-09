# Dockerfile 

镜像定制

## docker commit 

* docker commit [options]  < container ID|name >  [image:tag]

> option:

```
--author    #指定修改的作者

--message   #记录本次修改的内容

```

> docker commit 将容器保存为镜像，在容器中做的任何修改记录会被记录到容器的存储层中，而commit命令将容器在原有镜像的基础之上在叠加容器的存储层构成新的镜像

* **慎用**

> 使用docker commit命令可以比较直观的帮助理解镜像分层的概念，但在实际环境中存在许多问题

1. 当修改容器内的文件时，由于命令的执行还有许多文件被改动或添加，如果是安装软件包、编译构建，会有大量无关内容被添加，不小心处理将会导致镜像臃肿

2. 使用docker commit 意味着所有对镜像的操作都是黑箱操作，生成的镜像被称为黑箱镜像，即除了制作镜像的人知道执行过什么命令，怎么生成的镜像，别人无法得知。会使维护工作非常复杂

3. commit 定制成镜像，是在原有镜像基础之上叠加记录修改的存储层形成的新镜像，那么每一次修改都是一次叠加，这样每一次都会让镜像臃肿，一直下去会让镜像越来越臃肿


## Dockerfile 定制镜像

docker commit 制作镜像可以用来学习，但是用在实际环境中就会有很大的问题，所有就有一个很好的解决commit问题的定制镜像的方法，使用Dockerfile脚本文件定制镜像

Dockerfile是一个文本文件，其中包含一条条指令，每一条指令构建一层，因此每一条指令的内容是描述如何构建当前层


> **Dockerfile**例:

```
FROM    <image:tag>
COPY    <相对路径>  <imagedir>
WORKDIR <imagedir>
RUN     <shell-command>
RUN     ["可执行文件","参数1","参数2"...]
EXPOSE  <port>

```

> 构建指令: docker build -t \< new-imagename:tag \> \<context|URL|-\>  [build详解](build.md)

### dockerfile 指令

* **FROM**  #定制镜像是要以一个镜像为基础进行定制，通过FROM指令指定所需基础镜像，为必备指令

* **RUN**   #执行命令行命令，定制镜像最常用命令共有两种格式

> shell格式:

```
RUN echo 'test'  > /opt/test.txt

```

> exec格式:

```

RUN ["可执行文件","参数1","参数2",...]

```

> **使用RUN构建镜像层时不要使用多条RUN指令，因为一个指令带标着添加一层的镜像，尽量将多条RUN指令融合越少越好，多条命令可以用“&&”符号相连接，并在最后将构建完成后所不需要的软件包进行清除**

* **COPY**  #将构建上下文目录中的源路径的文件或目录复制到新的一层镜像内的目标路径位置

> shell格式:

```
COPY <源路径>  <目标路径> 

```

> exec格式:

```
COPY ["<源路径1>",..."<目标路径>"]

```

> 源路径 可以是多个，也可以是通配符，通配符规则要满足Go的[filepath.Match](https://golang.org/pkg/path/filepath/#Match)规则。路径为相对路径

> 目标路径 可以是容器内的绝对路径，也可以是相对于工作目录的相对路径，工作目录用WORKDIR指定，目标路径不需要事先创建，如目录不存在会复制文件前先行创建确实目录

> 使用COPY指令，源文件的各种元数据都会保留，比如读写执行权限，文件变更时间等，这个特性对于镜像定制很有用，特别是构建相关文件都在使用Git管理的时候

* **ADD** #同COPY格式和性质基本一致，但在COPY基础上增加功能，如果源路径为一个压缩文件，则ADD指令将自动解压缩这个文件到目标路径，虽然ADD包含了更多的功能，但其行为不清晰，容易令镜像构建缓存失败，导致镜像构建缓慢。最适合ADD的场景就是需要自动解压缩的场景


* **CMD** #指定默认的容器主进程的启动命令

> shell格式:

```
CMD <command>

```

> exec格式:

```
CMD ["可执行文件","参数1","参数2"...]

```

> 参数列表格式，在指定ENTRYPOINT指令后，用CMD指定具体的参数

```
CMD ["参数1","参数2",...]

```


> 推荐使用exec格式，在解析时会被解析称为JSON数组，因此一定要使用**双引号**，使用shell格式，实际命令会被包装为”sh -c“的参数形式进行执行

```
shell格式:

CMD echo $HOME

实际执行:

CMD ["sh","-c","echo $HOME"]

```

> 容器中应用都应以前台运行，容器是为了主进程存在，主进程退出，容器也就停止

* **ENTRYPOINT** #指定容器的启动程序及参数，格式同CMD

> ENTRYPOINT指定启动程序，在docker run运行容器命令最后的命令可为一个参数

> 将启动容器服务之前与容器CMD无关的预处理工作写入脚本，通过ENTRYPOINT执行，脚本接收到的CMD作为命令在脚本最后执行

* **ENV** #设置环境变量

```
ENV <key> <value>
or
ENV <key1>=<value1> <key2>=<value2>...

```

* **ARG**  #设置环境变量

```
ARG <参数名>[=<默认值>]

```

> 构建参数和 ENV 的效果一样，都是设置环境变量。所不同的是，ARG 所设置的构建环境的环境变量，在将来容器运行时是不会存在这些环境变量的。但是不要因此就使用 ARG 保存密码之类的信息，因为 docker history 还是可以看到所有值的。

> Dockerfile 中的 ARG 指令是定义参数名称，以及定义其默认值。该默认值可以在构建命令 docker build 中用 --build-arg <参数名>=<值> 来覆盖。

> 在 1.13 之前的版本，要求 --build-arg 中的参数名，必须在 Dockerfile 中用 ARG 定义过了，换句话说，就是 --build-arg 指定的参数，必须在 Dockerfile 中使用了。如果对应参数没有被使用，则会报错退出构建。从 1.13 开始，这种严格的限制被放开，不再报错退出，而是显示警告信息，并继续构建。这对于使用 CI 系统，用同样的构建流程构建不同的 Dockerfile 的时候比较有帮助，避免构建命令必须根据每个 Dockerfile 的内容修改。


* **VOLUME** #定义匿名卷

```
VOLUME ["<path1>","<path2>"]
or
VOLUME <path>

```

> 容器运行时应该尽量保持容器存储层不发生写操作，对于数据库类需要保存动态数据的应用，其数据库文件应该保存于卷(volume)中,为了防止运行时用户忘记将动态文件所保存目录挂载为卷，在 Dockerfile 中，我们可以事先指定某些目录挂载为匿名卷，这样在运行时如果用户不指定挂载，其应用也可以正常运行，不会向容器存储层写入大量数据。

* **EXPOSE** #声明端口

```
EXPOSE <port1> [<port2>....]

```

> EXPOSE 指令是声明运行时容器提供服务端口，这只是一个声明，在运行时并不会因为这个声明应用就会开启这个端口的服务。在 Dockerfile 中写入这样的声明有两个好处，一个是帮助镜像使用者理解这个镜像服务的守护端口，以方便配置映射；另一个用处则是在运行时使用随机端口映射时，也就是 docker run -P 时，会自动随机映射 EXPOSE 的端口。

> 将 EXPOSE 和在运行时使用 -p <宿主端口>:<容器端口> 区分开来。-p，是映射宿主端口和容器端口，换句话说，就是将容器的对应端口服务公开给外界访问，而 EXPOSE 仅仅是声明容器打算使用什么端口而已，并不会自动在宿主进行端口映射。

* **WORKDIR** #指定工作目录

```
WORKDIR <path>

```

> 使用 WORKDIR 指令可以来指定工作目录（或者称为当前目录），以后各层的当前目录就被改为指定的目录，如该目录不存在，WORKDIR 会帮你建立目录。

* **USER** #指定当前用户

```
USER <username>

```

> USER 指令和 WORKDIR 相似，都是改变环境状态并影响以后的层。WORKDIR 是改变工作目录，USER 则是改变之后层的执行 RUN, CMD 以及 ENTRYPOINT 这类命令的身份。

> 当然，和 WORKDIR 一样，USER 只是帮助你切换到指定用户而已，这个用户必须是事先建立好的，否则无法切换。

> **如果以 root 执行的脚本，在执行期间希望改变身份，比如希望以某个已经建立好的用户来运行某个服务进程，不要使用 su 或者 sudo，这些都需要比较麻烦的配置，而且在 TTY 缺失的环境下经常出错。建议使用 gosu。**

例:

```
RUN groupadd -r redis && useradd -r -g redis redis
# 下载 gosu
RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64" \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true
# 设置 CMD，并以另外的用户执行
CMD [ "exec", "gosu", "redis", "redis-server" ]

```


* **HEALTHCHECK** #容器健康检查，告诉 Docker 应该如何进行判断容器的状态是否正常

```
HEALTHCHECK [options] CMD <command> : 设置检查容器健康状态的命令

HEALTHCHECK NONE : 如果基础镜像有健康检查指令，使用这行屏蔽掉其健康检查指令

```

> HEALTHCHECK 支持下列选项：

--interval=<间隔> ：两次健康检查的间隔，默认为 30 秒；

--timeout=<时长> ：健康检查命令运行超时时间，如果超过这个时间，本次健康检查就被视为失败，默认30; 

--retries=<次数> ：当连续失败指定次数后，则将容器状态视为 unhealthy，默认 3 次。

> 和 CMD, ENTRYPOINT 一样，HEALTHCHECK 只可以出现一次，如果写了多个，只有最后一个生效。

例:有个镜像是个最简单的 Web 服务，希望增加健康检查来判断其 Web 服务是否在正常工作，可以用 curl 来帮助判断，其 Dockerfile 的 HEALTHCHECK 可以这么写

```
FROM nginx
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl -fs http://localhost/ || exit 1

```

设置了每 5 秒检查一次（实际应该相对较长），如果健康检查命令超过 3 秒没响应就视为失败，并且使用 curl -fs http://localhost/ || exit 1 作为健康检查命令。

> 为了帮助排障，健康检查命令的输出（包括 stdout 以及 stderr）都会被存储于健康状态里，可以用 docker inspect 来查看。

```
docker inspect --format '{{json .State.Health}}' web | python -m json.tool

{
     "FailingStreak": 0,
         "Log": [
                 {
                   "End": "2016-11-25T14:35:37.940957051Z",
                   "ExitCode": 0,
                   "Output": "<!DOCTYPE html>\n<html>\n<head>\n<title>Welcome to nginx!</title>\n<style>\n    body {\n        width: 35em;\n        margin: 0 auto;\n        font-family: Tahoma, Verdana, Arial, sans-serif;\n    }\n</style>\n</head>\n<body>\n<h1>Welcome to nginx!</h1>\n<p>If you see this page, the nginx web server is successfully installed and\nworking. Further configuration is required.</p>\n\n<p>For online documentation and support please refer to\n<a href=\"http://nginx.org/\">nginx.org</a>.<br/>\nCommercial support is available at\n<a href=\"http://nginx.com/\">nginx.com</a>.</p>\n\n<p><em>Thank you for using nginx.</em></p>\n</body>\n</html>\n",
                   "Start": "2016-11-25T14:35:37.780192565Z"
                  }
                 ],
                 "Status": "healthy"
}

```

* **ONBUILD** # ONBUILD 是一个特殊的指令，它后面跟的是其它指令，比如 RUN, COPY 等，而这些指令，在当前镜像构建时并不会被执行。只有当以当前镜像为基础镜像，去构建下一级镜像的时候才会被执行。

```
ONBUILD <其他指令>

```







