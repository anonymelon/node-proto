import httplib

url = 'http://88.159.13.199:80'

conn = httplib.HTTPConnection(url)

conn.request('GET','')

print conn.getresponse()