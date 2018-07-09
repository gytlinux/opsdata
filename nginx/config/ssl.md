# Nginx-ssl

例:

```
server {
        listen       443 ssl http2; 
        server_name  xx;

	    ssl		on; 
        ssl_certificate     xx.crt;
        ssl_certificate_key  xx.key;
	    ssl_session_timeout  5m; 
	    ssl_session_cache shared:SSL:10m; 
        ssl_protocols    TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers          ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
        ssl_prefer_server_ciphers on;
		
} 

```

------

* **listen** :设置ssl-https访问需设置监听端口为443

------

* **ssl on** : 开启ssl加密安全访问

------

* **ssl_certificate** : 指定ssl证书

------

* **ssl_certificate_key** : 指定ssl证书密钥

------

* **ssl_session_timeout  5m** : 客户端可以重用会话缓存中ssl参数的过期时间，内网系统默认5分钟太短了，可以设成30m即30分钟甚至4h。

------

* **ssl_session_cache** : 设置ssl/tls会话缓存的类型和大小。如果设置了这个参数一般是shared，buildin可能会参数内存碎片，默认是none，和off差不多，停用缓存。如shared:SSL:10m表示我所有的nginx工作进程共享ssl会话缓存，官网介绍说1M可以存放约4000个sessions。 

------

* **ssl_protocols** : 用于启动特定的加密协议，nginx在1.1.13和1.0.12版本后默认是ssl_protocols SSLv3 TLSv1 TLSv1.1 TLSv1.2，TLSv1.1与TLSv1.2要确保OpenSSL >= 1.0.1 ，SSLv3 现在还有很多地方在用但有不少被攻击的漏洞。

------

* **ssl_ciphers** : 选择加密套件，不同的浏览器所支持的套件（和顺序）可能会不同。这里指定的是OpenSSL库能够识别的写法，你可以通过 openssl -v cipher 'RC4:HIGH:!aNULL:!MD5'（后面是你所指定的套件加密算法） 来看所支持算法。

------

* **ssl_prefer_server_ciphers on;** : 设置协商加密算法时，优先使用我们服务端的加密套件，而不是客户端浏览器的加密套件。

------

