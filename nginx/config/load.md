# nginx - load leveling

实现nginx负载均衡功能

例:

**注:定义负载均衡池须在nginx.conf文件中的 http 域**

```
upstream <name> {
	[ip_hash;|fair;]
	server host:port weight=<number>; // weight|down|backup|max_fails|fail_timeout
    ...
    }

```

------

* **upstream \<name\>** : 定义负载均衡池

------

* **id_hash** : 每个请求按访问IP的哈希结果分配，这样每个访客固定访问一个后端服务器，可以有效的解决动态网页存在的session共享问题。

------

* **fair** : 负载均衡算法根据后端服务器的响应时间来分配请求,需要Nginx的upstream_fair模块

------

* **weight**  : 权重，可以根据机器配置定义权重。weigth参数表示权值，权值越高被分配到的几率越大。

------

* **down** : 负载设备状态，表示当前server暂时不参与负载均衡。

------

* **backup** : 负载设备状态,预留的备份机，当其他所有非backup机器出现故障或者繁忙的时候，才会请求backup机器，这台机器的访问压力最轻。

------

* **max_fails** : 负载设备状态, 允许请求的失败次数，默认为1，配合fail_timeout一起使用

------

* **fail_timeout** : 负载设备状态, 经历max_fails次失败后，暂停服务的时间，默认为10s（某个server连接失败了max_fails次，则nginx会认为该server不工作了。同时，在接下来的 fail_timeout时间内，nginx不再将请求分发给失效的server。）

------


## nginx的负载分配

* 轮询（默认） : 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除。

* weight(权重) : 指定轮询几率，weight和访问比率成正比，用于后端服务器性能不均的情况。

* ip_hash : 每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器，可以解决session的问题。

* fair(第三方) : 更智能的一个负载均衡算法，此算法可以根据页面大小和加载时间长短智能地进行负载均衡，也就是根据后端服务器的响应时间来分配请求，响应时间短的优先分配。如果想要使用此调度算法，需要Nginx的upstream_fair模块

* url_hash(第三方) : 按访问URL的哈希结果来分配请求，使每个URL定向到同一台后端服务器，可以进一步提高后端缓存服务器的效率。如果想要使用此调度算法，需要Nginx的hash软件包。

> 例: 在upstream中加入hash语句，server语句中不能写入weight等其他的参数，hash_method是使用的hash算法

```
upstream backend {
	server squid1:3128;
	server squid2:3128;
	hash $request_uri;
	hash_method crc32;
}

```

## 调用 

**调用负载均衡池在nginx.conf文件 server 域配置调用**

```
proxy_pass http://bakend;

```
