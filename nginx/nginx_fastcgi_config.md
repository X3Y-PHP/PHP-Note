
### PATHINFO

常常会见到这种格式的Url`http://blog.jjonline.cn/index.php/Article/Post/index.html`，这种Url理解有两种方式：
1.`index.php`当做一个目录看待：访问blog.jjonline.cn服务器根目录下的index.php目录下的Article目录下的Post目录下的index.html静态html文本文件；
2.`index.php`当做一个PHP脚本看待：访问blog.jjonline.cn服务器根目录下的index.php脚本，由该脚本产生html页面，Url中/Article/Post/index.html这一部分作为index.php脚本中使用的某种类型的参数。

绝大部分情况下，这种格式的Url理解方式是第二种，而/Article/Post/index.html这一部分理解成PATHINFO就好了。其实PATHINFO是一个CGI 1.1的一个标准，经常用来做为传参载体，只不过咱们没必要深入。

由于Apache的默认配置文件开启了PATHINFO的支持，Apache+PHP的环境下PATHINFO格式的Url可以不出任何错误的执行正确路径的PHP脚本并在脚本中使用PATHINFO中的参数。而Nginx默认提供的有关执行php-fpm运行PHP脚本的默认配置文件中并没有启用PATHINFO，从而导致了一个长久以来的误解：nginx不支持pathinfo。

早期版本的nginx确实不能直接支持pathinfo，但有变相的解决方法，网络上的一些配置nginx支持pathinfo的文章大多就是这种变相解决方法。nginx其实早已可以很简单的通过fastcgi_split_path_info指令支持pathinfo模式了，严格来说是nginx的0.7.31以上版本就可以使用这个指令了。

### Nginx的PATHINFO配置

默认的nginx是对http请求的uri进行正则匹配来决定这个请求是否要交给php-fpm来执行；nginx中有关是否要交给php-fpm这个cgi来解析执行某个php脚本的默认配置(nginx1.8.0)如下：

```
location ~ \.php$ {
        root           html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        include        fastcgi_params;
 }
```

上述location ~ \.php$这段是一个正则匹配，被匹配的内容是http请求的uri，正则表达式就是\.php$，而~则是nginx的location指令中的一个标记符，表示这个location匹配uri采用正则表达式来匹配；在这里URI和URL还是有区别，请厘清。正则表达式中$表示必须以某个字符或字符串结尾，这样上述默认配置中仅能匹配到以.php为结尾的uri交给php-fpm去解析，如下：

1、http://blog.jjonline.cn/index.php 匹配

2、http://blog.jjonline.cn/admin/index.php?m=Index&a=index 匹配，注意这里Url中有Get变量，nginx中location匹配的路径是uri，也就是虚拟路径部分，本例也就是：/admin/index.php

3、http://blog.jjonline.cn/admin/index.php/Index/index 不匹配，pathinfo模式，nginx将index.php理解成一个目录了，这种情况下的uri为：/admin/index.php/Index/index ，结尾并没有.php这种条件

正确配置Nginx对php的pathinfo支持，先要理解清楚nginx配置文件中是如何将某个请求交给php-fpm来执行的，以上述配置段为例来分析一下：

`root`：这个指令配置了php脚本的根目录，可以使用相对路径也可以使用绝对路径，上述示例中是html，表示php的根目录在nginx安装目录下的html目录；这里的目录一般与nginx配置文件server段下的root目录一致，也就是web服务器的根目录；且大多数的时候建议使用绝对地址。假设这里的root设置为：/var/www/www.jjonline.cn/wwwRoot，这样网站根目录的绝对地址就是/var/www/www.jjonline.cn/wwwRoot，配合各种ftp服务器端配置，将ftp登录的家目录设定为/var/www/www.jjonline.cn。拿ThinkPHP来举例：框架和核心模块文件可以放置在/var/www/www.jjonline.cn目录下，而入口文件放置在/var/www/www.jjonline.cn/wwwRoot下；这样框架和核心模块文件就不会被Url直接访问到。

`fastcgi_pass`：这个指令配置了fastcgi监听的端口，可以是TCP也可以是unix socket，这里一般推荐走TCP，这个TCP是由`php-fpm配置文件【在/etc/php5/fpm下面】`决定的，不再详细介绍。

`fastcgi_index`：这个指令配置了fastcgi的默认索引文件，与server端下index指令类似。

`fastcgi_param`：这个指令配置了fastcgi的一些参数，传递给php-fpm，这个指令是3段式，第一段fastcgi_param指令名称，第二段传递给php-fpm的参数的名称，第三段传递给php-fpm参数的值，也就是说fastcgi_param配置了一系列的key-value类型的值；对PHP来说fastcgi_param指令产生的key-value键值对最后都（未确认，暂时这么理解吧~）转换成了超全局数组变量$_SERVER的键值对，上述示例中fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name就配置了一个SCRIPT_FILENAME的fastcgi参数，转换成PHP中的变量就是$_SERVER['SCRIPT_FILENAME'] ，PHP参考手册中对$_SERVER['SCRIPT_FILENAME']的说明是：“当前执行脚本的绝对路径”。对nginx来说，将请求正确的交给php-fpm来执行正确的php脚本就是由fastcgi_param指令配置的SCRIPT_FILENAME来决定的，所以nginx能默契的与php-fpm协作，fastcgi_param指令正确的配置了SCRIPT_FILENAME值是关键。

`include`：这个指令将指定的文本文件的内容作为配置项包含进来，与php中的include差不多意思，这个指令的参数就是一个配置文件的路径，可以是相对路径也可以是绝对路径，路径中可以使用通配符*；nginx的虚拟主机实现就使用到了这个指令，以及指令参数中使用到通配符。include fastcgi_params; 则表示将主配置文件目录下的fastcgi_params文本文件中的配置内容包含进来。读取fastcgi_params文本文件，可以发现这个文件中的文本内容如下：
```
fastcgi_param  QUERY_STRING       $query_string;
fastcgi_param  REQUEST_METHOD     $request_method;
fastcgi_param  CONTENT_TYPE       $content_type;
fastcgi_param  CONTENT_LENGTH     $content_length;

fastcgi_param  SCRIPT_NAME        $fastcgi_script_name;
fastcgi_param  REQUEST_URI        $request_uri;
fastcgi_param  DOCUMENT_URI       $document_uri;
fastcgi_param  DOCUMENT_ROOT      $document_root;
fastcgi_param  SERVER_PROTOCOL    $server_protocol;
fastcgi_param  HTTPS              $https if_not_empty;

fastcgi_param  GATEWAY_INTERFACE  CGI/1.1;
fastcgi_param  SERVER_SOFTWARE    nginx/$nginx_version;

fastcgi_param  REMOTE_ADDR        $remote_addr;
fastcgi_param  REMOTE_PORT        $remote_port;
fastcgi_param  SERVER_ADDR        $server_addr;
fastcgi_param  SERVER_PORT        $server_port;
fastcgi_param  SERVER_NAME        $server_name;

# PHP only, required if PHP was built with --enable-force-cgi-redirect
fastcgi_param  REDIRECT_STATUS    200;
```
可以发现包含进来的fastcgi_params文件依然使用了fastcgi_param指令，配置了一大堆键值对，拿fastcgi_param SERVER_SOFTWARE nginx/$nginx_version;来简单分析下：SERVER_SOFTWARE与$_SERVER['SERVER_SOFTWARE']对应，做后台管理系统常常会用到这个变量来显示服务器使用的软件，在php代码中读取出来的值就是nginx中这个地方配置的，这个时候PHP中$_SERVER['SERVER_SOFTWARE']读取出来的内容就是诸如nginx/1.8.0这样的字符串，这段nginx的配置中$nginx_version是nginx提供的一个变量，变量内容就是nginx版本号。

另外fastcgi_params文件与fastcgi.conf的内容是一摸一样的，任意包含一个即可，为什么会有两个一摸一样的呢？这是nginx的开发者为不同操作系统平台提供的，无需深究。

### nginx支持pathinfo的本质和配置实现

1、nginx需要正确将请求交给php-fpm来执行php脚本，nginx先得正确分析出URI中是否要去请求某个PHP脚本；

2、当php-fpm正确执行某个PHP脚本后，PHP中pathinfo模式实现单一入口需要PHP中$_SERVER['PATH_INFO']包含了正确的pathinfo值；而PHP中的$_SERVER变量由nginx的fastcgi_param指令来决定；

`需要将URI进行正则切割，产生正确的PHP脚本文件路径和pathinfo值；`

nginx的0.7.31以上版本以后就可以使用fastcgi_split_path_info指令了，这个指令的参数为一个正则表达式，这个正则表示必须有两个捕获子组，从左往右捕获的第一子组自动赋值给nginx的$fastcgi_script_name变量，第二个捕获的子组自动赋值给nginx的$fastcgi_path_info变量。


通常情况下，也就是在没有使用fastcgi_split_path_info指令时nginx的$fastcgi_script_name变量保存着相对PHP脚本的URI，这个URI相对于web根目录就是实际PHP脚本的路径，所以下方的关于SCRIPT_FILENAME的配置很常见。

```
astcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;
```

```
##匹配nginx需要交给php-fpm执行的URI，先要允许pathinfo格式的URL能够被匹配到
##所以要去掉$
##nginx文档中的匹配规则为：^(.+\.php)(.*)$
##还有~ \.php这种写法 和 ~ \.php($|/)这种写法
##都是差不多意思没啥严格区别
##唯一区别就是有多个匹配php的location的话需要留意权重差异
location ~ ^(.+\.php)(.*)$ {
     root              /var/www/www.jjonline.cn/wwwRoot;
     fastcgi_pass   127.0.0.1:9000;
     fastcgi_index  index.php;
     ##增加 fastcgi_split_path_info指令，将URI匹配成PHP脚本的URI和pathinfo两个变量
     ##即$fastcgi_script_name 和$fastcgi_path_info
     fastcgi_split_path_info  ^(.+\.php)(.*)$;
     ##PHP中要能读取到pathinfo这个变量
     ##就要通过fastcgi_param指令将fastcgi_split_path_info指令匹配到的pathinfo部分赋值给PATH_INFO
     ##这样PHP中$_SERVER['PATH_INFO']才会存在值
     fastcgi_param PATH_INFO $fastcgi_path_info;
     ##在将这个请求的URI匹配完毕后，检查这个绝对地址的PHP脚本文件是否存在
     ##如果这个PHP脚本文件不存在就不用交给php-fpm来执行了
     ##否者页面将出现由php-fpm返回的:`File not found.`的提示
     if (!-e $document_root$fastcgi_script_name) {
         ##此处直接返回404错误
         ##你也可以rewrite 到新地址去，然后break;
         return 404;
     }
     fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
     include        fastcgi_params;
}
```



































































 http://blog.jjonline.cn/linux/218.html
