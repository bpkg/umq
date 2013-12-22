umq(1) -- tcp/udp message transport utility
=================================

## SYNOPSIS

`umq` <command> [-hV]

## OPTIONS

  `-h, --help`              display this message
  `-V, --version`           output version

## COMMANDS

  Push a message to a host with port

  `$ umq push <host> <port>`

  Receive a message on a host with port

  `$ umq recv <host> <port>`

  Display help on a command

  `$ umq help push`

## EXAMPLES

  `$ echo "hello world" | umq push localhost 3000`

  ```
  $ umq recv localhost 3000 | { \
      while read line; do \
        echo "msg: $line"; \
      done; \
     }
  ```

## USAGE

### SERVER

  Listening on localhost can be achieved by simple providing a port:

  ```
  $ umq recv 3000 | { \
    while read -r line; do \
      echo "got: '$line'"; \
        done; \
  }
  ```

  This will create a server and listen on localhost port `3000` for all
  incoming tcp/udp messages.

### CONNECTING

  You can connect and read from the server by using `umq recv` with a host
  and port:

  `$ umq recv localhost 3000`

### PUSHING

  Pushing data to a umq receiver can be performed via `umq push`:

  `$ echo "ping" | umq push localhost 3000`

  This should yield the following response on the server:

  `got: 'ping'`

## CAVEATS

  When multiple peers are connected via `umq recv <host> <port>` to a single
  umq receiver, messages are emitted to each peer via the RR (Round-Robin)

### SERVER

  ```
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

### PUSHER

  ```
  $ i=0 while true; do echo echo "$i"; ((++i)); sleep .5; done | \
    umq push localhost 3000
  ```

### PEER 1
  ```
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

### PEER 2

  ```
  $ umq recv localhost 3000

  6
  7
  ```

## AUTHOR

  - Joseph Werle <joseph.werle@gmail.com>

## REPORTING BUGS

  - https://github.com/jwerle/umq/issues

## SEE ALSO

  - https://github.com/jwerle/umq

## LICENSE
  
  MIT (C) Copyright Joseph Werle 2013
