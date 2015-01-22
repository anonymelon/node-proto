#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
try:
    import qiniu.conf
    import qiniu.rs
except ImportError:
    print 'qiniu sdk doesn\'t installed, please install qiniu by command:\
          pip install qiniu or easy_install qiniu'
    sys.exit(1)

import ConfigParser
import argparse
import os.path

parser = argparse.ArgumentParser(description='''
    This script is used to upload file to qiniu, please first add you config in qiniu.conf
    ''')
parser.add_argument('-file', '--file', required=True, help='the file you want to upload')
parser.add_argument('-res', '--resumable',
                    choices=['True', 'False'], required=False, default='False', help='specify the file you upload need resumable or not')
parser.add_argument('-nameaskey', '--nameaskey',
                    choices=['True', 'False'], required=False, default='True', help='use name as key, if False, key will be None and use qiniu generated hash key')
args = parser.parse_args()


cp = ConfigParser.ConfigParser()
cp.read('qiniu.conf')


def log(msg):
    print msg


def pre_check():
    # check file
    log('checkint upload file and config')
    if os.path.exists(args.file):
        pass
    else:
        log('file doesn\'t exists, please check it again')
        sys.exit(1)
    # check config
    necessary_confs = ['bucket_name', 'ACCESS_KEY', 'SECRET_KEY']
    for conf in necessary_confs:
        if not cp.get('qiniu', conf):
            log('necessary configs is None, please check qiniu.conf and input right config')
            sys.exit(1)


qiniu.conf.ACCESS_KEY = cp.get('qiniu', 'ACCESS_KEY')
qiniu.conf.SECRET_KEY = cp.get('qiniu', 'SECRET_KEY')


def simple_upload(param_tuple):
    uptoken = param_tuple[0]
    key = param_tuple[1]
    localfile = param_tuple[2]
    import qiniu.io
    extra = qiniu.io.PutExtra()
    ret, err = qiniu.io.put_file(uptoken, key, localfile, extra)
    if err is not None:
        sys.stderr.write('error: %s ' % err)
    return ret


def resumable_upload(param_tuple):
    uptoken = param_tuple[0]
    key = param_tuple[1]
    localfile = param_tuple[2]
    import qiniu.resumable_io as rio
    extra = rio.PutExtra(cp.get('qiniu', 'bucket_name'))
    ret, err = rio.put_file(uptoken, key, localfile, extra)
    if err is not None:
        sys.stderr.write('error: %s ' % err)
    return ret


def prepare_params():
    policy = qiniu.rs.PutPolicy(cp.get('qiniu', 'bucket_name'))
    uptoken = policy.token()
    if args.nameaskey == 'True':
        key = args.file.split('/')[-1]
    else:
        key = None
    localfile = os.path.abspath(args.file)
    return uptoken, key, localfile

pre_check()
if args.resumable == 'True':
    log('upload file in resumable way')
    ret = resumable_upload(prepare_params())
else:
    log('upload file in simple way')
    ret = simple_upload(prepare_params())

print ret['key']
download_url = 'http://%s.qiniudn.com/%s' % (cp.get('qiniu', 'bucket_name'), args.file.split('/')[-1])
log('file download url is: %s' % download_url)
