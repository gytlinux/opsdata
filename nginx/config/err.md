# Nginx-err

nginx错误页面处理

例

```
recursive_error_pages on;
		
error_page 503 		 /503.html	
error_page 404 = /404.php;

```

------

* **recursive_error_pages** : 作用是控制error_page能否在一次请求中触发多次

------

* **error_page** : 当发生错误的时候能够显示一个预定义的uri，实际上产生了一个内部跳转(internal redirect)，将对应的错误页面响应给客户端

------

### error_page 处理

* 当error_page后面跟的不是一个静态的内容的话，比如是由proxyed server或者FastCGI/uwsgi/SCGI server处理的话，server返回的状态(200, 302, 401 或者 404）也能返回给用户。

* 也可以设置一个named location，然后在里边做对应的处理。
 
```
error_page 500 502 503 504 @jump_to_error;
location @jump_to_error {    
    ...
}

```

* 同时也能够通过使客户端进行302、301等重定向的方式处理错误页面，默认状态码为302。

```
error_page 403      http://example.com/forbidden.html;
error_page 404 =301 http://example.com/notfound.html; 

``` 

* 同时error_page在一次请求中只能响应一次，对应的nginx有另外一个配置可以控制这个选项：recursive_error_pages默认为false，作用是控制error_page能否在一次请求中触发多次。

