#!/bin/bash
#
# This script implements a guessing game
# It will pick a secret number from 1 to 10
# It will then repeatedly ask the user to guess the number
# until the user gets it right

# Give the user instructions for the game
cat <<EOF
Let's play a game.
I will pick a secret number from 1 to 10, and you have to guess it.
If you get it right, you get a virtual prize.
Here we go!

EOF

# Pick the secret number and save it
secretnumber=$(($RANDOM % 10 + 1)) # Save our secret number to compare later

# This loop repeatedly asks the user to guess and tells them if they got the right answer
# TASK 1: Test the user input to make sure it is not blank
# TASK 2: Test the user input to make sure it is a number from 1 to 10 inclusive
# TASK 3: Tell the user if their guess is too low or too high after each incorrect guess

read -p "please provide me a number from 1 to 10: " userguess # Ask for a guess
while [ $userguess != $secretnumber ]; do # Ask repeatedly until they get it right
    if [ -z "$userguess" ]; then
        read -p "Please provide a number from 1 to 10: " userguess
    elif [ $userguess -lt $secretnumber ]; then
        echo "better luck next time! Your guess is too low."
        read -p "Try again: " userguess
    else
        echo "almost near to answer! Your guess is too high."
        read -p "Try again: " userguess
    fi
done
echo "You got it! Have a  chocalate milk dude."

