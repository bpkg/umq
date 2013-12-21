umq-recv(1) -- tcp/udp listen transport utility
=================================

## SYNOPSIS

`umq-recv <host> <port>` [-hvV] [-f <file>]

## OPTIONS

  `-f, --file` <file>       file to execute on each chunk received
  `-v, --verbose`           show verbose output
  `-h, --help`              display this message
  `-V, --version`           output version

## USAGE

```
$ umq push localhost 3000
```

## AUTHOR

  - Joseph Werle <joseph.werle@gmail.com>

## REPORTING BUGS

  - https://github.com/jwerle/umq/issues

## SEE ALSO

  - https://github.com/jwerle/umq

## LICENSE
  
  MIT (C) Copyright Joseph Werle 2013
