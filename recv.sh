#!/bin/bash

SELF="$0"
VERSION="0.0.1"
NULL=/dev/null
STDIN=0
STDOUT=1
STDERR=2

if [ -z "$TMPDIR" ]; then
  TMPDIR="/tmp"
fi

if [ -t 0 ]; then
  ISATTY=1
else
  ISATTY=0
fi

throw () {
  {
    printf "recv: error: "
    echo "$@"
  } >&$STDERR

  exit 1
}

verbose () {
  if [ "1" = "$VERBOSE" ]; then
    printf "recv: verbose: "
    printf "$@"
    printf "\n"
  fi
}

version () {
  echo $VERSION
}

usage () {
  echo "usage: umq recv <host> <port> [-hsvV] [-f <file>]"

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "$ umq recv localhost 3000 | { \\
      while read -r ch; do echo \"\$ch\"; done"
    echo
    echo "options:"
    echo "  -f, --file <file>       file to execute on each chunk received"
    echo "  -s, --single            close after first connection"
    echo "  -v, --verbose           show verbose output"
    echo "  -h, --help              display this message"
    echo "  -V, --version           output version"
  fi
}

if [ "${1:0:1}" != "-" ]; then
  host="$1"
  shift
fi

if [ "${1:0:1}" != "-" ]; then
  port="$1"
  shift
else
  port="$host"
fi

if [ -z "$port" ]; then
  port="$host"
fi

if [ -z "$host" ]; then
  host=""
fi

while true; do
  arg="$1"

  if [ "" = "$1" ]; then
    break;
  fi

  if [ "${arg:0:1}" != "-" ]; then
    shift
    continue
  fi

  case $arg in
    -f|--file)
      FILE="$2"
      shift 2
      ;;

    -s|--single)
      SINGLE=1
      shift
      ;;

    -v|--verbose)
      VERBOSE=1
      shift
      ;;

    -h|--help)
      usage 1
      exit 1
      ;;

    -V|--version)
      version
      exit 0
      ;;

    *)
      {
        echo "unknown option \`$arg'"
      } >&$STDERR
      usage
      exit 1
      ;;
  esac
done

opts=""

if [ "$host" != "$port" ]; then
  args="$opts"
  cmd="nc $host $port $args"
else
  if [ "1" != "$SINGLE" ]; then
    opts="$opts -k "
  fi
  args="$opts-l $port"
  cmd="nc $args"
fi

verbose "args: $args"

if [ ! -z "$FILE" ]; then
  if ! test -f "$FILE"; then
    throw "'$FILE' doesn't exist"
  fi
fi

if [ "$host" = "$port" ]; then
  MAKEPIPE=1

  pipe="$TMPDIR/_nc_fifo.$host.$port"
  rm -f "$pipe"
  mkfifo "$pipe"

  verbose "pipe: $pipe"
else
  MAKEPIPE=0
fi

verbose "port: $port"
verbose "cmd: $cmd"

{
  echo
  if [ "1" = "$MAKEPIPE" ]; then
    while test -p "$pipe"; do
      cat $pipe;
    done | $cmd | {
      trap "echo exit; rm -f $pipe; exit" SIGINT SIGTERM

      while read -r line; do
        if [ ! -z "$FILE" ]; then
          chunk=`echo "$line" | CHUNK="$line" "$FILE"`
        else
          chunk="$line"
        fi

        if [ "" != "$chunk" ]; then
          echo "$chunk"
          if [ "1" = "$MAKEPIPE" ]; then
            printf "%s\n" "$chunk" >$pipe
          fi
        fi
      done
    }
  else
    while true; do
      while read -r chunk; do
        if [ ! -z "$FILE" ]; then
          chunk=`echo "$chunk" | CHUNK="$chunk" "$FILE"`
        fi

        if [ "" != "$chunk" ]; then
          echo "$chunk"
        fi
        $cmd
      done < <(echo | $cmd)
    done
  fi

}

rm -f "$pipe"
exit $?
