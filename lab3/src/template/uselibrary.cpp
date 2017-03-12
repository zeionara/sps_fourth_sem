#include <iostream>
#include <cstdlib>
#include <stdio.h>
#include <string.h>
#include <fstream>
#include <time.h>
#include <windows.h>
using namespace std;

int main(){
  HINSTANCE hDll = LoadLibrary("library.dll");
  VOID (*testfunctionprotype)(LPCTSTR);
  VOID (*sort)(LPDWORD);
  if (hDll == NULL){
    cout << "Library is not loaded"<< endl;
    return 1;
  }
  cout << "Library loaded" <<endl;
  FARPROC testfunction = GetProcAddress(hDll,"TestFunction");
  if (testfunction == NULL){
    cout << "Proc wasn't found" << endl;
    return 1;
  }
  cout << "Proc found" << endl;
  testfunctionprotype = (VOID(*)(LPCTSTR))testfunction;
  testfunctionprotype("Soon");

  FARPROC firstlab = GetProcAddress(hDll,"FirstLab");
  if (firstlab == NULL){
    cout << "Proc wasn't found" << endl;
    return 1;
  }
  cout << "Proc found" << endl;
  sort = (VOID(*)(LPDWORD))firstlab;
  DWORD aac = 10;
  sort(&aac);
  cout << "Max element in original array from lab 1 is equal to " << *((LPDWORD)aac) << endl;
  FreeLibrary(hDll);
}
