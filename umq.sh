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

version () {
  echo $VERSION
}

usage () {
  echo "usage: umq <command> [-hV]"

  if [ "$1" = "1" ]; then
    echo
    echo "examples:"
    echo "$ echo \"hello world\" | umq push localhost 3000"
    echo "$ umq recv localhost 3000 | while read line; do \\
      echo \"msg: \$line\"; done"
    echo
    echo "commands:"
    echo "  push <host> <port>      push message to host with port"
    echo "  recv <host> <port>      receive message on host with port"
    echo "  help <command>          see more information on a command"
    echo
    echo "options:"
    echo "  -h, --help              display this message"
    echo "  -V, --version           output version"
  fi
}


while true; do
  arg="$1"

  if [ "" = "$1" ]; then
    break;
  fi

  if [ "${arg:0:1}" != "-" ]; then
    cmd="$1"
    cmd_path="`which umq-${cmd}`"
    has_cmd=$?
    shift
    break;
  fi

  case $arg in
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
        usage
      } >&$STDERR
      exit 1
      ;;
  esac
done

if [ ! -z "$cmd" ] && [ "0" = "$has_cmd" ]; then
  $cmd_path $@
elif [ ! -z "$cmd" ]; then
  {
    echo "unknown command '$cmd'"
    usage
  } >&$STDERR
  exit 1
else
  usage 1
  exit 1
fi
