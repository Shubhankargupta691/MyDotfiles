#!/bin/bash

# Usage:
#   nxcspray <protocols|all> <targets> -u <username> [-p <password> | -H <hash>] [-t <timeout_seconds>]

# ---- Color Definitions ----
YELLOW='\033[1;33m'
NC='\033[0m' # No Color (Resets terminal back to default)

# ---- Signal Trap for Ctrl+C ----
# This catches SIGINT (Ctrl+C) and exits the entire script immediately,
# instead of just skipping the currently running NetExec instance.
trap 'echo -e "\n[-] Script interrupted by user. Exiting..."; exit 1' SIGINT

# ---- Argument Validation ----
if [ "$#" -lt 4 ]; then
    echo "[-] Usage: $0 <protocols|all> <targets> -u <username> [-p <password> | -H <hash>] [-t <timeout_seconds>]"
    exit 1
fi

PROTOS_RAW="$1"
TARGETS_RAW="$2"
shift 2

USER=""
PASS=""
HASH=""
TIMEOUT_VAL="15" 

while getopts "u:p:H:t:" opt; do
    case $opt in
        u) USER="$OPTARG" ;;
        p) PASS="$OPTARG" ;;
        H) HASH="$OPTARG" ;;
        t) TIMEOUT_VAL="$OPTARG" ;;
        *)
            echo "[-] Invalid flag"
            exit 1
            ;;
    esac
done

if [ -z "$USER" ]; then
    echo "[-] Missing required flag: -u <username>"
    exit 1
fi

if [ -z "$PASS" ] && [ -z "$HASH" ]; then
    echo "[-] Missing credentials: You must supply either -p <password> or -H <hash>"
    exit 1
fi

if [ -n "$PASS" ] && [ -n "$HASH" ]; then
    echo "[-] Conflict: Please provide either a password (-p) or a hash (-H), not both."
    exit 1
fi

if [ -n "$PASS" ]; then
    CRED_ARGS=( -p "$PASS" )
else
    CRED_ARGS=( -H "$HASH" )
fi

# ---- Protocol Handling ----
if [ "$PROTOS_RAW" = "all" ]; then
    PROTO_ARRAY=(smb ldap winrm rdp mssql ssh)
else
    IFS=',' read -ra PROTO_ARRAY <<< "$PROTOS_RAW"
fi

# ---- Target Handling ----
if [ -f "$TARGETS_RAW" ]; then
    TARGETS=$(cat "$TARGETS_RAW")
else
    TARGETS="$TARGETS_RAW"
fi

# ---- Spray Loop ----
for PROTO in "${PROTO_ARRAY[@]}"; do
    echo "[+] Spraying protocol: $PROTO"

    for TARGET in $TARGETS; do
        echo "    -> Target: $TARGET"
        
        timeout "${TIMEOUT_VAL}s" nxc "$PROTO" "$TARGET" -u "$USER" "${CRED_ARGS[@]}"
        EXIT_CODE=$?

        # If the user presses Ctrl+C during execution, the exit code might be 130.
        # We check for 130 to ensure the trap triggers cleanly if it hasn't already.
        if [ $EXIT_CODE -eq 130 ]; then
            exit 1
        fi

        # Exit code 124 means the timeout limit was hit
        if [ $EXIT_CODE -eq 124 ]; then
            echo -e "${YELLOW}    [!] Warning: Service is taking too much time. Skipping target ($TARGET via $PROTO).${NC}"
        fi
    done
done





#```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````
#                                            Old Code
#```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

# #!/bin/bash

# # Usage:
# #   nxcspray <protocols|all> <targets> -u <username> -p <password>
# #
# # Examples:
# #   nxcspray all 10.10.10.10 -u bob -p password
# #   nxcspray smb,ldap,winrm hosts.txt -u bob -p password

# # ---- Argument Validation ----
# if [ "$#" -lt 4 ]; then
#     echo "[-] Usage: $0 <protocols|all> <targets> -u <username> -p <password>"
#     exit 1
# fi

# PROTOS_RAW="$1"
# TARGETS_RAW="$2"
# shift 2

# USER=""
# PASS=""

# while getopts "u:p:" opt; do
#     case $opt in
#         u) USER="$OPTARG" ;;
#         p) PASS="$OPTARG" ;;
#         *)
#             echo "[-] Invalid flag"
#             exit 1
#             ;;
#     esac
# done

# if [ -z "$USER" ] || [ -z "$PASS" ]; then
#     echo "[-] Missing required flags: -u <username> -p <password>"
#     exit 1
# fi

# # ---- Protocol Handling ----
# if [ "$PROTOS_RAW" = "all" ]; then
#     PROTO_ARRAY=(smb ldap winrm rdp mssql ssh)
# else
#     IFS=',' read -ra PROTO_ARRAY <<< "$PROTOS_RAW"
# fi

# # ---- Target Handling ----
# if [ -f "$TARGETS_RAW" ]; then
#     TARGETS=$(cat "$TARGETS_RAW")
# else
#     TARGETS="$TARGETS_RAW"
# fi

# # ---- Spray Loop ----
# for PROTO in "${PROTO_ARRAY[@]}"; do
#     echo "[+] Spraying protocol: $PROTO"

#     for TARGET in $TARGETS; do
#         echo "    -> Target: $TARGET"
#         nxc "$PROTO" "$TARGET" -u "$USER" -p "$PASS"
#     done
# done

