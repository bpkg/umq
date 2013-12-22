#!/bin/bash

SELF="$0"
VERSION="0.0.1"
NULL=/dev/null
STDIN=0
STDOUT=1
STDERR=2
VERBOSE=0

if [ -t 0 ]; then
  ISATTY=1
else
  ISATTY=0
fi

throw () {
  {
    printf "push: error: "
    echo "$@"
  } >&$STDERR

  exit 1
}

version () {
  echo $VERSION
}

verbose () {
  if [ "1" = "$VERBOSE" ]; then
    printf "push: verbose: "
    printf "$@"
    printf "\n"
  fi
}

usage () {
  echo "usage: umq push <host> <port> [-hvV] "

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "$ echo \"ping\" | umq push localhost 3000"
    echo
    echo "options:"
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

verbose "host='%s'" "$host"
verbose "port='%s'" "$port"

if [ -z "$host" ]; then
  throw "Missing host"
elif [ -z "$port" ]; then
  throw "Missing port"
fi

while read -r line; do
  verbose "push: '%s'" "$line"
  echo "$line" | {
    nc "$host" "$port" | {
      while read chunk; do
        if [ "" != "$chunk" ]; then
          echo "$chunk"
        fi
      done
    } >$NULL

    if [ "1" = "$?" ]; then
      throw "Failed to connect to '$host:$port'"
    fi
  };
done
