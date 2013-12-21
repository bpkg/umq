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

### RECEIVING

```
$ umq recv localhost 3000 | { \
  while read -r line; do \
    printf "got: '%s\n"; \
  done; \
}
```

### PUSHING

```
$ echo "ping" | umq push localhost 3000
```

```
got: 'ping'
```

## AUTHOR

  - Joseph Werle <joseph.werle@gmail.com>

## REPORTING BUGS

  - https://github.com/jwerle/umq/issues

## SEE ALSO

  - https://github.com/jwerle/umq

## LICENSE
  
  MIT (C) Copyright Joseph Werle 2013
