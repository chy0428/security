# GBC Security_02

##HW #2

### 1. 어셈블리어로 된 프로그램 분석
--
 
* hello.asm 코드 분석

  
```
1  global    _start  
2  section   .text
3  _start:
4    mov       rax, 1					; system call for write
5    mov       rdi, 1					; file handle 1 is stdout
6    mov       rsi, message				; message의 주소값을 rsi 레지스터에 저장
7    mov       rdx, 13					; number of bytes
8    syscall							; invoke os to do the write
9    mov       rax, 60					; system call for exit
10   xor       rdi, rdi					; exit code 0 
11   syscall							; invoke os to exit
12  section   .data						
13  message:
14   db        "Hello, World", 10   	; note the newline at the end
```


1) ELF 링커나 로더에게 프로그램의 엔트리 포인트를 알려줌.     
  ( --> 로더 혹은 링커는 일반적으로 엔트리 포인트가 _start라고 가정하고 있음.)  
2) 섹션 .text 선언 / 보통 data 섹션에 data가 들어가고, text 섹션에는 코드가 들어감.  
4) write를 위한 system 호출  
5) rdi register에 1을 넣어줌   
6) 출력할 문자열의 주소  
7) byte 수  
8) 쓰기를 수행하기 위한 os 호출  
9) exit을 위한 system 호출  
10) exit code 0  
11) exit을 위한 os 호출  
12) 섹션 .data를 선언 (여기부터 .data section)  
14) 출력할 string + newline at the end

* hello.asm 실행 화면
 ![hw2-1](https://user-images.githubusercontent.com/47182864/60905438-10203200-a2b0-11e9-89b1-3fb9f943d51f.png)

* strlen.asm 코드 분석
  
```
1 BITS 64
2
3 section .text					; 실행할 코드가 저장되는 영역
4 global _start					; 일종의 main 함수
5 
6 strlen:						; strlen 함수
7     mov rax,0					; system call for write                  
8 .looplabel:
9     cmp byte [rdi],0        	; n <= 0?
10    je  .end                	; jump-if-equal   
11    inc rdi                 	; rdi <- rdi + 1
12    inc rax                 	; rax <- rax + 1
13    jmp .looplabel          	; 조건없이 .looplabel로 점프하여 프로그램의 흐름 바꿈 
14 .end:
15    ret                     	; return 
16    
17 _start:						; start 함수
18    mov   rdi, msg              
19    call  strlen				; call strlen
20    add   al, '0'           	; al에 0을 더함
21    mov  [len],al           	; len의 주소 값에 있는 값이 al로 바꿈
22    mov   rax, 1            	; system call for write
23    mov   rdi, 1          	; file handle 1 is stdout
24    mov   rsi, len       		; register rsi에 len 주소 값을 저장
25    mov   rdx, 2        		; register rdx에 2를 저장 (num of byte)
26    syscall           		; invoke os to do the write
27    mov   rax, 60    			; system call for exit
28    mov   rdi, 0    			; exit code 0
29    syscall        			; invoke os to exit
30
31 section .data
32    msg db "hello",0xA,0    	; data to output   
33    len db 0,0xA         		; string length

```

 * strlen.asm 실행 화면
 ![hw2-2](https://user-images.githubusercontent.com/47182864/60905442-12828c00-a2b0-11e9-8658-1efb4a1115c1.png)



Q. 연산을 할 때 변수로 직접 하지 않고 레지스터로 하는 이유  
>                                                                
_CPU의 구성 요소 중 ALU에서 연산을 하게 된다. 하지만 ALU는 메모리(메인 메모리)에 직접 접근을 할 수 없고 오로지 레지스터를 이용해서 접근을 해야 한다. 때문에 레지스터로 변수가 위치한 메모리에 접근을 해 레지스터에 값을 저장하고 이 레지스터로 연산을 수행하는 것이다. 매우 비효울적으로 보이지만, 실제로는 레지스터로 연산하는 것이 매우 빠르다.  이러한 이유 때문에 mov 명렁어로 변수의 값을 레지스터에 담고 연산을 레지스터로 하는 것이다._

--
### 2. hello.asm 업그레이드
--
* result   
   ![hw2-3](https://user-images.githubusercontent.com/47182864/60905798-bd934580-a2b0-11e9-9678-8eaadad4b4e8.png)

--
### 3. hello.asm 업그레이드 (2)
--
* result 
* 
