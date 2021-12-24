# 自动打开支付宝转账和获取支付宝userId

```java
try {
    String url="alipays://platformapi/startapp?appId=20000067&url=https://qr.alipay.com/fkx16691c9k1bmk77633i2d"; //跳转支付宝打开url
    String url="alipays://platformapi/startapp?appId=09999988&actionType=toAccount&goBack=NO&amount=100.00&userId=2088932727075219&memo=转账测试";//自动填写收款账号和备注
    Intent intent = Intent.parseUri(url, Intent.URI_INTENT_SCHEME);
    startActivity(intent);
} catch (URISyntaxException e) {
    e.printStackTrace();
}
```

以上代码有需要填写收款支付宝的userId，可以通过下面的方式获取。

# 获取支付宝userID的两种方法

第一种

[https://jingyan.baidu.com/article/3065b3b6e8c6dabecff8a42d.html](https://links.jianshu.com/go?to=https%3A%2F%2Fjingyan.baidu.com%2Farticle%2F3065b3b6e8c6dabecff8a42d.html)

第二种

支付宝app扫码

![img](https://upload-images.jianshu.io/upload_images/24450350-724599c8c9c885b2.jpg?imageMogr2/auto-orient/strip|imageView2/2/w/714/format/webp)