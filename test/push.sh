#!/bin/bash

echo "$EXPECTED" | umq push "$HOST" "$PORT"

if [ "0" != "$?" ]; then
  echo "recv: umq connect error"
  exit $?
fi

if [ "0" = "$?" ]; then
  echo "push: ok"
else
  echo "push: fail"
fi
