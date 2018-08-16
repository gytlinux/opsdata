# SQL 语句整理

## 配置

#### 字符编码

* my.cnf配置文件设置

```
[mysql]
default-character-set=utf8  

[mysqld]
character-set-server=utf8 

```

* 登陆数据库设置

```
mysql> show variables like '%char%';  -查看 MySQL 数据库服务器和数据库字符集。
mysql> set <variable-name>='utf8';  -通过上一条命令查出variablename进行设定
mysql> show table status from <basename> like 'tablename|%|%string%';  -查看 MySQL 数据表（table） 的字符集。
mysql> show full columns from <tablename>;  -查看 MySQL 数据列（column）的字符集。
mysql> show charset;  --查看当前安装的 MySQL 所支持的字符集。
mysql>alter database <basename> character set <utf-8>; -修改数据库字符集
mysql>create database <basename> character set <utf-8>;  -创建数据库指定字符集

```

#### 日志设置

* 配置文件

```
log_error = /var/log/mysql/error.log   //错误日志
log_bin                 = /var/log/mysql/mysql-bin.log  //二进制日志

```

* 数据库操作

```
show variables like 'log_bin';   //查看是否开启二进制日志，ON表示开启
show binary logs;   //查看所有二进制日志文件
show master logs;   //查看所有二进制日志文件
show master status;  //查看当前二进制文件状态
show binlog events;  //在二进制日志中显示事件
--SHOW BINLOG EVENTS[IN 'log_name'] [FROM pos] [LIMIT [offset,] row_count]
--show binlog events in 'DB-Server-bin.000012' from 336;

flush logs      //切换二进制日志
reset master    //删除所有二进制日志文件
purge binary logs  //删除部分二进制日志文件（当前不存在主从复制关系）
--purge binary logs to log_name;   //删除某个日志之前的所有二进制日志文件
--purge binary logs before '2017-03-10 10:10:00'; //清除某个时间点以前的二进制日志文件
--purge master logs before date_sub( now( ), interval 7 day); //清除7天前的二进制日志文件

```

* 命令查看

```
mysqlbinlog log_name

```

#### 账户

* root 
  
```
//忘记密码
mysqladmin shutdown  -停止mysql服务器
mysqld_safe --skip-grant-tables --skip-networking &   -跳过授权表执行MYSQL服务器
mysql   -之间登陆客户端
use mysql  -进mysql库
update user set password='' where user='root'   -将root密码设为空 
update user set password=password('密码') where user='root'   -重新设定root密码

```

* 用户授权创建

```
//创建一个在basename中tablename表中拥有所有权限的用户
grant all on <basename|*>.<tablename|*> to username@'<ip|%>' identified by 'password';
flush privileges

```

#### 数据备份

```
mysqldump -uroot -ppwd  [db] [table1] [table2]... > name.sql   -备份数据库中的表
mysqldump -uroot -ppwd  --database [db1] [db2]...   > name.sql  -备份多个数据库
mysqldump -uroot -ppwd  --all-database  > name.sql  -备份所有数据库
mysqldump -uroot -ppwd -T /tmp [db]  --fields-terminated-by ','  -备份数据库的所有表为逗号分割的文本，备份到 /tmp:    

//恢复
mysql -uroot -p db_name < backfile
mysqlbinlog binlog-file | mysql -uroot -p

```

## 库(databases)

* 查看

```
show databases; //查看所有库

show database(); //查看当前所在库

show create database <database-name>; //查看数据库的字符集
```

* 创建

```
create database [if not exists] <base-name> //如果不存在base-name库则创建
create database <base-name> default charset=utf8;  //创建库时设置字符集为utf8
create database <base-name> default character set utf8 collate utf8_general_ci;

```

## 表(tables)

* 查看

```
show tables; //查看当前库拥有的表
describe <table-name>;  //查看table-name表的结构信息，或简写desc <table-name>
show columns form <table-name>; //同上
show index from <table-name>; //所有指标的详细信息表，其中包括PRIMARY KEY

```

* 创建

```
create table [if not exists] <table-name> ( id int not null auto_increment, name varchar(100) not null, createdate date  ,primary key ( id ))engine=InnoDB  default charset=utf8;

```

* 插入数据

```
insert into <table-name> set <values>

insert ignore into <table-name> (id,name,..) values (v1,v2,..)  //如果表中存在数据id=v1，name=v2，则不插入数据，不存在插入新数据


```

* 查询数据

```
select * from <table-name>  //查看表的所有数据

select * from <table-name> where id=1   //查看表中id项中值为1的所有数据

select id from <table-name>; //仅查看表中id项的内容

select distinct id from <table-name>  //查看表中id项去重后的内容

select count(1) from <table-name>  //查询表中总有多少条数据


```

* 修改

```
alter database <base-name> character set utf8mb4; //修改数据库字符集

alter table <table-name> add column <new-column> after <column>  //向表中添加指定的列，<new-column>指定新的列的名称及属性 ,after <column> 指定在表中已有的列后添加

alter table <table-name> drop column <column-name>  //删除表中的指定的列

alter table <table-name> rename to <new-table-name> //表重命名

alter table <table-name> change column <column-name> <new-column-name or datatype>  //更改表中指定列的属性，包括列名，数据类型，值等


```







## 其他语句

* 查询版本

```
select version();

```

* 查询当前时间

```
select current_date;  //时间为: YY-MM-DD
select now();         //时间为: YY-MM-DD HH:MM:SS
select current_timestamp //时间为: YY-MM-DD HH:MM:SS

```

* 查询当前用户

```
select user();

```

* 查看数据库字符情况

```
show variables like 'char%';

```







## 逻辑应用语句

* if not exists | if exists  //判断存不存在

* order by <字段> desc  //以字段排序，倒序输出数据

