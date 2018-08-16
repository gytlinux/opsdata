# Shell - sysdig系统监控工具

当需要追踪某个进程产生和接收的系统调用时用strace。使用tcpdump的命令行工具来监控原始网络通信。碰到必须追踪打开的文件的需求会使用lsof。strace、tcpdump和lsof是必备的工具，而sysdig它是一个强大的开源工具，用于系统级别的勘察和排障，可以称之“strace+tcpdump+lsof+lua的集合”，sysdig的最棒特性之一在于，它不仅能分析Linux系统的“现场”状态，也能将该状态保存为转储文件以供离线检查。更重要的是，可以自定义sysdig的行为，或者甚至通过内建的（你也可以自己编写）名为凿子（chisel）的小脚本增强其功能。单独的凿子可以以脚本指定的各种风格分析sysdig捕获的事件流。


## Install

* 一、centos7安装

```
yum -y install yum-utils
# 下载key并导入
rpm --quiet --import https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public
# 下载repo仓库
curl -s -o /etc/yum.repos.d/draios.repo https://s3.amazonaws.com/download.draios.com/stable/rpm/draios.repo
#下载sysdig包
yumdownloader sysdig
#安装sysdig包
yum localinstall -y sysdig-0.8.0-17.el7.art.x86_64.rpm
#检测相应的ko文件
/usr/bin/sysdig-probe-loader
#将检测的ko文件下载到~/.sysdig/目录内
cd ~/.sysdig
wget https://s3... .ko
#加载内核模块
/usr/bin/sysdig-probe-loader
lsmod |grep sysdig
 > sysdig_probe          446255  0
至此安装完毕

```

* 二、脚本安装

```
sudo curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig | sudo bash

```

## 使用

* 选项

```
-s   指定缓存达到多少字节时保存到磁盘，也就是一行只保留多少字节。
-w file.scap    把追踪到的数据保存在文件 注意 文件只能用 sysdig命令 才能查看。
-r file.scap     阅读保存的数据文件。
-cl  列出可以使用的 chisel，chisel 名为凿子 是一种分析脚本，sysdig自带的，也可以自己创建。
-c chiselName    指定使用 chiselName的脚本来分析数据。
-A (--print-ascii)   表示只打印数据中的文本部分 ，人可以直接读取的部分。
-b (--print-base64)  以base64的格式打印数据，这个对于需要把数据给别的工具分析比较有用。
-l    可以查看 一个域的用法 比如 sysdig -l fd 。

```

* 示例

```

网络:

#查看所有本机发出的以get方式请求的http请求
sysdig -s 2000 -A -c echo_fds fd.port=80 and evt.buffer contains GET

#查看进程占用的网络带宽占比
sysdig -c topprocs_net

#查看读写活跃的文件目录排名
sysdig -c fdbytes_by fd.directory "fd.type=file"

#查看cpu使用排名
sysdig -c topproces_cpu

#获取机器的所有数据流，并将数据存储在文件中
sysdig -s 4096 -w file.scap

#显示主机192.168.0.1的网络传输数据
sysdig -s2000 -X -c echo_fds fd.cip=192.168.0.1
sysdig -s2000 -A -c echo_fds fd.cip=192.168.0.1

#查看连接最多的服务器端口
sysdig -c fdbytes_by fd.sport

#查看客户端连接最多的ip：
sysdig -c fdbytes_by fd.cip


I/O

#查看磁盘io排名,查看使用硬盘带宽最多的进程：
sysdig -c topprocs_file


#列出使用大量文件描述符的进程
sysdig -c fdbytes_by proc.name

#根据读取+写入字节查看顶级文件
sysdig -c topfiles_bytes

#打印apache一直在阅读或写入的顶级文件
sysdig -c topfiles_bytes proc.name=httpd

#根据R + W磁盘活动查看顶级目录
sysdig -c fdbytes_by fd.directory

#请参阅/ tmp目录中有关R + W磁盘活动的顶级文件
sysdig -c fdbytes_by fd.filename "fd.directory=/tmp/"

#观察名为'passwd'的所有文件的I / O活动
sysdig -A -c echo_fds "fd.filename=passwd" 

#按FD类型显示I/O活动
sysdig -c fdbytes_by fd.type 


```

[常用命令](https://blog.csdn.net/yejingtao703/article/details/79968764)




