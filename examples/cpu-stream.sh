#!/bin/bash

# ps -eo pcpu,pid,user,args | sort -r -k1

PS="ps"
VERSION="0.0.1"

version () {
  echo $VERSION
}

usage () {
  echo "usage: cpu-stream [-hvV] [-u <user>] [-f <pattern>]"
  echo "                         [-c <column>] [-p <port>]"

  if [ "$1" = "1" ]; then
    echo
    echo "options:"
    echo "  -p, --port <port>       port to emit on (default: 3000)"
    echo "  -u, --user <user>       filter on user"
    echo "  -f, --filter <pattern>  grep pattern syntax to filter"
    echo "  -c, --column <column>   a csv of columns for \`ps' (default: pcpu)"
    echo "  -v, --verbose           show verbose output"
    echo "  -h, --help              display this message"
    echo "  -V, --version           output version"
  fi
}

column="pcpu"
port="3000"
user=""
filter=""

while true; do
  arg="$1"

  if [ "" = "$1" ]; then
    break;
  fi

  if [ "${arg:0:1}" != "-" ]; then
    shift
    break;
  fi

  case $arg in
    -p|--port)
      port="$2"
      shift 2
      ;;

    -u|--user)
      user="$2"
      column="${column},user"
      shift 2
      ;;

    -f|--filter)
      filter="$2"
      shift 2
      ;;

    -c|--column)
      column="$2"
      shift 2
      ;;

    -h|--help)
      usage 1
      exit 1
      ;;

    -V|--version)
      version
      exit 0
      ;;

    -v|--verbose)
      VERBOSE="--verbose"
      shift
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

"${PS}" -eo "${column}" | sort -r -k2 | tail -n +2 | grep "${user}" | grep "${filter}" | head -1 | {
  while read -r n; do
    case "$n" in
      **[0-9]**)
        v="`echo \"$n * 100\" | bc`"
        printf "%1.f\n" "$v"
        sleep .5
        ;;
    esac
  done
};

exit $?
