#!/bin/sh

while true; do
  echo $RANDOM
  sleep .5
done | umq push localhost 3000
