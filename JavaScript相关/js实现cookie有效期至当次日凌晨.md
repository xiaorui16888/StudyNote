#  js实现cookie有效期至当次日凌晨

实际开发中有要求用户一些行为每天一次，次日开始重新回复功能，一般前端都是通过cookie来记住用户的操作，然后进行判断当日是否还有机会，这时候需要给存储的cookie值一个有效期，让次日自动失效，重新计数，代码如下：

```javascript
cookie = {
        /**
         * 获取cookie
         */
        get: function (name) {
            var cookieName = encodeURIComponent(name) + '=',
                cookieStart = document.cookie.indexOf(cookieName),
                cookieValue = null;
            if (~cookieStart) {
                var cookieEnd = document.cookie.indexOf(';', cookieStart);
                if (!~cookieEnd) {
                    cookieEnd = document.cookie.length;
                }
                cookieValue = decodeURIComponent(document.cookie.substring(cookieStart + cookieName.length, cookieEnd));
            }
            return cookieValue;
        },
        /**
         * 设置cookie
         */
        set: function (name, value, expires, path, domain, secure) {
            var cookie = encodeURIComponent(name) + '=' + encodeURIComponent(value);
            expires instanceof Date && (cookie += '; expires=' + expires.toGMTString());
            path && (cookie += '; path=' + path);
            domain && (cookie += '; domain=' + domain);
            secure && (cookie += '; secure');
            document.cookie = cookie;
        },
        /**
         * 删除cookie
         * javascript里，没有提供直接删除cookie的api，只有通过将过期时间，
         * 设置成过去的某个时间，让cookie过期，来删除。
         */
        del: function (name, path, domain, secure) {
            this.set(name, '', new Date(0), path, domain, secure);
        }
    }
```

下面是存储cookie并设置有效期：

```javascript
//cookie过期时间，次日凌晨
var expires = new Date(new Date(new Date().getTime() + 30*24 * 60 * 60 * 1000).setHours(0, 0, 0, 0));

//需要存储的cookie值
var value='100'
cookie.set("key", value, expires);
```

