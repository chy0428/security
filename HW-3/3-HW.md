# GBC Security_03

## HW #3

### 1. 자신의 실험 결과에 대한 write-up
---
 
///

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


![hw4-2](https://user-images.githubusercontent.com/47182864/61002412-74b8bb00-a39c-11e9-9b76-650fe5097b04.png)

![hw4-5](https://user-images.githubusercontent.com/47182864/61002754-396abc00-a39d-11e9-8dcf-ea02f15d5d86.png)


![hw4-3](https://user-images.githubusercontent.com/47182864/61002414-75515180-a39c-11e9-9a60-07a79af4242a.png)



---
### 3. Plus
---
*  xxd  
	* `xxd` : 주어진 파일이나 standard input으로 들어온 문자들에 대해서 `hex dump`(컴퓨터 데이터의 16진법 보임)을 만들어 주며, 에디안에 관계 없이 파일에 존재하는 순서대로 출력된다.  
	* 사용법 :  <https://linux.die.net/man/1/xxd>

* dword, word, byte
	- 많이 나오길래 찾아봄
	- dword : 4byte(eax)
		- dword ptr (명령) : 지금 이 (명령)은 operand의 용량 중 dword만큼의 공간을 이용함
	- word : 2byte(ax)
	- byte : 1byte(al,ah)
	
* 범용 레지스터
	- 레지스터에 대한 이해가 부족해서 찾아봄..   
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

---
### 4. Etc
---
소통까지 하시는 그는 빛찬솔 . . . 
아 보안 최고예여어어엉 깐지나요 이래서 컴공해요