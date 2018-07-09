# Nginx-proxy 代理

## proxy代理设置

### http域

```
	proxy_connect_timeout 90; 
	proxy_read_timeout 180;
	proxy_send_timeout 180;
	proxy_ignore_client_abort on;
	proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504 http_404 ;
	proxy_cookie_domain off;
	proxy_cookie_path off;
	proxy_hide_header field;
	proxy_http_version 1.0 | 1.1;
	proxy_ignore_headers field ...;
	proxy_intercept_errors on | off;
	proxy_pass_header field;
	proxy_ssl_session_reuse on | off;
    
    server{
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr; //X-Real-IP 被设置成客户端的 IP 地址，以便代理服务器做判定或者记录基于该信息的日志。

        proxy_set_header REMOTE-HOST $remote_addr;

        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;//X-Forwarded-For 是一个包含整个代理过程经过的所有服务器 IP 的地址列表。设置成 $proxy_add_x_forwarded_for 变量。这个变量包含了从客户端获取的 X-Forwarded-For 和 Nginx 服务器的 IP（按照 request 的顺序）。
        proxy_set_header X-Forwarded-Proto https;   
        proxy_pass      http://ip:port;        
        }

```

------

* **proxy_connect_timeout** : 后端服务器连接的超时时间_发起握手等候响应超时时间

------

* **proxy_read_timeout** : 连接成功后_等候后端服务器响应时间_其实已经进入后端的排队之中等候处理（也可以说是后端服务器处理请求的时间）

------

* **proxy_send_timeout** : 后端服务器数据回传时间_就是在规定时间之内后端服务器必须传完所有的数据

------

* **proxy_ignore_client_abort** : 客户端主动断掉连接之后，Nginx 会等待后端处理完(或者超时)，然后记录「后端的返回信息」 到日志。

------

* **proxy_next_upstream** : 指定在何种情况下一个失败的请求应该被发送到下一台后端服务器:
  - error - 和后端服务器建立连接时，或者向后端服务器发送请求时，或者从后端服务器接收响应头时，出现错误;
  - timeout - 和后端服务器建立连接时，或者向后端服务器发送请求时，或者从后端服务器接收响应头时，出现超时；
  - invalid_header - 后端服务器返回空响应或者非法响应头；
  - http_500 - 后端服务器返回的响应状态码为500；
  - http_502 - 后端服务器返回的响应状态码为502；
  - http_503 - 后端服务器返回的响应状态码为503；
  - http_504 - 后端服务器返回的响应状态码为504；
  - http_404 - 后端服务器返回的响应状态码为404；
  - off - 停止将请求发送给下一台后端服务器。
  - **需要理解一点的是，只有在没有向客户端发送任何数据以前，将请求转给下一台后端服务器才是可行的。也就是说，如果在传输响应到客户端时出现错误或者超时，这类错误是不可能恢复的。**

------

* **proxy_cookie_domain off** : 设置“Set-Cookie”响应头中的domain属性的替换文本。

------

* **proxy_cookie_path off** : 设置“Set-Cookie”响应头中的path属性的替换文本。

------

* **proxy_hide_header field** : nginx默认不会将“Date”、“Server”、“X-Pad”，和“X-Accel-...”响应头发送给客户端。proxy_hide_header指令则可以设置额外的响应头，这些响应头也不会发送给客户端。相反的，如果希望允许传递某些响应头给客户端，可以使用proxy_pass_header指令。

------

* **proxy_http_version 1.0 | 1.1** :设置代理使用的HTTP协议版本。默认使用的版本是1.0，而1.1版本则推荐在使用keepalive连接时一起使用。

------

* **proxy_ignore_headers field ...** : 不处理后端服务器返回的指定响应头。下面的响应头可以被设置： “X-Accel-Redirect”，“X-Accel-Expires”，“X-Accel-Limit-Rate” (1.1.6)，“X-Accel-Buffering” (1.1.6)， “X-Accel-Charset” (1.1.6)，“Expires”，“Cache-Control”，和“Set-Cookie” (0.8.44)。如果不被取消，这些头部的处理可能产生下面结果：
  - “X-Accel-Expires”，“Expires”，“Cache-Control”，和“Set-Cookie” 设置响应缓存的参数；
  - “X-Accel-Redirect”执行到指定URI的内部跳转；
  - “X-Accel-Limit-Rate”设置响应到客户端的传输速率限制；
  - “X-Accel-Buffering”启动或者关闭响应缓冲；
  - “X-Accel-Charset”设置响应所需的字符集。

------

* **proxy_intercept_errors on | off** : 当后端服务器的响应状态码大于等于400时，决定是否直接将响应发送给客户端，亦或将响应转发给nginx由error_page指令来处理。 

------

* **proxy_pass_header field** : 允许传送被屏蔽的后端服务器响应头到客户端

------

* **proxy_ssl_session_reuse on | off** : 决定是否重用与后端服务器的SSL会话。如果日志中出现“SSL3_GET_FINISHED:digest check failed”错误，请尝试关闭会话重用。

------

* **proxy_redirect  [ default|off|redirect replacement ]** : 对发送给客户端的URL进行修改，设置后端服务器“Location”响应头和“Refresh”响应头的替换文本。

------

* **proxy_set_header** : 允许重新定义或者添加发往后端服务器的请求头。value可以包含文本、变量或者它们的组合。 当且仅当当前配置级别中没有定义proxy_set_header指令时，会从上面的级别继承配置。 默认情况下，只有两个请求头会被重新定义proxy_set_header Host $proxy_host;proxy_set_header Connection close;

------

* **proxy_pass**  #设置后端服务器的协议和地址，还可以设置可选的URI以定义本地路径和后端服务器的映射关系。 这条指令可以设置的协议是“http”或者“https”，而地址既可以使用域名或者IP地址加端口（可选）的形式来定义

------

### 内嵌变量

ngx_http_proxy_module #支持内嵌变量，可以用于在proxy_set_header指令中构造请求头：

* $proxy_host    //后端服务器的主机名和端口；

* $proxy_port    //后端服务器的端口；

* $proxy_add_x_forwarded_for  //将$remote_addr变量值添加在客户端“X-Forwarded-For”请求头的后面，并以逗号分隔。 如果客户端请求未携带“X-Forwarded-For”请求头，$proxy_add_x_forwarded_for变量值将与$remote_addr变量相同。


## 将客户端真实IP转发给后端服务器

#### nginx代理设置

```
location / {
	proxy_pass http://ip:port;
	proxy_set_header Host $host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}

```

#### 后端服务器设置

* Nodejs

```
req.get("X-Real-IP") || req.get("X-Forwarded-For") || req.headers['x-real-ip'] || req.header['x-forwarded-for']

```

* Java

```
request.getHeader("X-Forwarded-For")或request.getHeader("X-Real-IP")

```

* Jetty

```
Jetty服务器的jetty.xml文件中，找到httpConfig，加入配置：
<New id="httpConfig" class="org.eclipse.jetty.server.HttpConfiguration">

    ...

  <Call name="addCustomizer">
    <Arg><New class="org.eclipse.jetty.server.ForwardedRequestCustomizer"/></Arg>
  </Call>
</New>

```

* Tomcat

```

配置Tomcat的server.xml文件，在Host元素内最后加入
<Valve className="org.apache.catalina.valves.RemoteIpValve" />

或：

<Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"  
 prefix="localhost_access_log." suffix=".txt"  
 pattern="%h  %{X-FORWARDED-FOR}i %l %u %t %r %s %b %D %q %{User-Agent}i  %T" resolveHosts="false" />

```

* Nginx

```
nginx.conf:

http{

	...
	set_real_ip_from 192.168.4.1;nginx代理服务器真实IP
	...
}


```

* Apache

```

Apache获取真实IP地址有2个模块： 
mod_rpaf：Apache-2.2支持；Apache-2.4不支持； 
mod_remoteip：Apache-2.4自带模块；Apache-2.2 支持

2.4-http.conf:
如下代码去掉注释，
#LoadModule remoteip_module modules/mod_remoteip.so
添加：
RemoteIPHeader X-Forwarded-For
RemoteIPInternalProxy 192.168.4.1 //IP为nginx代理服务器的地址

修改日志显示格式 ：
添加%a，日志中第二例显示真实IP
LogFormat "%h %a %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
LogFormat "%h %a %l %u %t \"%r\" %>s %b" common

```













