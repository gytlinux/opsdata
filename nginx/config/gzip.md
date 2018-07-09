# Nginx-gzip

实现nginx网页压缩功能

例

```
	gzip on;
	gzip_vary on;
	gzip_buffers 4 16k;
	gzip_disable "msie6" ;
	gzip_static on;
	gzip_proxied any;
	gzip_min_length 1000;
	gzip_comp_level 4;
	gzip_http_version 1.0;
	gzip_types text/plain application/x-javascript text/css application/xml;	

```

------

* **gzip  on|off** : 是否开启gzip压缩功能

------

* **gzip_vary** : 和http头有关系，加个vary头，给代理服务器用的，有的浏览器支持压缩，有的不支持，所以避免浪费不支持的也压缩，所以根据客户端的HTTP头来判断，是否需要压缩

------

* **gzip_buffers** : 设置gzip申请内存的大小,其作用是按块大小的倍数申请内存空间

------


* **gzip_disable** : 为指定的客户端禁用gzip功能。我们设置成IE6或者更低版本以使我们的方案能够广泛兼容。

------

* **gzip_static** : 设置对gz文件的识别。告诉nginx在压缩资源之前，先查找是否有预先gzip处理过的资源。这要求你预先压缩你的文件，从而允许你使用最高压缩比，这样nginx就不用再压缩这些文件了例如：在站点建立一个a.html文件，然后gzip a.html压缩文件生成了a.html.gz。当此选项打开时，用户可以浏览a.html.gz文件并生成a.html文件的内容。如果此项不开则提示找不到页面。

------

* **gzip_proxied** : Nginx做为反向代理的时候启用.允许或者禁止压缩基于请求和响应的响应流。

```
> param:[off|expired|no-cache|no-sotre|private|no_last_modified|no_etag|auth|any]
 
off – 关闭所有的代理结果数据压缩

expired – 启用压缩，如果header中包含”Expires”头信息

no-cache – 启用压缩，如果header中包含”Cache-Control:no-cache”头信息

no-store – 启用压缩，如果header中包含”Cache-Control:no-store”头信息

private – 启用压缩，如果header中包含”Cache-Control:private”头信息

no_last_modified – 启用压缩，如果header中包含”Last_Modified”头信息

no_etag – 启用压缩，如果header中包含“ETag”头信息

auth – 启用压缩，如果header中包含“Authorization”头信息

any – 无条件压缩所有结果数据

```

------


* **gzip_min_length** : 设置对数据启用压缩的最少字节数。如果一个请求小于1000字节，我们最好不要压缩它，因为压缩这些小的数据会降低处理此请求的所有进程的速度。

------

* **gzip_comp_level** : 设置数据的压缩等级。这个等级可以是1-9之间的任意数值，9是最慢但是压缩比最大的。

------

* **gzip_http_version** : 用于识别http协议的版本，早期的浏览器不支持gzip压缩，用户会看到乱码，所以为了支持前期版本加了此选项,目前此项基本可以忽略

------

* **gzip_types** : 设置需要压缩的数据格式。上面例子中已经有一些了，你也可以再添加更多的格式。

------

