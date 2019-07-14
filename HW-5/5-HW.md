# GBC Security_05

## HW #5

### 1. Bomb
---
#### 1. yellow
 
> radare2로 열어서 yellow함수의 어셈블리 코드를 확인한다!  
> `movzx eax, byte [obj.buffer]`하여 eax에 해당 버퍼 값을 넣어주고 있다.  
> `cmp al, 0x3A`을 연속하여, al과 A의 값을 비교한다.  
>  byte 즉, buffer의 크기를 +1 해가며, al의 담긴 값과 0x38, 0x34, 0x33, 0x37, 0x31, 0x30, 0x36, 0x35와 비교한다. (이는 각각 84371065와 대응된다.)  
>  중간에 값이 다르면 `jne`에 의해 `0x804977c`로 뛰게 되고, 전부 같으면 `0x804978b`로 뛰어 `obj.wire_yellow`를 0으로 바꾸고 yellow함수를 종료한다.
> > `movzx` : 부호없는 산술 값에 사용되며, byte나 word를 dword 목적지에 전송한다. 0bit로 목적지 피연산자의 왼쪽 bit들을 채운다. (기존의 mov는 byte -> word(X)였지만, movzx는 가능하다). 

> > `al` : 8bit 메모리만 다루고 싶을 때 사용한다.
> > ![al](https://user-images.githubusercontent.com/47182864/61181650-3d7c2f80-a664-11e9-95fd-dbc95bf6f9c8.png)

![bomb](https://user-images.githubusercontent.com/47182864/61140829-3095f980-a507-11e9-8497-6f1f31d88b14.png)

> gdb로 열어보면 __buffer+x__해가며 값을 비교하는 것을 명시적으로 확인할 수 있었고, r2에서 봤던 것과 같이 wire_yellow를 0으로 만들어주고 yellow함수를 종료하고 있다.

![hw5-1-1](https://user-images.githubusercontent.com/47182864/61181703-b8dde100-a664-11e9-9116-781966b79256.png)

> __[Result]__ `password` : 84371065

![bomb-1](https://user-images.githubusercontent.com/47182864/61141374-6b4c6180-a508-11e9-8bdf-6160e2b9761a.png)

#### 2. Green

> 그냥 열어봤는데 답 같은게 있었다!

![green](https://user-images.githubusercontent.com/47182864/61142406-a51e6780-a50a-11e9-9c7e-e1d342766624.png)

> 응 아니였구 ~~

![green-2](https://user-images.githubusercontent.com/47182864/61142649-3a216080-a50b-11e9-9dd7-eb15a33a597c.png)

#### 3. Blue




---
### 2. Etc
---
이렇게 배울 수 있는 건 정말 감사한 일입니당 

---
### 3. plus
---
* `jmp`와 `call`의 차이점
	* jmp는 특정 지역으로 이동, call은 인자 하나를 받아서, 해당 주소의 함수 또는 loop와 같은 문을 부른다. 
	* '부른다' : 주소까지 갈 필요가 없으며, 해당 위치에서 수행하며, 돌아올 주소인 ret을 스텍에 저장한다는 점이 jmp와 다르다.

* 어셈블리어 기초 참고 자료 
	* <http://index-of.co.uk/Assembly/vangelis.pdf>