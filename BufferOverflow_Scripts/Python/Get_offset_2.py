import socket
import struct

# Target configuration
target_ip = ""  # Target IP address
target_port = 0 # Target port number


# Sending pattern to get offset
# Generate pattern using msf-pattern-create 
buf = ""

payload = bytes(buf, "latin-1") + b"\r\n"



# Send payload
with socket.create_connection((target_ip, target_port)) as conn:
    print(f"[+] Sending {len(payload)} bytes to {target_ip}:{target_port}")
    conn.sendall(payload)
    print("[+] Payload sent successfully.")
