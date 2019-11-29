Http协议支持：GET、HEAD、PUT、DELETE、POST、OPTIONS等6种请求方法；在这里我们通过linux curl命令，介绍其中的两种请求方法：GET、POST；使用linux curl命令通过GET、POST命令提交数据、使用POST上传文件，同时使用PHP语言介绍它们提交的数据和上传的文件的接受方法。
　
一、测试前准备：

　　为了测试方便，我们在本站的站点根目录下，写了一个临时接受数据脚本"test.php"，用来接收提交上来的数据；所有的GET、POST请求都发送到“http://aiezu.com/test.php”，脚本的内容如下：

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18

19
	

<?php

foreach(array('REQUEST_METHOD', 'CONTENT_LENGTH', 'CONTENT_TYPE') as $key ) {

    if ( isset( $_SERVER[$key] ) ) {

        echo sprintf("[%s]: %s\n", $key, $_SERVER[$key]);

    }

}

echo PHP_EOL;

foreach(array('_GET', '_POST', '_FILES') as $name ) {

    if( !empty( $$name ) ) {

        echo sprintf("\$%s：\n", $name);

        print_r($$name);

        echo PHP_EOL;

    }

}

//接收JSON代码

if ( strtolower($_SERVER['CONTENT_TYPE']) == 'application/json' && $json = file_get_contents("php://input") ) {

    echo "JSON Data：\n";

    print_r(@json_decode($json, true));

}

 
二、GET请求方式：

　　GET方式只能提交key/value对数据，不能上传二进制文件。使用linux curl命令通过GET方法提交数据主要分为两大类，1：直接将数据附加在URL后面；2：使用"-G"或者"--get"参数配合"-d"、"--data"、"--data-ascii"、"--data-urlencode"等参数，参数详细介绍请参考：“Linux curl命令详解”页面中的“数据传输”组的介绍。
1、将数据直接附加在URL后面：

1

2

3

4

5

6

7

8

9
	

[root@aiezu.com ~]# curl 'http://aiezu.com/test.php?en=aiezu&cn=爱E族'

[REQUEST_METHOD]: GET

 

$_GET：

Array

(

    [en] => aiezu

    [cn] => 爱E族

)

 
2、使用"-G"参数配合"-d"参数：

1

2

3

4

5

6

7

8

9
	

[root@aiezu tmp]# curl -G -d "en=aiezu&cn=爱E族" http://aiezu.com/test.php

[REQUEST_METHOD]: GET

 

$_GET：

Array

(

    [en] => aiezu

    [cn] => 爱E族

)

由于"-G"等价于"--get"，"-d"等价于"--data"、"--data-ascii"，所以下面几种方法和上面的方法是等价的：

1

2

3

4
	

curl -G --data "en=aiezu&cn=爱E族" http://aiezu.com/test.php

curl --get -d "en=aiezu&cn=爱E族" http://aiezu.com/test.php

curl --get --data "en=aiezu&cn=爱E族" http://aiezu.com/test.php

curl --get --data-ascii "en=aiezu&cn=爱E族" http://aiezu.com/test.php

 
3、带特殊字符数据使用“--data-urlencode”：

1

2

3

4

5

6

7

8

9
	

[root@aiezu tmp]# curl --get --data-urlencode 'aa=&a' --data-urlencode '2=/&?' http://aiezu.com/test.php

[REQUEST_METHOD]: GET

 

$_GET：

Array

(

    [aa] => &a

    [2] => /&?

)

 
4、从文件中获取数据：

1

2

3

4

5

6

7

8

9

10

11
	

[root@aiezu.com ~]# cat data.txt

en=aiezu&cn=爱E族

[root@aiezu.com ~]# curl --get --data @data.txt http://aiezu.com/test.php

[REQUEST_METHOD]: GET

 

$_GET：

Array

(

    [en] => aiezu

    [cn] => 爱E族

)

 
三、POST基本类型请求方式(-d)：

　　基本的POST请求方式，只能提交key/value对数据，不能上二进制文件；参数详细介绍请参考：“Linux curl命令详解”页面中的“数据传输”组的介绍。此方法的http请求头大致如下：

1

2

3

4

5

6
	

POST /test.php HTTP/1.1

User-Agent: curl/7.29.0

Host: aiezu.com

Accept: */*

Content-Length: 19

Content-Type: application/x-www-form-urlencoded

对、正是相当于html的如下表单：

1

2

3
	

<form method="POST" action="/test.php" enctype="application/x-www-form-urlencoded">

...

</form>

 
1、直接设置POST数据：

1

2

3

4

5

6

7

8

9

10

11

12
	

[root@aiezu.com ~]# curl --data 'name=爱E族&site=aiezu.com' --data-urlencode 'code=/&?' http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 42

[CONTENT_TYPE]: application/x-www-form-urlencoded

 

$_POST：

Array

(

    [name] => 爱E族

    [site] => aiezu.com

    [code] => /&?

)

 
2、从文件中获取POST数据：

1

2

3

4

5

6

7

8

9

10

11

12

13
	

[root@aiezu.com ~]# cat data.txt

en=aiezu&cn=爱E族

[root@aiezu.com ~]# curl --data @data.txt http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 19

[CONTENT_TYPE]: application/x-www-form-urlencoded

 

$_POST：

Array

(

    [en] => aiezu

    [cn] => 爱E族

)

 
四、POST多类型表单数据请求方式(-F)：

　　POST多类型表单数据请求方式支持提交key/value值对数据、和上传二进制文件，是使用最多的一种方式。参数详细介绍请参考：“Linux curl命令详解”页面中的“数据传输”组的介绍。此方法的http请求头大致如下：

1

2

3

4

5

6

7
	

POST /test.php HTTP/1.1

User-Agent: curl/7.29.0

Host: aiezu.com

Accept: */*

Content-Length: 141

Expect: 100-continue

Content-Type: multipart/form-data; boundary=----------------------------574307cce722


相当于HTML的如下表单：

1

2

3
	

<form method="POST" action="/test.php" enctype="multipart/form-data">

...

</form>

注意："-F"与"-d"有一点不同，"-d"可以使用“-d 'a=1&b=2'”将两个字段放一起；而"-F"不行，一个"-F"只能包含一个key/value对，如："-F a=1 -F b=2"。
 
1、提交key/value值对数据(--form、-F)：

1

2

3

4

5

6

7

8

9

10

11
	

[root@aiezu.com ~]# curl --form 'name=爱E族' -F "site=aiezu.com" http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 248

[CONTENT_TYPE]: multipart/form-data; boundary=----------------------------71b11083beb3

 

$_POST：

Array

(

    [name] => 爱E族

    [site] => aiezu.com

)


2、使用"@"、"<"失去特殊意义的"--form-string"：

1

2

3

4

5

6

7

8

9

10

11
	

[root@aiezu.com ~]# curl --form-string 'str=@data.txt' --form-string "site=<b.txt" http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 246

[CONTENT_TYPE]: multipart/form-data; boundary=----------------------------c2250f4ad22a

 

$_POST：

Array

(

    [str] => @data.txt

    [site] => <b.txt

)


3、从文件中获取key/value对中的"value"("<"字符的特殊妙用)：

1

2

3

4

5

6

7

8

9

10

11

12

13
	

[root@aiezu.com ~]# cat data.txt

en=aiezu&cn=爱E族

[root@aiezu.com ~]# curl --form 'data=<data.txt' http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 159

[CONTENT_TYPE]: multipart/form-data; boundary=----------------------------575b8e666b57

 

$_POST：

Array

(

    [data] => en=aiezu&cn=爱E族

 

)

 
五、POST上传文件(-F "@"字符的妙用)：

　　这里还是介绍第四步的“-F”参数，不过现在是介绍它的上传文件；
1、自动识别文件类型：

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18
	

[root@aiezu.com ~]# curl --form 'file=@data.txt' http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 206

[CONTENT_TYPE]: multipart/form-data; boundary=----------------------------126831d4cffa

 

$_FILES：

Array

(

    [file] => Array

        (

            [name] => data.txt

            [type] => text/plain

            [tmp_name] => /tmp/php6HqQjx

            [error] => 0

             [ size ] => 20

        )

 

)

 
2、告诉http服务器后端脚本，这是一张图片，不是一个文本文件：

1

2

3

4

5

6

7

8

9

10

11

12

13

14

15

16

17

18
	

<span>[root@aiezu.com ~]# curl -F "pic=@data.txt;filename=image.jpg;type=image/jpeg" http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 206

[CONTENT_TYPE]: multipart/form-data; boundary=----------------------------45fce8b3a421

 

$_FILES：

Array

(

    [pic] => Array

        (

            [name] => image.jpg

            [type] => image/jpeg

            [tmp_name] => /tmp/phpvWcwiX

            [error] => 0

            [ size ] => 20

        )

 

)

 
六、POST提交JSON数据：

　　下面代码为linux curl命令POST方式提交JSON数据的方法、已经使用PHP语言的接收代码：

1

2

3

4

5

6

7

8

9

10

11
	

[root@aiezu.com ~]# curl -H "Content-Type: application/json" --data '{"name":"爱E族","site":"aiezu.com"}'  http://aiezu.com/test.php

[REQUEST_METHOD]: POST

[CONTENT_LENGTH]: 37

[CONTENT_TYPE]: application/json

 

JSON Data：

Array

(

    [name] => 爱E族

    [site] => aiezu.com

)

接收JSON的代码段：

1

2

3

4

5
	

<?php

if ( strtolower($_SERVER['CONTENT_TYPE']) == 'application/json' && $json = file_get_contents("php://input") ) {

    echo "JSON Data：\n";

    print_r(@json_decode($json, true));

}

　　提示：除了Content-Type为multipart/form-data​，其他所有POST的数据都可以从php://input流中读得，如：POST的XML数据，二进制图片数据。
