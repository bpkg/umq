#!/bin/sh

CMD="$1"
CMD_PATH="`which umq-$CMD`"

if [ "umq" = "$CMD" ]; then
  man umq
  exit 0
elif [ -z "$CMD_PATH" ]; then
  {
    echo "unknown command '$CMD'";
  } >&2
  exit 1
else
  man "umq-$CMD"
  exit 0
fi
