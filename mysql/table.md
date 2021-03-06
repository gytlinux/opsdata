# Create Table建表

## 建表的选项及约束限制

* 基本格式

```
create table 表名(列名 数据类型 约束 列选项)表选项;

```

#### 选项

* default :列选项,格式(default '值') 定义列的默认值，当插入一个新行到表中并且没有给该列明确赋值时，如果定义了列的默认值，将自动得到默认值 ；如果没有，则为null。

* comment : 可做列选项也可做表选项，格式(comment '注释')，做列选项用来给列添加注释，做表选项用来给表添加注释，最多255个字符，注释会保存到数据字典中。

* engine : 表选项，格式(engine=存储引擎)，指定表使用的存储引擎，"show engines;"查询所有支持的存储引擎

* auto_increment :自增值，格式(例:id int not null auto_increment直接在列选项处添加)决定当向表中插入第一行时，自增列得到的第一个值是多少

#### 约束

* not null :非空，指定列不为空

* unique : 唯一，指定某列和几列组合的数据不能重复

1.唯一约束是指定table的列或列组合不能重复，保证数据的唯一性，约束的列不允许有重复值；

2.唯一约束不允许出现重复的值，但是可以为多个null；

3.同一个表可以有多个唯一约束，多个列组合的约束

4.在创建唯一约束时，如果不给唯一约束名称，就默认和列名相同；

5.唯一约束不仅可以在一个表内创建，而且可以同时多表创建组合唯一约束。

> 例:

```
//单列设置唯一约束
create table  表名(id int not null unique,... unique);

//组合列约束(在unique(列名)内指定多个列名，当指定的所有列内的数据都相同时报错,不写入表，如有任意一项指定列数据不同，其他重复，则写入表)
create table 表名(name varchar(100) not null,passwd varchar(100) not null,unique(name,passwd));

```

**注:单列限制重复在定义列后设置unique;组合限制重复在定义所有列之后再单独添加unique(列名)**

* primary key : 主键约束，指定某列的数据不能重复、唯一

1.主键：用来唯一的标示表中的每一行(类型一般为整型或者字符串)

2.具有主键约束的列不允许有null值，并且不允许有重复值;

3.每个表最多只允许一个主键(可定义联合主键)，主键名总是PRIMARY。

**单列和组合列设置同unique**

* foreign key : 外键，指定该列记录属于主表中的一条记录，参照另一条数据

* check :检查，指定一个表达式，用于检验指定数据
