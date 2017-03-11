.386
.model flat,stdcall

option casemap:none
include D:\Applications\masm32\include\windows.inc
include D:\Applications\masm32\include\user32.inc
include D:\Applications\masm32\include\kernel32.inc

includelib D:\Applications\masm32\lib\user32.lib
includelib D:\Applications\masm32\lib\kernel32.lib

.data
  allPerfect db "All perfect!",0
  AppName db "Lib",0
.code

  DllEntry proc hInstDLL:HINSTANCE, reason:DWORD, reserved1:DWORD
    mov  eax,TRUE
    ret

  DllEntry Endp

  TestFunction proc
    invoke MessageBox,NULL,addr allPerfect,addr AppName,MB_OK
    ret
  TestFunction endp

End DllEntry
