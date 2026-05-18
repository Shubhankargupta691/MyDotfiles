#!/bin/bash

# chmod +x Listner.sh
# ./Listner.sh
#  or
# send file
# ./Listner.sh < file
# receive file
# ./Listner.sh > file

# Configuration
PORT=4444

echo " Listening on port: $PORT                "


# Infinite loop to keep restarting netcat if it closes
while true; do
    echo "[$(date +%T)] Launching Netcat listener..."
    
    # Run the listener. (Adjust flags to 'nc -lnk $PORT' if your version requires it)
    rlwrap -f . -r nc -l -n -v -k -p $PORT
    
    echo "[$(date +%T)] Connection closed or process exited."
    echo "Restarting listener in 2 seconds..."
    echo "-----------------------------------------"
    sleep 2
done
