# 기본적으로 빌드를 수행할 목록
all: Kernel32.bin

# 부트 로더의 기능을 테스트 하기 위한 가상의 OS 이미지 빌드
Kernel32.bin: Source/EntryPoint.s
	nasm -o Kernel32.bin $<

# 소스 파일을 제외한 나머지 파일 정리	
clean:
	rm -f Kernel32.bin