#!/bin/bash

# Keep the container alive.  Otherwise, it will be in CrashLoopBackOff
while :
do
  echo "Press <CTRL+C> to exit."
  export USER_NAME=$(whoami)
  echo "I am ${USER_NAME}."
  getent passwd $USER_NAME
  sleep 10
done
