##  先弄清楚为什么要 urlencode？
http://www.genome.iastate.edu/community/angenmap/URLEncoding.html
URL Encoding is the process of converting string into valid URL format.  Valid URL format means that the URL contains only what is termed "alpha | digit | safe | extra | escape" characters.  You can read more about the what and the whys of these terms on the World Wide Web Consortium site: http://www.w3.org/Addressing/URL/url-spec.htmlandhttp://www.w3.org/International/francois.yergeau.html.  
URL encoding is normally performed to convert data passed via html forms, because such data may contain special character, such as "/", ".", "#", and so on, which could either: a) have special meanings; or b) is not a valid character for an URL; or c) could be altered during transfer.   For instance, the "#" character needs to be encoded because it has a special meaning of that of an html anchor.   The <space> character also needs to be encoded because is not allowed on a valid URL format.   Also, some characters, such as "~" might not transport properly across the internet.
## urlencode的编码规则，这里我参考 jdk 的：
http://docs.oracle.com/javase/1.5.0/docs/api/java/net/URLEncoder.html
Utility class for HTML form encoding. This class contains static methods for converting a String to the application/x-www-form-urlencoded MIME format. For more information about HTML form encoding, consult the HTMLspecification.
When encoding a String, the following rules apply:
The alphanumeric characters "a" through "z", "A" through "Z" and "0" through "9" remain the same.
The special characters ".", "-", "*", and "_" remain the same.
The space character " " is converted into a plus sign "+".
All other characters are unsafe and are first converted into one or more bytes using some encoding scheme. Then each byte is represented by the 3-character string "%xy", wherexyis the two-digit hexadecimal representation of the byte. The recommended encoding scheme to use is UTF-8. However, for compatibility reasons, if an encoding is not specified, then the default encoding of the platform is used.
For example using UTF-8 as the encoding scheme the string "The string ü@foo-bar" would get converted to "The+string+%C3%BC%40foo-bar" because in UTF-8 the character ü is encoded as two bytes C3 (hex) and BC (hex), and the character @ is encoded as one byte 40 (hex).
## shell 下如何处理 urlencode 问题？
在各种语言中都有专门针对 url 进行 encode/decode 的函数/API，如 python、java、perl 等。
但shell下面似乎没有专门的命令来做这个事情，不过这可难不倒sheller，
别忘了前篇文章还提到了 *nix 的设计哲学：Where there is a shell,  there is a way.
只要弄清了 url encode/decode 的原理，shell处理他们也是轻而易举的，废话少说，上代码：
1. 编码
```shell
june@~ 23:40:29>
echo '手机' | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g'              #echo '手机' |tr -d '\n' |od -An -tx1|tr ' ' %
%ca%d6%bb%fa
june@~ 23:40:46>
```
然后你在浏览器试试：
http://www.baidu.com/s?wd=%ca%d6%bb%fa
2. 解码：
```shell
june@~ 23:50:11>
url="http://www.baidu.com/s?wd=%ca%d6%bb%fa"
printf $(echo -n $url | sed 's/\\/\\\\/g;s/\(%\)\([0-9a-fA-F][0-9a-fA-F]\)/\\x\2/g')"\n"
http://www.baidu.com/s?wd=手机
june@~ 23:50:13>
```
3. 其实我们经常用的 curl 的 --data-urlencode 选项即可实现 urlencode 编码：
```shell
june@~ 23:58:38>
curl -v -L -G --data-urlencode 'wd=手机' "http://www.baidu.com/s"
* About to connect() to www.baidu.com port 80 (#0)
*   Trying 220.181.112.143... connected
* Connected to www.baidu.com (220.181.112.143) port 80 (#0)
> GET /s?wd=%CA%D6%BB%FA HTTP/1.1
> User-Agent: curl/7.20.1 (i686-pc-cygwin) libcurl/7.20.1 OpenSSL/0.9.8r zlib/1.2.5 libidn/1.18 libssh2/1.2.5
> Host: www.baidu.com
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Sat, 05 May 2012 15:58:45 GMT
< Server: BWS/1.0
< Content-Length: 101019
< Content-Type: text/html;charset=gbk
< Cache-Control: private
< Set-Cookie: BAIDUID=F1BD65A89533B12403EAB701C73D4638:FG=1; expires=Sat, 05-May-42 15:58:44 GMT; path=/; domain=.baidu.com
< P3P: CP=" OTI DSP COR IVA OUR IND COM "
< Connection: Keep-Alive
<
<!DOCTYPE html><!--STATUS OK--><html><head>
<meta http-equiv="X-UA-Compatible" content="IE=7">
<meta http-equiv="content-type" content="text/html;charset=gb2312">
<title>百度搜索_手机      </title>
.......
```
