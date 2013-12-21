#!/bin/bash

export OS="`uname`"
export UMQ="`pwd`/umq"
export UMQ_PUSH="$UMQ-push"
export UMQ_RECV="$UMQ-recv"

export EXPECTED="beep"
export HOST="localhost"
export PORT=3000

throw () {
  {
    printf "error: "
    printf "%s" "$@"
    printf "\n"
  } >&2

  exit 1;
}

if [ "Darwin" = "$OS" ]; then
  export -f throw
else
  export throw
fi


echo "starting receiver"
./test/recv.sh &
test_recv_pid=$!

sleep .5
echo "pushing '$EXPECTED'.."
./test/push.sh
test_push_pid=$!

echo "ok"
