#!/bin/bash

SELF="$0"

die () {
  local pid="`ps awx | grep \"$SELF\" | awk '{ print $1; exit }'`"
  echo "$pid"
  kill -9 "$pid"
}

# server
umq recv "$HOST" "$PORT" -s -v | {
  while read -r line; do
    echo "got: $line"
    echo "expected: $EXPECTED"

    if [ "$line" != "$EXPECTED" ]; then
      throw "'$line' != '$EXPECTED'"
    fi

    break
  done;

  if [ "0" = "$?" ]; then
    echo "recv: ok"
  else
    echo "recv: fail"
  fi
}

if [ "0" != "$?" ]; then
  echo "recv: umq bind error"
  exit $?
fi
