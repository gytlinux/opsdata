# Nginx-http域配置

例:

```
http {
	include       mime.types;
	default_type  application/octet-stream;
	charset utf-8;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

	server_tokens      off;
	sendfile            on;
	tcp_nopush on;
	tcp_nodelay on;
	
	keepalive_timeout   60;
	keepalive_requests 20;
	keepalive_disabled  msie6 safari;
	reset_timedout_connection on;
	send_timeout 10 ;
	
	limit_conn_zone $binary_remote_addr zone=addr:5m;
	limit_conn addr 100;

	server_names_hash_bucket_size 128;

    server{...}
}

```

------

* **include** : 在当前文件中包含另一个文件内容的指令。这里我们使用它来加载稍后会用到的一系列的MIME类型。

------

* **default_type** : 设置文件使用的默认的MIME-type。

------

* **charset** : 设置我们的头文件中的默认的字符集

------

* **log_format** :定义日志格式，以便在随后的访问日志配置调用

------

* **server_tokens** : 并不会让nginx执行的速度更快，但它可以关闭在错误页面中的nginx版本数字，这样对于安全性是有好处的。server_tokens 并不会让nginx执行的速度更快，但它可以关闭在错误页面中的nginx版本数字，这样对于安全性是有好处的。

------

* **sendfile** : 高效文件传输，可以让sendfile()发挥作用。sendfile()可以在磁盘和TCP socket之间互相拷贝数据(或任意两个文件描述符)。Pre-sendfile是传送数据之前在用户空间申请数据缓冲区。之后用read()将数据从文件拷贝到这个缓冲区，write()将缓冲区数据写入网络。sendfile()是立即将数据从磁盘读到OS缓存。因为这种拷贝是在内核完成的，sendfile()要比组合read()和write()以及打开关闭丢弃缓冲更加有效

------

* **tcp_nopush** : 告诉nginx在一个数据包里发送所有头文件，而不一个接一个的发送

------

* **tcp_nodelay** : 告诉nginx不要缓存数据，而是一段一段的发送--当需要及时发送数据时，就应该给应用设置这个属性，这样发送一小块数据信息时就不能立即得到返回值。

------

* **keepalive_timeout** : 给客户端分配keep-alive链接超时时间。服务器将在这个超时时间过后关闭链接。

------

* **keepalive_requests** : 设定了使用keepalive连接的请求数量上限。当使用keepalive连接的请求数量超过这个上限时，web服务器关闭keepalive连接。默认值为100，可以在http, server 和 location模块中定义。

------

* **keepalive_disabled** : 针对特定的浏览器关闭keepalive连接。默认值为msie6。可以在http, server 和 location模块中定义。

------

* **reset_timedout_connection** : 告诉nginx关闭不响应的客户端连接。这将会释放那个客户端所占有的内存空间。

------

* **send_timeout** : 指定客户端的响应超时时间。这个设置不会用于整个转发器，而是在两次客户端读取操作之间。如果在这段时间内，客户端没有读取任何数据，nginx就会关闭连接。

------

* **limit_conn_zone** : 设置用于保存各种key（比如当前连接数）的共享内存的参数。5m就是5兆字节，这个值应该被设置的足够大以存储（32K*5）32byte状态或者（16K*5）64byte状态。

------

* **limit_conn** : 为给定的key设置最大连接数。这里key是addr，我们设置的值是100，也就是说我们允许每一个IP地址最多同时打开有100个连接。

------

* **server_names_hash_bucket_size** : 服务器名字的hash表大小

------


* **server{...}** : http域包含server域
