#!/bin/bash
#
# this script rolls a pair of six-sided dice and displays both the rolls
#

# Task 1:
#  put the number of sides in a variable which is used as the range for the random number
#  put the bias, or minimum value for the generated number in another variable
#  roll the dice using the variables for the range and bias i.e. RANDOM % range + bias

# Task 2:
#  generate the sum of the dice
#  generate the average of the dice

#  display a summary of what was rolled, and what the results of your arithmetic were

# Tell the user we have started processing
echo "Rolling..."


#take the variables for side and bias
sides=6
bias=1
#modifying the dice rolls on the basis of sides and bias
die1=$(( RANDOM % sides + bias ))
die2=$(( RANDOM % sides + bias ))
#now generating the sum and the avaerage of the two outcomes
sum=$((die1 + die2))
average=$((sum / 2))
# display the results
# here the average will be the integer only
echo "Summary:"
echo "Die 1: $die1"
echo "Die 2: $die2"
echo "Sum: $sum"
echo "Average: $average"



