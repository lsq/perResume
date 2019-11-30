#!/usr/bin/python
# -*- coding: utf-8 -*-
# 本代码仅供参考，请根据实际情况进行调整
#　requests 用法参考https://blog.csdn.net/dugushangliang/article/details/90473735
import wx_sdk

#url = 'https://aiapi.jd.com/jdai/tts'
url = 'https://httpbin.org/post'
bodyStr = '你好，刘军晓'.encode('utf-8')
params = { 
            'Service-Type' : 'synthesis',
                'Request-Id' : '2c4dc6e2-e1c5-11e8-a867-040973d59110',
                    'Sequence-Id' : '1',
                        'Protocol' : '1',
                            'Net-State' : '2',
                                'Applicator' : '1',
                                    'Property' : '{"platform":"Linux","version":"0.0.0.1","parameters":{"aue":"0","vol":"2.0","sr":"24000","sp":"0.75","tim":"1","tte":"1"}}',
                                        'appkey' : 'e31a789a6d08d265f834c9a420a2de9c',
                                            'secretkey' : '810c4b0721a61feba7510014fe036abc'
                                            }

response = wx_sdk.wx_post_req( url, params, bodyStr=bodyStr )
print( response.text )
