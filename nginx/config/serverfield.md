# Nginx-server域配置

例:

```
server {
    listen          80;
    server_name     xx;

    access_log  logs/xx.access.log main;

    location / {
        root  www;
        index index.html index.htm;
        
    } 
	recursive_error_pages on;		
	error_page 503 		 /503.html;	
}

```

------

* **listen**  #监听端口

------

* **server_name**  #服务器名称，IP或域名，多个用空格分隔或再写一行server_name

------

* **access_log** : 设置访问日志，参数为日志位置及日志格式，日志格式通过log_format设置

------

* **location** : 访问url路径匹配

------

* **recursive_error_pages** : 作用是控制error_page能否在一次请求中触发多次

------

* **error_page 503   /503.html** : 当发生错误的时候能够显示一个预定义的uri，实际上产生了一个内部跳转(internal redirect)，当访问出现503的时候就能返回503.html中的内容。

------
