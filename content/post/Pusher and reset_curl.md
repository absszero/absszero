---
title: "Pusher and reset_curl"
date: 2020-05-08T12:12:12+08:00
draft: false
tags: [Pusher Curl SSL mkcert]
---



開發上偶而還是會需要使用到 SSL 的環境，所以近期透過 [mkcert](https://github.com/FiloSottile/mkcert) 將本地端的開發網址全面轉換成 SSL。

使用 PHP Curl 的部份，也在 `php.ini` 加上 `curl.cainfo`

```
curl.cainfo="/Users/Username/Library/Application\ Support/mkcert/rootCA.pem"
```



但轉換到的 SSL 之後原本 Pusher 使用卻出現狀況。透過分析[官方套件](https://github.com/pusher/pusher-http-php)了解到，它會呼叫 `curl_reset` 方法重置所有的 curl 設定，也包括上面 `cainfo`  的部份。所幸官方套件可以讓你帶入 `curl_options`，借由帶入 `CURLOPT_SSL_VERIFYPEER` 與 `CURLOPT_CAINFO` 重新設定。

```php
$pusher = new Pusher\Pusher(
    $app_key,
    $app_secret,
    $app_id,
    array(
        'cluster' => $app_cluster,
        'useTLS' => true,
        'curl_options' => array( 
            CURLOPT_SSL_VERIFYPEER => true,
            CURLOPT_CAINFO => "/Users/Username/Library/Application\ Support/mkcert/rootCA.pem"
        )
    )
);
```



官方的討論上面，Wordpress 使用上也有類似情況  https://github.com/FiloSottile/mkcert/issues/165 ，由於 WP 使用自帶的  ca-bundle.crt 。 Pusher 尚且可以透過帶入 curl_options，其他的套件呢？感覺 SSL 還是有許多坑在等著...