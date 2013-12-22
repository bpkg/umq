umq
=====

tcp/udp message pushing and receiving in bash

## install

```sh
$ make install
```

## usage

*recveive*

```sh
$ umq recv localhost 3000 | { \
  while read -r line; do \
    printf "got: '%s\n"; \
  done; \
}
```

*push*

```sh
$ echo "ping" | umq push localhost 3000
```

```
got: 'ping'
```

## api

```sh
usage: umq <command> [-hV]

examples:
$ echo "hello world" | umq push localhost 3000
$ umq recv localhost 3000 | while read line; do \
      echo "msg: $line"; done

commands:
  push <host> <port>      push message to host with port
  recv <host> <port>      receive message on host with port
  help <command>          see more information on a command

options:
  -h, --help              display this message
  -V, --version           output version
```

## examples

### cpu histogram

Using `umq` with [histo](https://github.com/visionmedia/histo) allows
for data to be streamed via tcp to a histo chart

See [cpu-stream](https://gist.github.com/jwerle/8076956) for a preview.

### wall server

Streaming messages to `wall`.

See [wall-server](https://github.com/jwerle/umq/blob/master/examples/wall-server.sh).

## license

MIT
