#!/bin/bash
#
# this script demonstrates doing arithmetic

# Task 1: Remove the assignments of numbers to the first and second number variables. Use one or more read commands to get 3 numbers from the user.
# Task 2: Change the output to only show:
#    the sum of the 3 numbers with a label
#    the product of the 3 numbers with a label

# taking 3 numbers from the user one by one
echo "Enter the first number:"
read firstnum

echo "Enter the second number:"
read secondnum

echo "Enter the third number:"
read thirdnum
# calculating the output 
sum=$((firstnum + secondnum + thirdnum))
product=$((firstnum * secondnum * thirdnum))
# now showing it to the user with correct label
cat <<EOF
The sum of the three numbers is: $sum
The product of the three numbers is: $product
EOF

