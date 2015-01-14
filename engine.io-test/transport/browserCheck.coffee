module.exports = ->
  ua = window.navigator.userAgent.toLowerCase()
  match = /(edge)\/([\w.]+)/.exec(ua) or /(opr)[\/]([\w.]+)/.exec(ua) or /(chrome)[ \/]([\w.]+)/.exec(ua) or /(version)(applewebkit)[ \/]([\w.]+).*(safari)[ \/]([\w.]+)/.exec(ua) or /(webkit)[ \/]([\w.]+).*(version)[ \/]([\w.]+).*(safari)[ \/]([\w.]+)/.exec(ua) or /(webkit)[ \/]([\w.]+)/.exec(ua) or /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua) or /(msie) ([\w.]+)/.exec(ua) or ua.indexOf('trident') >= 0 and /(rv)(?::| )([\w.]+)/.exec(ua) or ua.indexOf('compatible') < 0 and /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua) or []
  platform_match = /(ipad)/.exec(ua) or /(ipod)/.exec(ua) or /(iphone)/.exec(ua) or /(kindle)/.exec(ua) or /(silk)/.exec(ua) or /(android)/.exec(ua) or /(windows phone)/.exec(ua) or /(win)/.exec(ua) or /(mac)/.exec(ua) or /(linux)/.exec(ua) or /(cros)/.exec(ua) or /(playbook)/.exec(ua) or /(bb)/.exec(ua) or /(blackberry)/.exec(ua) or []
  browser: match[5] or match[3] or match[1] or ''
  version: match[2] or match[4] or '0'
  versionNumber: match[4] or match[2] or '0'
  platform: platform_match[0] or ''
