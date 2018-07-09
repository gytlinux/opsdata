# Nginx-FastCGI

实现nginx对动态脚本语言解析


## 例

```
fastcgi_cache_path /usr/local/nginx/fastcgi_cache levels=1:2 keys_zone=TEST:10minactive=5m;
fastcgi_connect_timeout 300;
fastcgi_send_timeout 300;
fastcgi_read_timeout 300;
fastcgi_buffer_size 4k;
fastcgi_buffers 8 4k;
fastcgi_busy_buffers_size 8k;
fastcgi_temp_file_write_size 8k;
fastcgi_cache TEST
fastcgi_cache_valid 200 302 1h; 
fastcgi_cache_min_uses 1;
fastcgi_cache_use_stale error timeout invalid_header http_500;
fastcgi_cache_methods GET HEAD POST;

```

------

* **fastcgi_cache_path** : 为FastCGI 缓存指定一个路径，目录结构等级，关键字区域存储时间和非活动删除时间。

------

* **fastcgi_connect_timeout** : 指定连接到后端FastCGI 的超时时间。

------

* **fastcgi_send_timeout** : 向FastCGI 传送请求的超时时间，这个值是指已经完成两次握手后向FastCGI 传送请求的超时时间。

------

* **fastcgi_read_timeout** : 接收FastCGI 应答的超时时间，这个值是指已经完成两次握手后接收FastCGI 应答的超时时间

------

* **fastcgi_buffer_size** : 指定读取FastCGI 应答第一部分需要用多大的缓冲区，一般第一部分应答不会超过1k，由于页面大小为4k，所以这里设置为4k。

------

* **fastcgi_buffers** : 指定本地需要用多少和多大的缓冲区来缓冲FastCGI 的应答。

------

* **fastcgi_busy_buffers_size** : 这个指令我也不知道是做什么用，只知道默认值是fastcgi_buffers 的两倍。

------

* **fastcgi_temp_file_write_size** : 在写入fastcgi_temp_path 时将用多大的数据块，默认值是fastcgi_buffers 的两倍。

------

* **fastcgi_cache TEST** : 开启FastCGI 缓存并且为其制定一个名称。个人感觉开启缓存非常有用，可以有效降低CPU 负载，并且防止502 错误。

------

* **fastcgi_cache_valid** : 为指定的应答代码指定缓存时间。

------

* **fastcgi_cache_min_uses** : 缓存在fastcgi_cache_path 指令inactive 参数值时间内的最少使用次数，如上例，如果在5 分钟内某文件1 次也没有被使用，那么这个文件将被移除。

------

* **fastcgi_cache_use_stale** : 定义[updating|error|timeout|invalid_header|http_500]情况下用过期缓存

------

* **fastcgi_cache_methods** : 定义缓存请求方式GET HEAD POST

------
