# Nginx

Nginx（发音同engine x）是一个异步框架的 Web服务器，也可以用作反向代理，负载平衡器 和 HTTP缓存。该软件由 Igor Sysoev 创建，并于2004年首次公开发布。同名公司成立于2011年，以提供支持.

Nginx是一款免费的开源软件，根据类BSD许可证的条款发布。一大部分Web服务器使用Nginx，通常作为负载均衡器。

Nginx可以部署在网络上使用FastCGI脚本、SCGI处理程序、WSGI应用服务器或Phusion乘客模块的动态HTTP内容，并可作为软件负载均衡器.

Nginx使用异步事件驱动的方法来处理请求。Nginx的模块化事件驱动架构,可以在高负载下提供更可预测的性能。

Nginx是一款面向性能设计的HTTP服务器，相较于Apache、lighttpd具有占有内存少，稳定性高等优势。与旧版本（<=2.2）的Apache不同，Nginx不采用每客户机一线程的设计模型，而是充分使用异步逻辑从而削减了上下文调度开销，所以并发服务能力更强。整体采用模块化设计，有丰富的模块库和第三方模块库，配置灵活。 在Linux操作系统下，Nginx使用epoll事件模型，得益于此，Nginx在Linux操作系统下效率相当高。同时Nginx在OpenBSD或FreeBSD操作系统上采用类似于epoll的高效事件模型kqueue。

可大量并行处理,Nginx在官方测试的结果中，能够支持五万个并行连接，而在实际的运作中，可以支持二万至四万个并行链接。


### 基础配置

* [nginx全局配置](config/global.md)

* [nginx http域基础配置](config/httpfield.md)

* [nginx server域基础配置](config/serverfied.md)

* [nginx 客户端请求配置](config/client.md)

### 功能配置

* [nginx网页压缩](config/gzip.md)

* [nginx动态语言解析fastcgi](config/fastcgi.md)

* [nginx负载均衡](config/load.md)

* [nginx下载服务器设置](config/download.md)

* [nginx缓存配置](config/cache.md)

* [nginx代理缓冲设置](config/buffer.md)

* [nginx反向代理](config/proxy.md)

* [nginx ssl-https安全加密访问](config/ssl.md)

* [nginx error_page处理](config/err.md)

### 其他信息

* [nginx内置变量](info/var.md)

* [了解-web缓存网页标头](info/webcache.md)

* [nginx 相关文章](info/link.md)

