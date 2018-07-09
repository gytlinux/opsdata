# Nginx-client配置

nginx客户端请求配置

例:

```
client_header_timeout 10 ;
client_body_timeout 10 ;
client_header_buffer_size 4k;
large_client_header_buffers 8 128k;
client_max_body_size 50m;
client_body_buffer_size 256k;
client_body_in_file_only  on;
client_body_temp_path /opt/;

```

------

* **client_header_timeout** : 设置请求头的超时时间。

------

* **client_body_timeout** : 设置请求体的超时时间。

------

* **client_header_buffer_size** : 客户端请求头部的缓冲区大小，这个可以根据你的系统分页大小来设置，一般一个请求头的大小不会超过1k，不过由于一般系统分页都要大于1k，所以这里设置为分页大小。但也有client_header_buffer_size超过4k的情况，但是client_header_buffer_size该值必须设置为 “系统分页大小”的整倍数。分页大小可以用命令 getconf PAGESIZE 取得。

------

* **large_client_header_buffers** : 客户请求头缓冲大小nginx默认会用client_header_buffer_size这个buffer来读取header值，如果header过大，它会使用large_client_header_buffers来读取如果设置过小HTTP头/Cookie过大 会报400 错误nginx 400 bad request求行如果超过buffer，就会报HTTP 414错误(URI Too Long)nginx接受最长的HTTP头部大小必须比其中一个buffer大，否则就会报400的HTTP错误(Bad Request)。 

------

* **client_max_body_size** : 允许客户端请求的最大单文件字节数

------

* **client_body_buffer_size** : 缓冲区代理缓冲用户端请求的最大字节数

------

* **client_body_in_file_only** : 设置为On 可以讲client post过来的数据记录到文件中用来做debug

------

* **client_body_temp_path** : 设置记录文件的目录 可以设置最多3层目录

------

