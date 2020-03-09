#ifndef __MODESWITCH_H__
#define __MODESWITCH_H__

#include "Types.h"

void kRead_CPU_ID(DWORD dwEAX, DWORD* pdwEAX, DWORD *pdwEBX, DWORD *pdwECX, DWORD * pdwEDX);
void kSwitch_And_Execute_64bit_Kernel(void);

#endif /*__MODESWITCH_H__*/
