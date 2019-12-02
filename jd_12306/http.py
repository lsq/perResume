import requests
import logging
import requests
import json

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

#requests.get('https://httpbin.org/headers')
host = "http://httpbin.org/"
endpoint = "post"

url = ''.join([host,endpoint])
params = { 
    'Service-Type' : 'synthesis',
    'Request-Id' : '2c4dc6e2-e1c5-11e8-a867-040973d59110',
    'Sequence-Id' : '-1',
    'Protocol' : '1',
    'Net-State' : '2',
    'Applicator' : '1',
    'Property' : '{"platform":"Linux","version":"0.0.0.1","parameters":{"aue":"0","vol":"2.0","sr":"24000","sp":"0.75","tim":"1","tte":"1"}}',
    'appkey' : 'e31a789a6d08d265f834c9a420a2de9c',
    'secretkey' : 'your secretKey'
    }

# r = requests.post(url)
r = requests.post(url,params=params)
#response = r.json()
print (r.text)