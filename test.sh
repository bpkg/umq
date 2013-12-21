#!/bin/bash

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

export throw

./test/recv.sh &
test_recv_pid=$!

./test/push.sh
test_push_pid=$!

echo "ok"
