# Nginx-global

nginx全局配置

```
user 		nginx  nginx;
pid        /var/run/nginx.pid;
error_log  logs/error.log  info;

worker_processes  	2;
worker_priority   [-20,20];
worker_rlimit_nofile 20480;

events {
	     worker_connections 2048;
	     multi_accept on;
	     use epoll;
	}

include  [config-file-path]
load_module [module-file-path]

```

------

* **user** : nginx运行的用户,用户组

------

* **pid** : nginx进程文件路径

------

* **error_log**  : 全局错误日志类型，从高到低[ debug | info | notice | warn | error | crit ]

------

* **worker_processes** : nginx对外提供web服务时的worder进程数。最优值取决于许多因素，包括（但不限于）CPU核的数量、存储数据的硬盘数量及负载模式。不能确定的时候，将其设置为可用的CPU内核数将是一个好的开始（设置为“auto”将尝试自动检测它）。

------

* **worker_priority** : 指定worker进程的nice值，设定worker进程优先级：[-20,20]，值越小，优先级越高

------

* **worker_rlimit_nofile**  #更改worker进程的最大打开文件数限制。如果没设置的话，这个值为操作系统的限制。设置后你的操作系统和Nginx可以处理比“ulimit -a”更多的文件，所以把这个值设高，这样nginx就不会有“too many open files”问题了

> 查看linux系统文件描述符的方法

```
[root@gl ~]# sysctl -a | grep fs.file
fs.file-max = 98572
fs.file-nr = 864	0	98572

```

------

* **event** : 事件驱动设置

------

* **worker_connections**  #设置可由一个worker进程同时打开的最大连接数。如果设置了上面提到的worker_rlimit_nofile，我们可以将这个值设得很高。最大客户数也由系统的可用socket连接数限制（~ 64K），所以设置不切实际的高没什么好处。 

------

* **multi_accept**  #告诉nginx收到一个新连接通知后接受尽可能多的连接。 

------

* **use**  #设置用于复用客户端线程的轮询方法。如果你使用Linux 2.6+，你应该使用epoll。如果你使用*BSD，你应该使用kqueue。

------

* **include**  : 指明需包含的其他配置文件,根据其他配置文件配置内容,可在全局,http域或server域指定

------

* load_module** : 指明要加载的动态模块路径，需nginx版本在1.9.11或更新

------
