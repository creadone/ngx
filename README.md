# NGX

CLI tool for parsing NGINX access log and filtering by fields or values with output to JSON or plain text

## Status

Pre-alpha, don't use on production.

## Installation

`git clone https://github.com/creadone/ngx && cd ngx && shards build --release`

## Usage

The main difference between the `filter` and `find` that the `filter` returns only subset of the fields and nothing more, and the `find` can compare by value of fields but always returns all fields.

### Finder mode

**Fields**

ip, user, day, month, year, hour, minute, second, timezone, method, path, protocol, version, code, bytes, referer, user_agent

**Input logs**
```
127.0.0.1 - - [30/Oct/2020:10:27:00 +0000] "GET / HTTP/1.1" 200 0 "-" "ApacheBench/2.3"
127.0.0.1 - - [30/Oct/2020:10:27:00 +0000] "GET / HTTP/1.1" 200 0 "-" "ApacheBench/2.3"
127.0.0.1 - - [30/Oct/2020:10:27:00 +0000] "GET / HTTP/1.1" 200 0 "-" "ApacheBench/2.3"
```

**Run ngx**
```sh
cat access.log | ngx -m find -f ip=127.0.0.1, method=GET -o json
```

**Output**
```
{"ip":"127.0.0.1","user":"-","day":"30","month":"Oct","year":"2020","hour":"10","minute":"27","second":"00","timezone":"+0000","method":"GET","path":"/","protocol":"HTTP","version":"1.1","code":"200","bytes":"2205","referer":"-","user_agent":"ApacheBench/2.3"}
{"ip":"127.0.0.1","user":"-","day":"30","month":"Oct","year":"2020","hour":"10","minute":"27","second":"00","timezone":"+0000","method":"GET","path":"/","protocol":"HTTP","version":"1.1","code":"200","bytes":"2205","referer":"-","user_agent":"ApacheBench/2.3"}
{"ip":"127.0.0.1","user":"-","day":"30","month":"Oct","year":"2020","hour":"10","minute":"27","second":"00","timezone":"+0000","method":"GET","path":"/","protocol":"HTTP","version":"1.1","code":"200","bytes":"2205","referer":"-","user_agent":"ApacheBench/2.3"}
```

### Filter mode

**Input logs**
```
127.0.0.1 - - [30/Oct/2020:10:27:00 +0000] "GET / HTTP/1.1" 200 0 "-" "ApacheBench/2.3"
127.0.0.1 - - [30/Oct/2020:10:27:00 +0000] "GET / HTTP/1.1" 200 0 "-" "ApacheBench/2.3"
127.0.0.1 - - [30/Oct/2020:10:27:00 +0000] "GET / HTTP/1.1" 200 0 "-" "ApacheBench/2.3"
```

**Run ngx**
```sh
car access.log | ngx -m filter -f ip,method,path -o json
```

**Output**
```
{"ip":"127.0.0.1","method":"GET","path":"/"}
{"ip":"127.0.0.1","method":"GET","path":"/"}
{"ip":"127.0.0.1","method":"GET","path":"/"}
{"ip":"127.0.0.1","method":"GET","path":"/"}
```

## TODO

1. Tests
2. Merge `finder` and `filter` into one
3. Custom parsing templates
4. Add expressions to comparison: `cat access.log | ngx -m find -f code > 400, ip << 127.0.0.1/24 -o json`
5. Export output with TCP or HTTP

## Contributing

1. Fork it (<https://github.com/creadone/ngx/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Sergey Fedorov](https://github.com/creadone) - creator and maintainer
