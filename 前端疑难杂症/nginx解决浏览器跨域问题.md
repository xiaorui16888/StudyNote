# nginx解决浏览器跨域问题

## 跨域问题

浏览器出于安全方面的考虑，只允许与本域下的接口交互。不同源的客户端脚本在没有明确授权的情况下，不能读写对方的资源。
例如访问www.test1.com 页面, 返回的文件中需要ajax向www.test2.com这个后台接口发起请求, 浏览器就会认为是跨域请求, 会向www.test2.com后台接口发起一个options的请求, 如果这个后台接口在响应报文中添加了如下几个响应头, 表示浏览器可以发起跨域请求
如果没有浏览器会拒绝发起请求。

## 解决方法

在后端接口url（www.test2.com）的nginx上添加如下配置

```yml
server {

    add_header Access-Control-Allow-Origin *;
    add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
    add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';

    if ($request_method = 'OPTIONS') {
        return 204;
    }
}
```

## 解释

Access-Control-Allow-Origin 

服务器默认是不被允许跨域的。给Nginx服务器配置`Access-Control-Allow-Origin *`后，表示服务器可以接受所有的请求源（Origin）,即接受所有跨域的请求。 Access-Control-Allow-Headers 是为了防止出现以下错误：

 Request header field Content-Type is not allowed by Access-Control-Allow-Headers in preflight response.

 这个错误表示当前请求Content-Type的值不被支持。其实是我们发起了"application/json"的类型请求导致的。这里涉及到一个概念：预检请求（preflight request）,请看下面"预检请求"的介绍。 

Access-Control-Allow-Methods 是为了防止出现以下错误： 

Content-Type is not allowed by Access-Control-Allow-Headers in preflight response. 

给OPTIONS 添加 204的返回，是为了处理在发送POST请求时Nginx依然拒绝访问的错误 

发送"预检请求"时，需要用到方法 OPTIONS ,所以服务器需要允许该方法。

