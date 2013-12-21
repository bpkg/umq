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

## example

Using `umq` with [histo](https://github.com/visionmedia/histo) allows
for data to be streamed via tcp to a histo chart

**histo-server.sh**

```sh
#!/bin/sh

umq recv "$1" "$2" | {
  # init view
  echo 0
  while read -r chunk; do
    # emit chunk
    echo "$chunk"
  done
  exit 0
} | histo;

exit $?;
```

Start the histo server:

```sh
$ ./histo-server localhost 3000
```

Stream data to it:

```sh
while true; do
  echo $RANDOM
  sleep .5
done | umq push localhost 3000
```

Which renders a view like this:

```sh
                █
 2000 ․         █
                █
 1826 ․         █
                █
 1652 ․         █
                █
 1478 ․         █
                █
 1304 ․         █
                █
 1130 ․         █
            █   █
  957 ․     █   █
            █   █
  783 ․     █   █
            █   █
  609 ․     █   █
            █   █
  435 ․     █   █
            █   █
  261 ․     █   █
            █   █
   87 ․     █   █
```

## license

MIT
