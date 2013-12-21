#!/bin/bash

umq recv "$1" "$2" | {
  while read -r chunk; do
    echo "$chunk" | wall
  done
}
