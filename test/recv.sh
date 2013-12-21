#!/bin/bash

# server
$UMQ_RECV "$PORT" -s | {
  while read -r line; do
    if [ "" = "$line" ]; then
      continue
    fi

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
