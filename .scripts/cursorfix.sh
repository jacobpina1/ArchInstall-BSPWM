#!/bin/bash

# Start the application in the background
lxappearance &

# Capture the process ID (PID) of the application
app_pid=$!

# Sleep for 2 seconds
sleep 0.4

# Kill the application using its PID
kill $app_pid

# Optionally, wait for the application to finish exiting
wait $app_pid

# Script complete
#echo "Application has been launched and closed after 2 seconds."

