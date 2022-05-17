#! /bin/bash

echo "Hello World"

# color codes
# red     31
# Green   32
# Yellow  33
# Blue    34
# Magenta 35
# Cyan    36

# syntax : echo -e "\e[31mHello\e[0m"

echo -e "\e[31mHello\e[0m" World
echo -e "\e[32mHello\e[0m" "\e[31mWorld\e[0m"

