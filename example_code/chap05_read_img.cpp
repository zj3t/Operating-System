#include <stdio.h>
void HandleDiskError();
int BIOSReadOneSector(int iSectorNumber, int iHeadNumber, int iTotalSectorCount, int pcTargetAddress);

int main()
{
	int iTotalSectorCount = 1024;
	int iSectorNumber = 2;
	int iHeadNumber = 0;
	int iTrackNumber = 0;

	//physical address to copy img
	char * pcTargetAddress = (char *) 0x10000;
	for(iTotalSectorCount = 1024; iTotalSectorCount>0; iTotalSectorCount--)
	{
		if(BIOSReadOneSector(iSectorNumber, iHeadNumber, iTotalSectorCount, pcTargetAddress))
		{
			HandleDiskError();
		}

		//increase address
		pcTargetAddress += 0x200;

		iSectorNumber++;
		if(iSectorNumber < 19) continue;
		
		iHeadNumber = iHeadNumber ^ 0x01;
		iSectorNumber = 1;

		if(iHeadNumber != 0) continue;

		iTrackNumber++;
	}

	return 0;
}

int BIOSReadOneSector(int iSectorNumber, int iHeadNumber, int iTotalSectorCount, int pcTargetAddress)
{
	
}
void HandleDiskError()
{
	printf("DISK Error~!!");
	while(1);
}
