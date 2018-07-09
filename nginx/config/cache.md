# Nginx-cache 

nginx缓存配置

例:

```
http{
	proxy_cache_revalidate on;
	proxy_cache_lock on;
	proxy_cache_lock_timeout 5s;
	proxy_cache_path /usr/local/nginx/cache levels=1:2 keys_zone=mycache:20m max_size=2048m inactive=60m;
	proxy_cache_methods GET HEAD POST;
	proxy_cache_bypass $cookie_nocache $arg_nocache$arg_comment;
	proxy_no_cache $cookie_nocache $arg_nocache$arg_comment;
	proxy_cache_key $host$uri$is_args$args;
	proxy_cache_use_stale off;
	proxy_store on | off | string;
	proxy_store_access user:rw group:rw all:r;
    
	open_file_cache max=100000 inactive=20s;
	open_file_cache_valid 30s;
	open_file_cache_min_uses 2;
	open_file_cache_errors on;

    server{
        ...
	    	    
        proxy_cache_valid 200 302 10m;
        proxy_cache_min_uses 1;	
        proxy_cache  mycache;
        add_header Cache-Contorl "no-cache";

        ...
    }
}

```

------

* **proxy_cache_revalidate** : NGINX在刷新来自服务器的内容时使用GET请求。如果客户端的请求项已经被缓存过了，但是在缓存控制头部中定义为过期，#那么NGINX就会在GET请求中包含If-Modified-Since字段，发送至服务器端。这项配置可以节约带宽,因为对于NGINX已经缓存过的文件，服务器只会在该文件请求头中Last-Modified记录的时间内被修改时才将全部文件一起发送。

------

* **proxy_cache_lock** : 被启用时，当多个客户端请求一个缓存中不存在的文件（或称之为一个MISS），只有这些请求中的第一个被允许发送至服务器。其他请求在第一个请求得到满意结果之后在缓存中得到文件。如果不启用proxy_cache_lock，则所有在缓存中找不到文件的请求都会直接与服务器通信。

------

* **proxy_cache_lock_timeout** : 为proxy_cache_lock指令设置锁的超时。

------

* **proxy_cache_path** : 设置缓存目录；levels=1:2 设置目录深度，第一层目录是1个字符，第2层是2个字符,最多设定三层；keys_zone:设置web缓存名称和内存缓存空间大小；inactive:自动清除缓存文件时间(缓存时间限定最高级别)；max_size:硬盘空间最大可使用值。

------

* **proxy_cache_methods** : 指定GET|HEAD|POST方法的请求被缓存

------

* **proxy_cache_bypass** : 定义nginx不从缓存取响应的条件。如果至少一个字符串条件非空而且非“0”，nginx就不会从缓存中去取响应

------

* **proxy_no_cache** : 定义nginx不将响应写入缓存的条件。如果至少一个字符串条件非空而且非“0”，nginx就不将响应存入缓存

------

* **proxy_cache_key** : 定义如何生成缓存的键

------

* **proxy_cache_use_stale** : [error | timeout | invalid_header | updating | http_500 | http_502 | http_503 | http_504 | http_404 | off ...];如果后端服务器出现状况，nginx是可以使用过期的响应缓存的。这条指令就是定义何种条件下允许开启此机制。这条指令的参数与proxy_next_upstream指令的参数相同。此外，updating参数允许nginx在正在更新缓存的情况下使用过期的缓存作为响应。这样做可以使更新缓存数据时，访问源服务器的次数最少。在植入新的缓存条目时，如果想使访问源服务器的次数最少，可以使用proxy_cache_lock指令。

------

* **proxy_store on | off | string** : 开启将文件保存到磁盘上的功能。如果设置为on，nginx将文件保存在alias指令或root指令设置的路径中。如果设置为off，nginx将关闭文件保存的功能。此外，保存的文件名也可以使用含变量的string参数来指定	

------

* **proxy_store_access** : 设置新创建的文件和目录的访问权限

------

* **proxy_cache_valid** : 为不同的响应状态码设置不同的缓存时间。

------

* **proxy_cache_min_uses** : 设置响应被缓存的最小请求次数。

------

* **proxy_cache** : 启用缓存功能，反向代理缓存设置命令(proxy_cache zone|off,默认关闭所以要设置)

------ 

* **add_header Cache-Control "no-cache"** : 给请求的Headers添加Cache-Control:no-cache|no-store。来控制缓存

------

### open_file_cache高效静态缓存


* **open_file_cache** : 打开缓存的同时也指定了缓存最大数目，以及缓存的时间。我们可以设置一个相对高的最大时间，这样我们可以在它们不活动超过20秒后清除掉。

------

* **open_file_cache_valid** : 在open_file_cache中指定检测正确信息的间隔时间。

------

* **open_file_cache_min_uses** : 定义了open_file_cache中指令参数不活动时间期间里最小的文件数。

------

* **open_file_cache_errors** : 指定了当搜索一个文件时是否缓存错误信息，也包括再次给配置中添加文件。我们也包括了服务器模块，这些是在不同文件中定义的。如果你的服务器模块不在这些位置，你就得修改这一行来指定正确的位置。

------

