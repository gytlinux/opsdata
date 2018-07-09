# Nginx-download 

实现nginx下载功能

例:

```

autoindex  on;
autoindex_exact_size off;
autoindex_localtime on;

limit_rate_after 1m;
limit_rate  100k;
allow 192.168.1.0/24;
deny all;


```

------

* **autoindex  on** : 开启nginx目录浏览功能

------

* **autoindex_exact_size off** : 文件大小从KB开始显示,默认为on，显示出文件的确切大小，单位是bytes,改为off后，显示出文件的大概大小，单位是kB或者MB或者GB

------

* **autoindex_localtime on** : 显示文件修改时间为服务器本地时间

------

* **limit_rate_after** : 下载到你指定的文件大小之后开始限速

------

* **limit_rate**  : 限制文件最高下载速度

------

* **allow 192.168.1.0/24** : 添加允许访问下载 IP 地址段

------

* **deny  all** :禁止访问下载

------

