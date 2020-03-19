#include "Types.h"

void kPrintString(int iX, int iY, const char* pcString);

void Main(void){
	kPrintString(0, 10, "Switch To IA-32e Mode Success!!!");
	kPrintString(0, 11, "IA-32e C Language Kernel Start..[PASS]");
}

void kPrintString(int iX, int iY, const char * pcString){
	CHARACTER* pstScreen = (CHARACTER*) 0XB8000;
	
	pstScreen += (iY * 80) +iX;

	for(int i=0; pcString[i] !=0; i++){
		pstScreen[i].bCharactor = pcString[i];
	}
}
