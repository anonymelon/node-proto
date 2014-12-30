hashIP = (ip, seed) ->
  hash = ip.split(/\./g).reduce (memo, num) ->
    memo += parseInt num, 10
    memo %= 2147483648
    memo += (memo << 10)
    memo %= 2147483648
    memo ^= memo >> 6
    memo
  , seed

  hash += hash << 3
  hash %= 2147483648
  hash ^= hash >> 11
  hash += hash << 15
  hash %= 2147483648
  hash >>> 0

seed = ~~(Math.random() * 1e9)
ipHash = hashIP '192.168.25.134', seed
console.log ipHash, '-----------'
