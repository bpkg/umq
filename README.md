umq
=====

tcp/udp message pushing and receiving in bash

## install

```sh
$ make
$ make check
$ make install
```

## usage

**server**

Listening on localhost can be achieved by simple providing a port:

```sh
$ umq recv 3000 | { \
  while read -r line; do \
    echo "got: '$line'"; \
  done; \
}
```

This will create a server and listen on localhost port `3000` for all incoming tcp/udp messages.

**connecting**

You can connect and read from the server by using `umq recv` with a host and port:

```sh
$ umq recv localhost 3000
```

**pushing**

Pushing data to a umq receiver can be performed via `umq push`:

```sh
$ echo "ping" | umq push localhost 3000
```

This should yield the following response on the server:

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

## caveats

When multiple peers are connected via `umq recv <host> <port>` to a single umq receiver, messages are emitted to
each peer via the (RR) [Round-Robin](http://en.wikipedia.org/wiki/Round-robin_scheduling) technique. For example:

**server**

```sh
$ umq recv 3000 | while read -r chunk; do echo "chunk: $chunk"; done
chunk:
chunk: 0
chunk: 1
chunk: 2
chunk: 3
chunk: 4
chunk: 5
chunk: 6
chunk: 7
chunk: 8
chunk: 9
chunk: 10
chunk: 11
```

**pusher**

```sh
$ i=0 while true; do echo echo "$i"; ((++i)); sleep .5; done | umq push localhost 3000
```

**peer 1**

```sh
$ umq recv localhost 3000

2
3
4
5
8
9
10
11
```

**peer 2**

```sh
$ umq recv localhost 3000

6
7
```


## license

MIT
