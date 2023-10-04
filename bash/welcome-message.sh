#!/bin/bash
#
# This script produces a dynamic welcome message
# it should look like
#   Welcome to planet hostname, title name!

# Task 1: Use the variable $USER instead of the myname variable to get your name
# Task 2: Dynamically generate the value for your hostname variable using the hostname command - e.g. $(hostname)
# Task 3: Add the time and day of the week to the welcome message using the format shown below
#   Use a format like this:
#   It is weekday at HH:MM AM.
# Task 4: Set the title using the day of the week
#   e.g. On Monday it might be Optimist, Tuesday might be Realist, Wednesday might be Pessimist, etc.
#   You will need multiple tests to set a title
#   Invent your own titles, do not use the ones from this example

###############
# Variables   #
###############
title="Overlord"
#welecoming user with their username (depends on who is logging in)
myname="$USER"
hostname="$(hostname)"
#recording the current date and time
datetime="$(date '+It is %A at %I:%M %p.')"
#givivng a different and customizable title to user according to the day on which the welcome message is generated
case "$(date '+%A')" in
    "Monday") title="Optimist";;
    "Tuesday") title="Realist";;
    "Wednesday") title="Pessimist";;
    # Add more cases for other days and titles as needed
    *) title="Undefined";; # Default title
esac


###############
# Main        #
###############
cat <<EOF

Welcome to planet $hostname, "$title $myname!"

EOF
