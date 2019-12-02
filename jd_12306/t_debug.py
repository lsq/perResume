#!/usr/bin/python
# -*- coding: utf-8 -*-
# 本代码仅供参考，请根据实际情况进行调整
#　requests 用法参考https://blog.csdn.net/dugushangliang/article/details/90473735
import logging
import requests
import json
from wx_sdk import wx_sdk

# These two lines enable debugging at httplib level (requests->urllib3->http.client)
# You will see the REQUEST, including HEADERS and DATA, and RESPONSE with HEADERS but without DATA.
# The only thing missing will be the response.body which is not logged.
try:
    import http.client as http_client
except ImportError:
    # Python 2
    import httplib as http_client
    #import requests.packages.urllib3.connectionpool as httplib
    #from six.moves import http_client as httplib
http_client.HTTPConnection.debuglevel = 1

# You must initialize logging, otherwise you'll not see debug output.
logging.basicConfig()
logging.getLogger().setLevel(logging.DEBUG)
requests_log = logging.getLogger("requests.packages.urllib3")
requests_log.setLevel(logging.DEBUG)
requests_log.propagate = True


#url = 'https://aiapi.jd.com/jdai/tts'
url = 'https://httpbin.org/post'
bodyStr = '一个人携带三石六口缸过河，用九支船来装，每支船装单不装双，就是说每支装的数只能是奇数，不能为偶数，请问该怎么装才能过河?'
#bodyStr = '一个人携带三石六口缸过河，用九支船来装，每支船装单不装双，就是说每支装的数只能是奇数，不能为偶数，请问该怎么装才能过河?'.encode('utf-8')
params = { 
            'Service-Type' : 'synthesis',
                'Request-Id' : '2c4dc6e2-e1c5-11e8-a867-040973d59110',
                    'Sequence-Id' : '-1',
                        'Protocol' : '1',
                            'Net-State' : '2',
                                'Applicator' : '1',
                                    'Property' : '{"platform":"Linux","version":"0.0.0.1","parameters":{"aue":"0","vol":"2.0","sr":"24000","sp":"0.75","tim":"1","tte":"1"}}',
                                        'appkey' : 'e31a789a6d08d265f834c9a420a2de9c',
                                            'secretkey' : '810c4b0721a61feba7510014fe036abc'
                                            }

response = wx_sdk.wx_post_req( url, params, bodyStr=bodyStr )
print( response.text )
