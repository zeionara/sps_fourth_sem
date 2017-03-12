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
  ;first lab data
  arr1 dd -11,-2,-13,42,56,-6,71,8,-9,10,11,-12,13  ;original array
  g1 dd 0FFFFh  ;delemiter
  arr2 dd 13 dup (0) ;additional array
  g2 dd 0FFFFh  ;delemiter
  arr3 dd 13 dup (0)  ;additional array
  numofpoesitives dd ?  ;number of positives in original
  esizeofel = 4

  last dd ?
  greatest dd ?
  meedium dd ?

  gf dd 0FFFh
  arrfinal dd 13 dup(0)
  esizefinal dd ?

  beginning db "Beginning ... ",0
  appName db "DLL",0
  ending db "ending ... ",0
  ;second lab data
  src_msg db "Original string and mask:",0Ah
  stri db "akksdlfkdls;dke84 dj 5jgkfoqwertyuiRUop hfk*DF dfksleofdjekf98JD",0Ah
  msk_msg db 64 DUP(?),0Ah
	rez1_msg db "First result:",0Ah
  stri1 db 64 DUP (48),0Ah
	rez2_msg db "Second result:",0Ah
  stri2 db 64 DUP (48),0Ah,0

	first db 'R'
	second db 'U'
	flag db 0
	msk_o dq 0FEDCBA9876543210h


	msk_l dd 0FFFFF000h
	msk_h dd 0000FFFFFh
  FontName db "Courier New",0
  hFont dd ?
.code

  DllEntry proc hInstDLL:HINSTANCE, reason:DWORD, reserved1:DWORD
    mov  eax,TRUE
    ret
  DllEntry Endp

  TestFunction proc content:LPCTSTR
    invoke MessageBox,NULL,content,addr AppName,MB_OK
    ret
  TestFunction endp

  FirstLab proc aac:LPDWORD
    ;first part - get array, containing negative elements from original at the beginning and sorted positives - at the end
    mov ebx, aac
    mov [ebx], offset arrfinal

    mov ecx,13
    xor esi,esi
    xor edi,edi

    lp1: ;Copying negatives to arr2
      mov edx,arr1[esi]
      cmp edx,0
      jg morethanzero
          mov arr2[edi],edx
          add edi,esizeofel
      morethanzero:
          ADD esi,esizeofel
    loop lp1

    mov ecx,13
    xor esi,esi
    xor edi,edi

    lp2: ;Copying positives to arr3
      mov edx,arr1[esi]
      cmp edx,0
      jle lessethanzero
          mov arr3[edi],edx
          add edi,esizeofel
      lessethanzero:
          add esi,esizeofel
    loop lp2

    xor esi,esi
    mov esi, esizeofel
    continue_shift:
      shr esi,1
      shr edi,1
      cmp esi, 0
    jg continue_shift
    mov ecx,edi
    mov numofpoesitives,ecx
    xor edi,edi

    sort_external_loop:  ; External loop of bubblesort
      mov edx,arr3[esi]
      mov edi,esi
      push ecx
      dec ecx
      cmp ecx,0
      jle end_of_sort
      sort_internal_loop:  ; Internal loop of bubblesort
        add edi,esizeofel
        mov eax,arr3[edi]
        cmp edx,eax
        jl bubble_up
        jmp final_internal_loop
        bubble_up:
          xchg edx,eax
          mov arr3[edi],eax
          mov arr3[esi],edx
        final_internal_loop:
      loop sort_internal_loop
      pop ecx
      add esi,esizeofel
    loop sort_external_loop
    end_of_sort:

    xor esi,esi
    xor edi,edi
    mov ecx,numofpoesitives
    mov edi,48

    replacing: ; Copying elements from arr3 to the end of arr2
      mov edx,arr3[esi]
      mov arr2[edi],edx
      add esi,esizeofel
      sub edi,esizeofel
    loop replacing

    ;THE
    ;SECOND
    ;PART

    mov esi,48
    mov edx, arr1[esi]
    mov last,edx

    mov ecx, numofpoesitives
    cmp ecx, 0
    jle find_greatest
    xor esi,esi
    mov edx,arr3[esi]
    mov greatest, edx
    jmp cmeedium

    ; If there are not positives, then sort original array for fineding greatest value

    find_greatest:
    xor esi,esi
    xor edi,edi
    mov ecx,13

    sort_1_external_loop:
      mov edx,arr1[esi]
      mov edi,esi
      push ecx
      dec ecx
      cmp ecx,0
      jle end_of_sort_1
      sort_1_internal_loop:
        add edi,esizeofel
        mov eax,arr1[edi]
        cmp edx,eax
        jl bubble_up_1
        jmp final_sort_1
        bubble_up_1:
          xchg edx,eax
          mov arr1[edi],eax
          mov arr1[esi],edx
        final_sort_1:
      loop sort_1_internal_loop
      pop ecx
      add esi,esizeofel
    loop sort_1_external_loop
    end_of_sort_1:

    XOR esi,esi
    MOV edx,arr1[esi]
    MOV greatest, edx

    cmeedium:
    MOV edx, last
    ADD edx, greatest
    SHR edx, 1
    MOV meedium, edx

    XOR esi,esi
    XOR edi,edi
    MOV ecx,13
    LEA ebx,arr2

    lp3:
      mov eax,[ebx + esi]
      cmp eax,edx
      jle continue
      push ebx
      lea ebx,arrfinal
      mov [ebx + edi], eax
      add edi, esizeofel
      pop ebx
      continue:
      ADD esi, esizeofel
    loop lp3

    SHR edi,2
    MOV ecx, edi
    MOV esizefinal, ecx

    ret
  FirstLab endp

  SecLab proc
    xor esi,esi
    xor edi,edi
    mov ecx,64

    mov ebx, offset msk_o
    mov eax,[ebx + esi]
    mov msk_l, eax
    add esi,4
    mov eax,[ebx + esi]
    mov msk_h, eax

    XOR esi,esi

    lp0:
     clc
     rcr msk_h, 1
     rcr msk_l, 1
     JNC zeroinmask
     oneinmask:
       mov msk_msg[esi], 49
       jmp end_of_lp0
     zeroinmask:
       mov msk_msg[esi], 48
     end_of_lp0:
       add esi,1
    loop lp0

    xor esi,esi
    xor edi,edi
    mov ecx,64

    mov ebx, offset msk_o
    mov eax,[ebx + esi]
    mov msk_l, eax
    add esi,4
    mov eax,[ebx + esi]
    mov msk_h, eax

    xor esi,esi

    lp1:
     clc
     rcr msk_h, 1
     rcr msk_l, 1
     jnc end_of_lp1
       mov al, stri[esi]
         cmp al,97
         jl end_of_lp1
         cmp al,122
         jg end_of_lp1
       mov stri1[edi],al
       add edi,1
       end_of_lp1:
       add esi,1
     loop lp1

   mov cx,64
   mov esi,63
   xor di,di
   lp2:
    mov al,stri[si]
    cmp flag,1
    je if_R_break
    jmp cont2
    if_R_break:
     cmp first, al
     mov stri2[di],al
     je exit_lp2
     cont2:
       cmp second, al
       je setflag
       jmp cont1
       setflag:
          mov flag,1
       cont1:
          mov stri2[di],al
          add di,1
     end_of_lp2:
     dec si
   loop lp2
   exit_lp2:

   cmp cx,0
   je afterlp2
     DEC di
     mov stri2[di],0Ah
     INC di
     mov stri2[di],0
   afterlp2:

   ; Outputing

   invoke MessageBox,NULL,addr src_msg,addr appName,MB_OK
   ret
  SecLab endp
End DllEntry
