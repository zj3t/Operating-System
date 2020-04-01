import sys,os
BYTESOFSECTOR=512
import shutil
def CopyFile(iSourcefd,iTargetFd):    
    iSourceFileSize=0    
    while(True):
        iBuf=iSourcefd.read(BYTESOFSECTOR)
        
        iWrite=iTargetFd.write(iBuf)        
  
        if (iWrite==-1):        
            print("ERORR")
            exit(-1)        
        iSourceFileSize+=int(iWrite)
        if (not iBuf):
            break
    return iSourceFileSize
    
def WriteKernellnformation(iTargetFd,iKerne132SectorCount):
    usData=0
    IPostion=iTargetFd.seek(7) #System align
    if (IPostion==-1):
        error_print("seek fail")
    usData=int(iKerne132SectorCount)    
    iTargetFd.write(str(usData).encode())
    print("[INFO] Total sector count except boot loader {0}".format(usData))

def AdjustInSEctorSize(iSourcefd,iTargetFd,iSourceSize):
    i=0
    iAdjustSzieToSector=0
    cCh=0x00    
    iSectorCount=iSourceSize%BYTESOFSECTOR
    
    if (iAdjustSzieToSector!=0):
        iAdjustSzieToSector = BYTESOFSECTOR - iAdjustSzieToSector
        
        print("[INFO] FIsize {0} and fill {1} byte".format(iSourcefd,iAdjustSzieToSector))        
        for v in range(0,iAdjustSzieToSector):
            iSourcefd.write(cCh)
    else:
        print( "[INFO] File size is aligned 512 byte")
    iSectorCount = (iSourceSize+iAdjustSzieToSector)/BYTESOFSECTOR
    return int(iSectorCount)
    
def error_print(msg):
    print("[ERRoR] \t"+str(msg))

def main(option):
    iSourcefd=0
    iTargetFd=0
    iBootLoaderSize=0
    iKernel32SectorCount=0
    iSourceSize=0
    if len(option)<3:
        error_print(" example) python3 imagerMaker.py BootLoader.bin Kernel32.bin")
    iTargetFd=open('Disk.img','wb')
    if not iTargetFd:
        error_print("Disk im open fail")
    print("[INFO] Copy boot load to image")
    iSourcefd=open("00.BootLoader/"+str(option[1]),'rb')
    if not iSourcefd:
        error_print("Not open "+str(option[1]))
    iSourceSize = CopyFile(iSourcefd,iTargetFd)        
    iSourcefd.close()
    iBootLoaderSize=AdjustInSEctorSize(iTargetFd,iSourcefd,iSourceSize)
    print("[INFO] {0} size = {1} and sector count {2}".format(option[1],iSourceSize,iBootLoaderSize))
    print("[INFO] Copy protected mode kernel to image file")

    iSourcefd=open("01.Kernel32/"+str(option[2]),'rb')
    if not iSourcefd:
        error_print("Not open "+str(option[2]))
    iSourceSize = CopyFile(iSourcefd,iTargetFd)
    iKernel32SectorCount=AdjustInSEctorSize(iTargetFd,iSourcefd,iSourceSize)
    
    print("[INFO] {0} size = {1} and sector count {2}".format(option[2],iSourceSize,iKernel32SectorCount))
    print( "[INFO] Start to write kernel information" )

    WriteKernellnformation(iTargetFd,iKernel32SectorCount)
    print( "[INFO] Image file create complete")
    iTargetFd.close()
    
main(sys.argv)






