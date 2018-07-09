# expect 

**expect是linux中的一个用来处理交互的命令。借助Expect，我们可以将交互过程写在一个脚本上，使之自动化完成。形象的说，ssh登录，ftp登录等都符合交互的定义。**

### 主要命令

* spawn :用spawn命令启动一个新进程，通过其他命令如expect，send等与新进程进行交互

* expect : expect通常是用来等待一个进程的反馈。expect可以接收一个字符串参数，也可以接收正则表达式参数。和send命令结合;

* send : send命令接收一个字符串参数，并将该参数发送到进程。

* interact : 停止自动交互，转为用户交互

### 例:

```
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub user@ip
set timeout 300
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "password\r"; exp_continue }
}
catch wait result
exit [ lindex $result 3]

```

#### expect执行的spawn结果返回值，也就是shell $?的值

* catch wait result : 将wait命令的返回值存储到result变量中. result变量并不是一个特殊变量, 可以随意换一个新名字

> 备注：wait命令的返回值是一个"%d %s 0 %d"格式的字符串,第0个值是pid,第1个是spawn_id,第2个代表脚本是否正常完成,第3个是子进程的返回值.

* exit [ lindex $result 3 ] : 将result变量(这个变量存储的是一个列表)list中的index=3的那个值取出来，返回它。你可以搜索"Tcl 列表 lindex"以查看详细信息。


* 注:在shell脚本中调用执行expect

```
#!/bin/bash

...
...
/usr/bin/expect <<!
spawn ...
set timeout 300
expect ...
...
exit [ lindex \$result 3] 
!

```



