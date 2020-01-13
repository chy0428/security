# GBC Security_03

## HW #3

### 1. 자신의 실험 결과에 대한 write-up
---
#### 1. Review

* 가상메모리는 커널 영역과 사용자 영역으로 나뉜다.
* 커널 영역 : 커널 관련 메모리 로드, 시스템 콜을 통해서만 접근 가능
* 사용자 영역 : stack(함수의 인자, 함수의 리턴 주소값, 지역 변수), heap(동적 할당 메모리), BSS(초기화x, 0으로 초기화된 전역, static변수), data(초기화된 전역, static 변수), text(실행될 어셈블리어들이 저장됨)

#### 2. wirte-up (1)
* 스택 영역에 메모리가 저장되는 과정을 정확히 이해하지 못해서 다시 공부해보았다.  
* c코드로는 메모리 사용을 알 수 없는데, 어셈블리 코드로 보면 그 과정이 전부 나와있는 것을 알았다. 
* 함수 호출 시와 함수 인자 전달 시에, 스택에서 어떤 일들이 일어나는지 알아보고 싶어서 간단한 c코드를 gdb로 디버깅하여 어셈블리어 코드를 살펴보았다.

> 다음과 같은 c코드를 gdb로 디버깅한다.


```{.c}
#include <stdio.h>

int add(int x, int y);
int main(){
    int x = 5, y = 10;
    int result = add(x, y);
    printf("result = %d\n", result);
}
int add(int x, int y){
    return x + y;
}
```
> 컴파일 시, 디버그 모드로 컴파일하면 소스코드를 같이 볼 수 있다.

![hw0](https://user-images.githubusercontent.com/47182864/61030788-22f24e00-a3f9-11e9-893c-39468370e0c9.png)

> c코드에서 int형 변수 x와 y를 각각 5와 10으로 초기화했는데, 어셈블리 코드에서는 *main+4의 sub rsp, 0x10으로 스택에 0x10만큼의 공간을 할당한 후, mov 명령어로 스택의 공간 [rbp-0xc]에 5를, [rbp-8]에 10을 넣어주고 있다. _변수를 2개 선언하면 스택의 2개의 공간에 저장된다._
0x10만큼의 공간에는 int형 변수를 4개까지 담을 수 있으며, 변수 선언을 5개 할 경우에는 스택에 할당하는 크기 또한 증가한다. (0x20)

![hw1](https://user-images.githubusercontent.com/47182864/61030790-238ae480-a3f9-11e9-8f07-b34bab8359a4.png)


??? 함수 호출 시, 스택의 이용을 보고 싶어서 해봤는데 지역변수 저장하는 것밖에 볼 수 없었다. 너무 간단한 함수라 그런가 호홓호ㅎ?ㅜㅜ

> `ret`: CPU가 함수를 호출해서 프로그램의 흐름을 바꿀 때 `call`을 사용하고, 원래 있던 곳으로 되돌아 갈 때 `ret` 명령어를 사용한다. call 명령어가 스택에 저장해놓은 return 주소값을 Pop해서 rip레지스터에 저장해준다고 어제 찬솔님이 설명하셨다.

![hw1-2](https://user-images.githubusercontent.com/47182864/61031122-d4917f00-a3f9-11e9-9f35-121dcf0798d3.png)

* 찾다보다 보니 이거 c배울때 배웠던 것 같다ㅎㅎㅎ. 다시 보자!

> 스택 프레임 : 함수 호출시 할당되는 메모리 블록
> 함수 호출이 완료되면, 기존에 선언된 지역변수에 접근이 불가능하다. (할당된 메모리 반환되므로)
> 아래 그림에서, fct2() 함수가 호출되면서 함수 내부에 선언된 변수 e, h가 스택에 할당 -> 이 메모리 블록이 fct2()의 스택 프레임이라 한다.

![hw5](https://user-images.githubusercontent.com/47182864/61034071-88493d80-a3ff-11e9-9fe1-295ec58af534.png)

> sp register : 스택 프레임을 가리키는 레지스터 (32bit : esp , 64bit : rsp)
> sp는 변수가 할당될 때마다 증가하면서, 다음 변수가 할당될 메모리 위치를 가리킨다.


![hw5-1](https://user-images.githubusercontent.com/47182864/61034067-87b0a700-a3ff-11e9-8bf2-809101316307.png)

* breakpoint를 add()함수로 걸고 다시 어셈블리 코드를 살펴보면 스택 현황을 볼 수 있었다!!!

 ![add](https://user-images.githubusercontent.com/47182864/61036160-7ff30180-a403-11e9-975c-163ea1088c86.png)

#### 3. write-up (2)
* malloc으로 할당한 메모리는 정말 힙 영역으로 구분되어 있을까 ?! 이것도 어셈블리 코드로 확인해보기로 했다!  

> 이번에도 간단한 코드를 작성해서...

```{.c}
#include <stdio.h>
#include <stdlib.h>
 
int main(){
    int *m = NULL;
    m = (int*)malloc(20 * sizeof(int));
 
    for(int i = 0; i < 20; i++){
        m[i] = i;
    }
 
    for(int i = 0; i < 20; i++){
        printf("%d\n", i);
    }
 
    free(m);
    return 0;
}
```
> debug 모드로 컴파일하여 gdb로 열어본다. for문을 돌면서 malloc을 이용한 배열 m[i]에 값을 할당해줄때, heap영역이 이용되는 것을 볼 수 있다. 파란색으로 표시된 것이 heap영역, 노란색으로 표시된 것이 stack영역이다.

![heap](https://user-images.githubusercontent.com/47182864/61032802-1b34a880-a3fd-11e9-9727-35e75fa48181.png)


---
### 2. 리버싱 문제
---
#### 1. crackme0x00a

> __[방법1]__ `gdb ./crackme0x00a`로 열어서, `strcmp`함수를 호출하는 부분을 확인한다.  
>  s1인 `g00dJOB!`와 입력한 s2가 같을 경우, pass이다.

![hw3-1-1](https://user-images.githubusercontent.com/47182864/60992839-48933f00-a388-11e9-818d-205a6c0b033a.png)

> __[방법2]__ 리눅스 리버싱 툴 중 하나인 xxd를 이용해보았다.  
> `xxd ./crackme0x00a`로 열어서 살펴본다.  
> 사진과 같이 암호가 적혀있다!

![hw3-1-3](https://user-images.githubusercontent.com/47182864/60991863-4d56f380-a386-11e9-88e7-e502712d494f.png)

> __[Result]__ pw : `g00dJOB!`

![hw3-1-2](https://user-images.githubusercontent.com/47182864/60989844-f4855c00-a381-11e9-8e02-fc2d570335dd.png)


#### 2. crackme0x00b

> __[방법1]__ `gdb ./crackme0x00b`로 열어서, `wcscmp`함수를 호출하는 부분을 확인한다.  


![hw3-2-1](https://user-images.githubusercontent.com/47182864/60993828-30242400-a38a-11e9-920a-2b4c05cdbf21.png)
> `x/s 0x804a040` : 0x804a040에서 시작하는 문자열 출력  
> 10개의 메모리를 열어봤는데 뭔가 잘리길래 40으로 늘려봤더니 전부 출력되고, completed가 끝을 알려줌!
> 조합해보면 `w0wgreat`가 되고, 이것이 pw이다.

![hw3-2-2](https://user-images.githubusercontent.com/47182864/60994005-8d1fda00-a38a-11e9-8d88-e03edab33e5d.png)

> __[방법2]__ `xxd ./crackme0x00b`로 열어서 살펴본다.  
> 해보니까 GCC : (Ubuntu) ~ 여기 윗부분에 암호가 들어가는 것 같다.

![hw3-2-4](https://user-images.githubusercontent.com/47182864/60994070-b476a700-a38a-11e9-8598-c5ea53b7b260.png)

> __[Result]__ pw : `w0wgreat`

![hw3-2-3](https://user-images.githubusercontent.com/47182864/60994006-8d1fda00-a38a-11e9-8d4a-0bd94f8bef07.png)


#### 3. crackme0x01

> `gdb ./crackme0x01`로 열어서, `cmp`부분을 확인한다.  
> 첫번째 지역변수 포인터와 pw을 비교하는 코드를 발견할 수 있다!  

![hw3-3-1](https://user-images.githubusercontent.com/47182864/60996203-2224d200-a38f-11e9-93b2-831a8c44a160.png)

> `0x149a`가 답이 아니길래 10진수로 변환해보았다.  
> 16진수 - 10진수 변환 계산기 : <https://ko.calcuworld.com/%EC%88%98%ED%95%99/16%EC%A7%84%EB%B2%95-%EA%B3%84%EC%82%B0%EA%B8%B0/>

![hw3-2](https://user-images.githubusercontent.com/47182864/60996359-67490400-a38f-11e9-9f30-cbb061e992a7.png)

> 찾아보니 gdb환경에서 `print + 16진수`를 사용하여 10진수로 변환할 수 있었다..

![hw3-3](https://user-images.githubusercontent.com/47182864/60996361-67490400-a38f-11e9-9a89-a09da5b14434.png)

> __[Result]__ pw : `5274`

![hw3-4](https://user-images.githubusercontent.com/47182864/60996362-67490400-a38f-11e9-82c1-d9c1f9781ffc.png)

> xxd로는 1,2와 같이 문자열이 나와있지 않아 실패했다 ㅜㅜ


#### 4. crackme0x02
> `gdb ./crackme0x02`로 열어서, `cmp`부분을 확인한다.  
> `eax`와 `ebp-0xc`를 비교하는 부분을 찾을 수 있다. 

![hw4-1](https://user-images.githubusercontent.com/47182864/61002411-74b8bb00-a39c-11e9-9148-bd92b66ae7ce.png)

> `x/x $ebp-0xc` : ebp-0xc를 기준으로 16진법(x)으로 1개 보여준다.
> 

![hw4-2](https://user-images.githubusercontent.com/47182864/61002412-74b8bb00-a39c-11e9-9b76-650fe5097b04.png)

> `x/u $ebp-0xc` : u옵션을 사용하면 10진법으로 표시할 수 있다.

![hw4-5](https://user-images.githubusercontent.com/47182864/61002754-396abc00-a39d-11e9-8dcf-ea02f15d5d86.png)

> __[Result]__ pw : `338724`

![hw4-3](https://user-images.githubusercontent.com/47182864/61002414-75515180-a39c-11e9-9a60-07a79af4242a.png)

#### 5. crackme0x03

> main을 break point를 걸어서 살펴봤는데 cmp가 없이 종료되었다.  
> call test를 하는데 이게 따로 test라는 함수가 있어서 main에서 확인이 안되는 것 같다.

![h5](https://user-images.githubusercontent.com/47182864/61037378-e711b580-a405-11e9-9093-96bdb6fa5c91.png)

> test를 break point하여 살펴본다.

![h5-1](https://user-images.githubusercontent.com/47182864/61037374-e6791f00-a405-11e9-9f96-97c156b0f932.png)

> 이렇게 cmp를 찾을 수 있다!!@!

![h5-2](https://user-images.githubusercontent.com/47182864/61037375-e6791f00-a405-11e9-8d45-311ac41a5a88.png)

> 02번과 똑같은 방식으로 암호를 찾아준다.
> 10진수로 한 번에 보여주는 `x/u` 옵션을 사용한다.

![h5-3](https://user-images.githubusercontent.com/47182864/61037376-e6791f00-a405-11e9-8131-795e7dfc52ef.png)

> __[Result]__  pw : `338724`

![h5-4](https://user-images.githubusercontent.com/47182864/61037377-e711b580-a405-11e9-905d-45e8ab22eb6a.png)


#### 5. crackme0x04

crackme0x02랑 3이랑 암호가 똑같길래 4에도 넣어봤는데 실패 . . 

---
### 3. Plus
---
*  xxd  
	* `xxd` : 주어진 파일이나 standard input으로 들어온 문자들에 대해서 `hex dump`(컴퓨터 데이터의 16진법 보임)을 만들어 주며, 에디안에 관계 없이 파일에 존재하는 순서대로 출력된다.  
	* 사용법 :  <https://linux.die.net/man/1/xxd>

* dword, word, byte
	- dword : 4byte(eax)
		- dword ptr (명령) : 지금 이 (명령)은 operand의 용량 중 dword만큼의 공간을 이용함
	- word : 2byte(ax)
	- byte : 1byte(al,ah)
	
* 범용 레지스터 (이해가 부족해서 찾아봄).   
	i. EAX (Extended Accumulator Register)
	 - 산술, 논리연산을 수행하며 함수의 반환값이 레지스터에 저장된다.
	 - 덧셈, 곱셈, 나눗셈 등의 명령은 모두 EAX레지스터를 사용하며, 함수의 리턴 값이 eax 레지스터에 저장되므로, 호출 함수의 성공/실패 여부를 쉽게 파악할 수 있으며, 리턴 값을 쉽게 얻어올 수 있다.
	 - `ebx(Extended Base Register)` : 메모리 주소를 저장하기 위한 용도
	 - `edx(Extended Data Register)` : 큰 수의 곱셈, 나눗셈 등의 연산이 이루어질 때, `EAX`와 같이 사용됨  
	  
	ii. ECX (Extende Counter Register)  
	 - 반복 명령어 사용시 반복 카운터로 사용되는 레지스터  
	 - ecx레지스터에 반복할 횟수를 지정하고, 반복 작업을 수행함
	   
	iii. EXI/EDI (Extended Source/Destination Index)  
	 - `exi` : 데이터를 조작하거나, 복사시에 소스 데이터의 주소 저장
	 - `edi` : 복사시, 목적지의 주소 저장  
	 
	iv. ESP/EBP (Extended Stack/Base Pointer)  
	 - `esp` : 스택 프레임의 끝 지점 주소 (스택의 가장 아랫 부분)가 저장됨  
	 			 push, pop 명령에 따라 값이 4byte씩 변함  
	 - `ebp` : 스택 프레임의 시작 지점 주소 (스택의 가장 윗 부분)가 저장됨
	 			 현재 사용되는 스택 프레임이 소멸되지 않는 이상 값이 변하지 않음

* 함수가 호출되는 과정을 스택 프레임로 설명하고 있는 자료
	<https://www.hackerschool.org/HS_Boards/data/Free_Lectures/chapter_13.pdf>
	
---
