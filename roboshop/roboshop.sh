#! /bin/bash

if [ ! -e components/$1.sh ]; then
  echo -e "/e[38m Component file does not exist/e[0m"
  exit
fi
bash components/$1.sh
