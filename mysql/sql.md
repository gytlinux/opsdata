# SQL 语句整理

## 配置

* 字符编码

```
[mysql]
default-character-set=utf8

[mysqld]
character-set-server=utf8
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

describe <table-name>;  //查看table-name表的结构信息

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

