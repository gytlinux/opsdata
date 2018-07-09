# web代理缓存相关概念

### Cache-Control : (常规标头,HTTP1.1)

* .public:(仅为响应标头)    

> 响应:告知任何途径的缓存者,可以无条件的缓存该响应.

* .private(仅为响应标头)    

> 响应:告知缓存者(据我所知,是指用户代理，常见浏览器的本地缓存.用户也是指,系统用户.但也许,不应排除,某些网关,可以识别每个终端用户的情况),只针对单个用户缓存响应. 且可以具体指定某个字段.如private –“username”,则响应头中，名为username的标头内容，不会被共享缓存.

* .no-cache:    

> 请求: 告知缓存者，必须原原本本的转发原始请求,并告知任何缓存者,别直接拿你缓存的副本,糊弄人.你需要去转发我的请求,并验证你的缓存(如果有的话).对应名词:端对端重载.    

> 响应: 允许缓存者缓存副本.那么其实际价值是,总是强制缓存者,校验缓存的新鲜度.一旦确认新鲜,则可以使用缓存副本作为响应. no-cache,还可以指定某个包含字段,比如一个典型应用,no-cache=Set-Cookie. 这样做的结果,就是告知缓存者,对于Set-Cookie字段,你不要使用缓存内容.而是使用新滴.其他内容则可以使用缓存.

* .no-store:    

> 请求:告知,请求和响应都禁止被缓存.(也许是出于隐私考虑)    

> 响应:同上.

* .max-age:    

> 请求:强制响应缓存者，根据该值,校验新鲜性.即与自身的Age值,与请求时间做比较.如果超出max-age值,则强制去服务器端验证.以确保返回一个新鲜的响应.其功能本质上与传统的Expires类似,但区别在于Expires是根据某个特定日期值做比较.一但缓存者自身的时间不准确.则结果可能就是错误的.而max-age,显然无此问题. Max-age的优先级也是高于Expires的.

> 响应:同上类似,只不过发出方不一样.

* .max-stale:    

> 请求:意思是,我允许缓存者，发送一个,过期不超过指定秒数的,陈旧的缓存.    

> 响应:同上.

* .must-revalidate(仅为响应标头)    

> 响应:意思是,如果缓存过了新鲜期，则必须重新验证.而不是试图返回一个不在新鲜期的缓存.与no-cache的区别在于,no-cache,完全无视新鲜期的概念.总是强制重新验证.理论上,must-revalidate更节省流量,但相比no-cache,可能并不总是那么精准.因为即使缓存者，认为是新鲜的,也不能保证服务器端没有做过更新.如果缓存者是一个缓存代理服务器,如果其试图重新验证时，无法连接上原始服务器,则也不允许返回一个不新鲜的,缓存中的副本.而是必须返回一个504 Gateway timeout.

* .proxy-revalidate(仅为响应标头)    

> 响应:限制上与must-revalidate类似.区别在于受体的范围.proxy-revalidate,是要排除掉用户代理的缓存的.即，其规则并不应用于用户代理的本地缓存上.

* .min-fresh(仅为请求标头)    

> 请求:告知缓存者,如果当前时间加上min-fresh的值,超了该缓存的过期时间.则要给我一个新的.其实个人觉得,其功能上有点和max-age类似.但是更大的是语义上的区别.

* .only-if-cached:(仅为请求标头)    

> 请求:告知缓存者,我希望内容来自缓存，我并不关心被缓存响应,是否是新鲜的.

* .s-maxage(仅为响应标头)    

> 响应:与max-age的唯一区别是,s-maxage仅仅应用于共享缓存.而不引用于用户代理的本地缓存,等针对单用户的缓存. 另外,s-maxage的优先级要高于max-age.

* .cache-extension 

> (cache-extension是一个泛化的代称.它指所有自定义，或者说扩展的,指令,客户端和服务器端都可以自定义扩展Cache-Control相关的指令.)    那么,实际上我们可以这样 Cache-Control:max-age=300, custom-directive = xxx, public. 这样我们就定义了一个被统称为cache-extension的扩展指令.该指令如果对应的客户端或服务器端，不认识,就会忽略掉.

> 扩展指令 中一个常见的东西是 none-check post-check 和 pre-check. 这玩意是IE5被加入的. 所以如果响应头中有这几个扩展指令,那么IE就会认得他们, 我经常在一些 为了解决 no-cache + gzip 命中ie6 JSONP 请求,导致脚本不执行bug的方案中见到这几个扩展指令，其目的是为了让IE放弃使用本地缓存.  我倒是觉得,对IE6放弃使用gzip,是更合理的做法.  当然缺点也很明显, 如果是cdn部署静态资源.显然这样做会很困难.

### bug描述:

> IE6,某些情况下,开启gzip的资源,会不渲染或不执行(如果是.js的话.)

> 会引发此bug的条件:

>  1. 首先,必须由a页面脚本导致跳转到b页面 : 即 a页面有 location.href = b页面.(点链接,form post,replace, assign等方式都会导致问题,包括target=_blank弹窗的情况)

> 2. b页面自身,或其使用动态创建脚本(硬编码script src=xxx 也会有此问题) 的响应头中包含下面情况:

> cache-control 包含下列伪指令:

* (1) no-store

* (2) no-cache + 其他与缓存新鲜度检验有关头共存时, 如 max-age=xxx (xxx无所谓.0 或3000都会触发,) 或 no-cache + must-revalidate甚至是,no-cache, pre-check=0等情况..

* (3) no-cache独立存在时,体现为一种不稳定情况.即当访问页面被cache时,可能会触发.但也不是100%.仅仅是偶尔...

遇到以上情况,页面可能会不渲染,而脚本可能会不执行.
ps: 本bug ,与 http1.0 头域 : Pragma : no-cache ,无关.

* 解决办法:
　　　　
>> 1. 放弃压缩.
　　　　
>> 2. 放弃cache-control 中的 no-cache,no-store头域. 比如 单独使用max-age=0.并对不支持http1.0的老浏览器配合Expires = 一个过期时间.
 
关于这个bug的msdn的描述:

```
To work around this problem, you can do either of the following:
If you use a Cache-Control: no-cache HTTP header to prevent the files from caching, remove that header. In some situations, if you substitute an Expires HTTP header, you do not trigger the problem.
-or-
Do not enable HTTP compression for the script files.
```

显然,微软给了我们两条路,去掉no-cache头,或者使用Expires指定过期时间，强制使其过期代替no-cache, 或者别压缩. 而pre-check=0.显然可以代替Expires做到这件事.

关于这几个扩展指令的, 参考msdn 的描述:http://msdn.microsoft.com/en-us/library/ms533020%28VS.85%29.aspx#Use_Cache-Control_Extensions
> post-check

```
Defines an interval in seconds after which an entity must be checked for freshness. The check may happen after the user is shown the resource but ensures that on the next roundtrip the cached copy will be up-to-date.
```

> pre-check

```
Defines an interval in seconds after which an entity must be checked for freshness prior to showing the user the resource.
```

简单来说, 就是控制IE,如何使用本地缓存 ,如果缓存时间,超过post-check的值,就要保证下一次请求该资源,去要验证过的新鲜的.而pre-check则是超过了，就马上给个新的. no-check就无需解释了..

* .no-transform     

> 请求:告知代理,不要更改媒体类型,比如jpg,被你改成png.    

> 响应:同上.

* Etag :(实体标头，HTTP1.1)
通过[Mog95],生成一段可代表实体版本的字串.默认就是一段hash + 时间戳的形式.其实我们是可以使用自己的算法来生成Etag值.比如md5.

>PS:Apache的默认Etag包含Inode,Mtime,Size三部分.而且Etag有强弱之分.比如一般的弱Etag,是以W/开头的,如:W/”abcde12”,这部分不是我们关注的焦点.因为弱Etag和强Etag的区别只在于算法.比如某种弱Etag关注的时间精度,为秒.而我们在项目中,最常见的做法是使用MD5.是一种忽略时间维度的,强Etag.为的是保证精确度.以及负载均衡设备的同步.除非我们的项目有特殊需求.但是往往我们可以根据需求,来调整算法.而不是沿用一些传统的弱Etag算法.

这东西,是要和客户端的两个请求标头配合使用的:

> (1)If-Match:
语义:如果有匹配,或者值为 "*",才可以能去执行,请求所使用的方法,所对应的行为.
If-Match,可以看做是一个过滤器,主要应用于资源多版本共存的解决方案.比如服务器端对同一实体，有多个版本.那么客户端，即可按照指定版本来获取实体.
If-Match的值就是对应指定版本的Etag值.这个值可以是多选的.典型的应用场景是,客户端使用put方式请求服务器端,并带有多个If-Match的值.服务器端检查所有该实体的版本.找到匹配项,就立刻更新服务器端的对应版本.如果无一匹配,则发送一个412 Precondition Failed状态码.

> (2)If-None-Match:
语义:如果有任何匹配,或值是”*”,并且原始服务器存在其请求的实体,则不允许执行该请求所使用放的对应行为,如果此时,该请求使用的get,或head方法.则返回一个304状态码.以及其他一些相关的缓存控制的标头.
与If-Match相反 .但它的典型应用,也是我们要关注的部分.支持http1.1的现代浏览器,以及web server,应用If-None-Match头用于,缓存新鲜度校验.典型应用场景就是,一但原始服务器的某个响应中包含Etag时,如果浏览器本地缓存了该实体.那么在第二次的常规的get或head请求时,就会自动带上 If-None-Match头.当原始服务器上该实体的版本对应的Etag值与之匹配时,则原始服务器会返回304状态码.然后浏览器认为本地缓存是新鲜的.则继续使用缓存的实体. 但,其实Etag的本意是版本管理.而并不是缓存有效性校验.这应该是一个衍生出来的使用方式. 而这种方式相比Last-Modified校验方式的好处是,如果我们消除时间戳部分,仅使用hash作为Etag值. 就可以方便做负载均衡同步.

* Age (响应标头，HTTP1.1)

Age标头,对于原始服务器来说,用于指明,当前资源被生成了多久,即存活期.而对于一个缓存代理服务器来说，它表示缓存副本,被缓存了多久.缓存代理服务器，必须生成Age头.其值以秒为单位.且可能为负值.

* Vary （响应标头,HTTP1.1)

Vary标头，用于列出一组响应标头,用于缓存者从其缓存副本中筛选合适的变体.举个例子来说,不同的请求方法,导致对同一资源的响应有区别.这就导致缓存者有多份缓存副本.那么Vary所列出的标头项,就是选择副本时的一个重要依据. 比如Vary:Accept-Language.那么如果新的请求中的Accept-Language标头的值,而原始请求(被缓存的那个)中并未包含与之匹配的Accept-Language的标头的话.那就必须放弃该副本.而是把请求转发到原始服务器.
另一个Vary的典型应用是,Vary:Accept-Encoding.这样做的意义在于,某些用户使用的浏览器,可能不支持一些特定的压缩算法.那么当这个用户途径的某个共享的缓存代理服务器,所缓存的使用了某种压缩算法的响应,就不能直接返回给该用户.如果服务器端,并没有配置这个标头,那就可能产生悲剧.即用户的浏览器无法解压缩返回的资源.导致各种异常状况的出现.

* 范围相关标头以及缓存的意义
请求标头:
.Range : 1000- | -1000 | 0 - Content-Length
Range头可以指定像服务器(并不一定总是原始服务器,比如一个缓存代理服务器)端获取范围内的数据,这种格式是很松散的,可以用”,”逗号分割范围的一种表达式.比如1-100,-1 这就表示要获取第一到100个字节,以及最后一个字节的部分.又或者 50-则表示50个字节之后的所有数据搭配可以很灵活.不过,当使用多个范围的Range标头时,假设范围都是合法的(不存在越界的情况,如果越界,则可能返回417 Requested Range Not Satisfiable状态码).则服务器响应时,会修改响应中的Content-Type标头为 如下格式:

```
Content-Type : multipart/byteranges;boundary=----ROPE----    
----ROPE----
Content-Type:image/jpeg
Content-Range:bytes 0-100/2000
此处为0-100的数据
----ROPE----
Content-Type:image/jpeg
Content-Range:xxx-xxx/2000
xxx-xxx范围的数据.
----ROPE----
```

好吧,以上这些不是我们关心的重点.我们关心的是和缓存有关的情况,其实对于任何客户端(包括用户代理，以及各类缓存服务器)来说.如果它明确的知道自己想要某一部分范围的数据.就可以使用Range标头. 但事实上,比如对于浏览器来说,一般情况下,只有当服务器端的响应中包含Accept-Ranges:bytes标头时,才可能会在有断点续传需求的时候,自动使用Range头去请求实体.而代只有在响应中，明确出现Accept-Ranges:none时.才会完全避免客户端(包括缓存代理服务器),使用Range标头去获取部分数据.这是要区别看待的.

PS:Range头,还可以在GET方式下与If-Unmodified-Since标头配合,进行条件请求.其行为类似于If-Range头中使用日期格式做新鲜度校验.

.If-Range : 实体的Etag值 | date日期值.
配合Range使用的条件请求标头,该标头的值可以是被请求实体的Etag值，又或者是其Last-Modified的日期.客户端所缓存的部分数据,是新鲜的,服务器端才会,以206方式返回这部分数据.否则,以200方式返回全部数据.

响应标头:
.Accept-Ranges : bytes | none
用于说明,服务器是否支持范围请求.一般，我们常常为图片等资源设置Accept-Ranges:bytes标头.以便使客户端,可以使用断点续传功能.当然,这一切的前提是,客户端之前有缓存部分数据.或者换个角度说,如果服务器端明确声明,不允许缓存某个实体.那么断点续传也就无从说起了. 所以正确的服务器端配置.是一切的基础.

.Content-Range : bytes 0-xxxx/xxxx

标明当前服务器端返回数据的范围. /xxxx部分是总长度.
HTTP响应类别:
     .信息类：1xx(信息类响应头,是在1.1中才被真正具体定义.我们暂时不关注它.)
     .成功类：2xx
     .重定向类：3xx （我们目前只关注304,是的,304是属于重定向类的,我们姑且理解为,重定向到客户端缓存副本上去.）
     .客户机错误类：4xx
     .服务器错误类：5xx
 
关于客户端缓存，我们应该关注哪些概念

1. 寿命:
即响应的寿命,指从原始服务器发出实体后所经历的时间,或者是重新验证,证明某缓存仍处于最新状态（可信赖）之后,所经历的时间. 参考响应头中的 Age,其单位是秒.
2. 过期时间:
对于一个缓存实体来说，其过期时间,是由原始服务器设定的.(参考响应头中的Expires,Cache-Control:max-age…等)一但发现过期,则缓存,必须重新验证实体，才能决定是否使用缓存中对应的实体副本,作为响应.如果原始服务器,未设定过期时间,则缓存可以自己做主,设置一个它认为合适的过期时间(就浏览器来说,IE浏览器再这里实现的与众不同,非IE的主流浏览器,不会自作主张的设置一个自认为合适的过期时间,或者说他们总是认为这样的实体.不应该被缓存下来.而IE，则会有一个会话级的缓存.实际上也不是真正有一个过期时间了.所谓会话级缓存,即浏览器不关闭的情况下,始终去读取浏览器本地的缓存.而不会去试图做任何验证的工作.)
3. 新鲜期和陈旧性:（此概念为服务器端概念）
一个HTTP响应是在服务器端某个特定时刻生成的.原始服务器决定这个响应在多长时间内,是确定新鲜的.在这个新鲜期内,相同实体的请求.可以使用原来生成的那个内容作为响应.即服务器端缓存.一但原始服务器端确认某相同实体的响应,已过了新鲜期.即处于陈旧状态.则原始服务器,需要进一步处理这个响应,比如重新生成响应，或者验证是否可以继续使用该响应.并重新设置其新鲜期.
4. 有效性:
缓存,可以与服务器联系,来验证某个缓存副本,是否是可信赖的最新状态.这种检查，被称为有效性重验证.重验证也可以针对代理服务器进行,而不一定总要和原始服务器进行验证.
5.可缓存性(缓存能力):
缓存者, 必须决定是否存对一个响应,进行缓存.这取决于很多因素,比如原始服务器是否允许响应被缓存,是否设置了缓存过期时间.而有时候即缓存者缓存了一个响应.它仍然需要对该响应，进行验证,以确保该缓存是新鲜的.缓存能力和响应验证，是紧密相关的.
 
那么协议就是全部么？用户代理就那听话么？ 我们理所当然的写一些东西的时候就可靠了么？

下面这段是我的evernote中翻找出来的一段和缓存有关的坑爹的例子.也算给我们自己提个醒. 用户代理可能应为某些原因,给我们造成一些困扰. 所以切记想当然. 一切应以实测为准. 同样.代理服务器也完全可以违背http协议相关的缓存策略.所以 理论上很多东西，都是不可信的：

```
demo:
document.onclick = function () {
            var img = new Image;
            document.body.appendChild(img);
            img.src=https://passport.baidu.com/?verifypic";
            alert(img.complete)
            //CollectGarbage();
}
```

IE7+,opera  如果src是一个静态不变的地址.则 不会再发起请求(无视http缓存相关头域).而直去取缓存文件 。 而且是完全不走network 模块的那种.  所以甚至httpWatch也不会抓到 cache 的项.
因为该img 会被保存在内存中. 即使 没有 img句柄,而直接是一个 new Image().src=xxx  也是如此.  并且 无论图片资源是否强制缓存.http头指定该资源不缓存,亦如此. 这也是为什么IE6有另外某个必须保持new Image句柄的原因.因为IE6 和 IE7+对new Image的策略完全不同， IE6是不会在内存中保持new Image对象的(这也是为什么ie6会有后面提到的那个问题的本质原因.).而 IE7+会在内存中缓存该对象. 并以url作为索引.opera12-也是如此.
 
所以,如果是借助new Image 上报，即使image资源的http 相关缓存头,配置正确(no-cache,no-store,expires过期).在IE7+和Opera12-中，也应该使用随机数.来绕过浏览器 内存缓存new Image的坑. 但是不能因此而放弃配置正确的http缓存策略先关头. 因为这才是正道. 符合语义的做法. 随机数是为了修正用户代理的错误. 不能混淆或相互代替. 另外随机数，也可能是为了解决另外一个问题, 仍然和IE系列有关，比如未指定相关缓存头域情况下,IE系默认对资源有会话级缓存的bug.
 
而ie6 , 一个简单的 new Image().src=xxx 的上报. 会可能在GC(浏览器主动触发,如因页面渲染触发的GC,而不是主动调用CollectGarbage方法)时abort 掉这个请求.(此问题其他浏览器，IE7+都不存在.)
 
即使是

```
var img = new Image();
img.src= xxx 也如此
 
解决办法:
var log = function(){
     var list = [];
     return function(src){
               var index = list.push(new Image) -1;
     list[index].onload = function(){
          list[index] = list[index].onload = null;
     }
     list[index ].src = src;
     }
}();
```
但是要注意的问题是: 0 content length or not image mimeTypes . 不会触发onload.  也就是说，上面的代码.有可能不会及时回收资源.这取决于上报的服务器的配置了. 也许可以借助onerror来综合解决。但我个人认为.这里不会造成内存泄露. 就算你一个页面有100次上报,也无所谓. 而且 对于ie7 - ie10 pp2(更高版本还不好说)来说 .总是在内存中自动缓存每个new Image对象,那么是否我们主动使其持有句柄,其实意义也都不大了. 
