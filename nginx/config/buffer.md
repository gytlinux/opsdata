# Nginx-buffer代理缓冲

nginx代理缓冲设置

例:

```
http{
    proxy_buffering on;
	proxy_buffers 4 256k;
	proxy_buffer_size 256k;
	proxy_busy_buffers_size 256k;
	proxy_temp_file_write_size 256k;
	proxy_max_temp_file_size 1024m;
	proxy_temp_path /usr/local/nginx/cache/temp;
    
}
```

------

* **proxy_buffering** : 控制所在 context 或者子 context 的 buffer（缓冲） 是否打开。默认是 on。

------

* **proxy_buffers** : 设置用于读取应答（来自被代理服务器）的缓冲区数目和大小，默认情况也为一个分页大小，根据操作系统的不同可能是4k或者8k

------

* **proxy_buffer_size** : 设置从被代理服务器读取的第一部分应答的缓冲区大小，通常情况下这部分应答中包含一个小的应答头，默认情况下这个值的大小为指令proxy_buffers中指定的一个缓冲区的大小，不过可以将其设置为更小

------

* **proxy_busy_buffers_size** : 不是独立的空间，他是proxy_buffers和proxy_buffer_size的一部分。nginx会在没有完全读完后端响应的时候就开始向客户端传送数据，所以它会划出一部分缓冲区来专门向客户端传送数据(这部分的大小是由proxy_busy_buffers_size来控制的，建议为proxy_buffers中单个缓冲区大小的2倍)，然后它继续从后端取数据，缓冲区满了之后就写到磁盘的临时文件中。

------

* **proxy_temp_file_write_size** : 设置在写入proxy_temp_path时数据的大小，预防一个工作进程在传递文件时阻塞太长

------

* **proxy_max_temp_file_size 1024m** : 打开响应缓冲以后，如果整个响应不能存放在proxy_buffer_size和proxy_buffers指令设置的缓冲区内，部分响应可以存放在临时文件中。 这条指令可以设置临时文件的最大容量。而每次写入临时文件的数据量则由proxy_temp_file_write_size指令定义。将此值设置为0将禁止响应写入临时文件。

------

* **proxy_temp_path** : 指定临时缓存文件的存储路径(路径需和上面路径在同一分区)

------

