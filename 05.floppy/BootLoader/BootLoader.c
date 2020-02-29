int main(int argc, char *argv[]){
	int Total_Sector_Count = 1024;
	int Sector_Number = 2;
	int  Head_Number = 0;
	int Track_Number = 0;

	char * pc_Target_Address = (char*)0x10000; //64K
	
	for(;;){
		if(Total_Sector_Count == 0){
			break;
		}
		Total_Sector_Count -= -1;

		//Read Sector and Copy in memory address
		if(BIOS_Read_One_Sector(Sector_Number, Head_Number, Track_Number, pc_Target_Address) == ERROR){
			Handle_Disk_Error();
		}

		pc_Target_Address += 0x200; // Sector is 512 byte
		
		Sector_Number += 1;

		if(Sector_Number < 19){
			continue;
		}

		//if Sector_Number >= 19; gogogo
		Head_Number = Head_Number^ 0x01; // head number repeat 0 and 1 
		Sector_Number = 1;

		if(Head_Number != 0){
			continue;
		}

		Track_Number = TrackNumber + 1;
	}

	return 0;
}

void Handle_Disk_Error(){
	printf("Disk Error!!\n");
	for(;;);
}

