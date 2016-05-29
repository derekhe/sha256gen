#!/usr/bin/env bash

read -p "Input your hash:" hash
grep -rnw `dirname $0`/db -e $hash
