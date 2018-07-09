# Nginx-location

nginx匹配请求进行处理

## Location 路径匹配

```
location [ = | ~ | ~* | ^~ ] uri { ... }
location @name {...}

```

* =   //精确匹配，uri必须相等才会匹配

* ~   //区分大小写匹配，uri字符大小写一致匹配

* ~*  //忽略大小写匹配，uri字符相等，大小写不一致也可以匹配

* ^~  //开头匹配，匹配以uri开头的路径请求

* @   //内部跳转


## Rewrite


## Alias 目录别名

nginx指定文件路径有两种方式root和alias

* root 

> 配置段在http、server、location、if

```
root path

```

* alias 

> 配置段仅在location

```
alias path

```

root与alias主要区别在于nginx如何解释location后面的uri，这会使两者分别以不同的方式将请求映射到服务器文件上。alias是一个目录别名的定义，root则是最上层目录的定义。

* root处理结果: root路径+location路径

```
location ^~ /test/ {
    root  /www/;
}

//请求uri为/test/a.html时，服务器会返回/www/test/a.html文件

```

* alias处理结果: alias路径替换location路径

```
location ^~ /test/ {
    alias  /www/outher/;
}

//请求uri为/test/a.html时，服务器返回/www/outher/a.html

```

* **注意**
  - 使用alias，目录名后一定要加“/”
  - alias使用正则匹配时，必须捕捉要匹配的内容并在指定内容处使用
  - alias只能位于location域中


