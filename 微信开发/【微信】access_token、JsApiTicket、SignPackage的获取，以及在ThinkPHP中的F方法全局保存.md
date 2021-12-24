# 【微信】access_token、JsApiTicket、SignPackage的获取，以及在ThinkPHP中的F方法全局保存

获取AccessToken

```php
public function getAccessToken(){
        $data = json_decode(F('access_token'));
        if(time() - $data->time > 0){
            $url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=".$this->wxappid."&secret=".$this->wxappsecret;
            $re = $this->httpGet($url);
            $re=json_decode($re);
            $access_token = $re->access_token; 
            if(isset($access_token)){
                $data->access_token = $access_token;
                $data->time = time() + 6000;
                F('access_token', json_encode($data));
            }
        }
        else{
            $access_token = $data->access_token;
        }   
        return trim($access_token)
}
```

获取JsApiTicket

```php
private function getJsApiTicket(){
        $access_token = $this->getAccessToken();
        $data = json_decode(F('jsapi_ticket'));
        if(time() - $jsapi_ticket['time'] > 0) {
            $url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=".$access_token."&type=jsapi";
            $re = $this->httpGet($url);
            $jsapi_ticket = $re['ticket'];        
            if(isset($jsapi_ticket)){
                $data->jsapi_ticket = $jsapi_ticket;
                $data->time = time() + 7200;
                F('jsapi_ticket', json_encode($data));
            }
        }
        else{
            $jsapi_ticket = $jsapi_ticket['jsapi_ticket'];
        }   
        return trim($jsapi_ticket);
}
```

获取SignPackage

```php
public function getSignPackage()
    {
        $jsapiTicket = $this->getJsApiTicket();
        $protocol = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443 ? "https://" : "http://";
        $url = "{$protocol}{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";
        $timestamp = time();
        $nonceStr = $this->createNonceStr();
        $string = "jsapi_ticket={$jsapiTicket}&noncestr={$nonceStr}&timestamp={$timestamp}&url={$url}";
        $signature = sha1($string);
        $signPackage = array("appId" => $this->wxappid, "nonceStr" => $nonceStr, "timestamp" => $timestamp, "url" => $url, "signature" => $signature, "rawString" => $string);
        return $signPackage;
}
```

我把它们封装到一个类中，方便调用

```php
<?php
namespace Common\Tool;

class Wxtoken
{
    private $wxappid;
    private $wxappsecret;
    public function __construct($wxappid = '', $wxappsecret = '')
    {
        $this->wxappid = $wxappid;
        $this->wxappsecret = $wxappsecret;
    }
    public function getSignPackage()
    {
        $jsapiTicket = $this->getJsApiTicket();
        $protocol = !empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off' || $_SERVER['SERVER_PORT'] == 443 ? "https://" : "http://";
        $url = "{$protocol}{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";
        $timestamp = time();
        $nonceStr = $this->createNonceStr();
        $string = "jsapi_ticket={$jsapiTicket}&noncestr={$nonceStr}&timestamp={$timestamp}&url={$url}";
        $signature = sha1($string);
        $signPackage = array("appId" => $this->wxappid, "nonceStr" => $nonceStr, "timestamp" => $timestamp, "url" => $url, "signature" => $signature, "rawString" => $string);
        return $signPackage;
    }
    
    private function getJsApiTicket(){
        $access_token = $this->getAccessToken();
        $data = json_decode(F('jsapi_ticket'));
        if(time() - $jsapi_ticket['time'] > 0) {
            $url = "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=".$access_token."&type=jsapi";
            $re = $this->httpGet($url);
            $jsapi_ticket = $re['ticket'];        
            if(isset($jsapi_ticket)){
                $data->jsapi_ticket = $jsapi_ticket;
                $data->time = time() + 7200;
                F('jsapi_ticket', json_encode($data));
            }
        }else{
            $jsapi_ticket = $jsapi_ticket['jsapi_ticket'];
        }   
        return trim($jsapi_ticket);
    }
    
    
    public function getAccessToken(){
        $data = json_decode(F('access_token'));
        if(time() - $data->time > 0){
            $url = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=".$this->wxappid."&secret=".$this->wxappsecret;
            $re = $this->httpGet($url);
            $re=json_decode($re);
            $access_token = $re->access_token; 
            if(isset($access_token)){
                $data->access_token = $access_token;
                $data->time = time() + 6000;
                F('access_token', json_encode($data));
            }
        }
        else{
            $access_token = $data->access_token;
        }   
        return trim($access_token);
    }
    
    
    private function createNonceStr($length = 16)
    {
        $chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        $str = "";
        for ($i = 0; $i < $length; $i++) {
            $str .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
        }
        return $str;
    }
    private function httpGet($url)
    {
        $curl = curl_init();
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($curl, CURLOPT_TIMEOUT, 500);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, false);
        curl_setopt($curl, CURLOPT_URL, $url);
        $res = curl_exec($curl);
        curl_close($curl);
        return $res;
    }
}
```

调用

```php
$wxtoken = new \Common\Tool\Wxtoken($gzh['pkey1'], $gzh['pkey2']);
$access_token = $wxtoken->getAccessToken();
```

