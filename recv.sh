#!/bin/sh

SELF="$0"
VERSION="0.0.1"
NULL=/dev/null
STDIN=0
STDOUT=1
STDERR=2

if [ -t 0 ]; then
  ISATTY=1
else
  ISATTY=0
fi

throw () {
  {
    printf "error: "
    echo "$@"
  } >&$STDERR

  exit 1
}

verbose () {
  if [ "1" = "$VERBOSE" ]; then
    printf "verbose: "
    printf "$@"
    printf "\n"
  fi
}

version () {
  echo $VERSION
}

usage () {
  echo "usage: umq recv <host> <port> [-hV] "

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "$ umq recv localhost 3000 | { \\
      while read -r ch; do echo \"\$ch\"; done"
    echo
    echo "options:"
    echo "  -s, --single            close after first connection"
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

if [ "1" != "$SINGLE" ]; then
  opts="$opts -k "
fi

args="$opts-l $port"
cmd="nc $args"

nc $args | {
  while read -r line; do
    echo "$line"
  done
};

