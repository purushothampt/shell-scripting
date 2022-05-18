#! bin/bash

a=100
b=puru

echo $a
echo $b is my name
echo ${b}shotham

Date=20220518
echo Todays date is $Date

#command
Date=$(date +%F)
Time=$(date +%T)
Day=$(date +%d)
month=$(date +%m)
echo Todays date is $Date
echo Now the time is $Time
echo The Day is $Day
echo The month is $month

#expression
a=100
b=200
add=$(($a + $b))
mult=$(($a * $b))
echo the sum is $add
echo the mult is $mult

#scalar/arrays
a=(10 20, second "small number")
echo First value of array is $a[0]
echo Second value of array is $a[1]
echo Third value of array is $a[2]
echo Fourth value of array is $a[3]
echo All value of array is $a[*]
echo Count of Array is $#a[*]