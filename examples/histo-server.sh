#!/bin/sh

umq recv "$1" "$2" | {
  # init view
  echo 0
  while read -r chunk; do
    echo "$chunk"
  done
  exit 0
} | histo;

exit $?;
