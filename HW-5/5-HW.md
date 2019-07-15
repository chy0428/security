# GBC Security_05

## HW #5

### 1. Bomb
---
#### 1. yellow
 
> radare2로 열어서 yellow함수의 어셈블리 코드를 확인한다!  
> `movzx eax, byte [obj.buffer]`하여 eax에 해당 버퍼 값을 넣어주고 있다.  
> `cmp al, 0x3X`을 연속해서 수행한다.   
>  byte 즉, buffer의 크기를 +1 해가며, [0x804c2XX]의 값과 0x38, 0x34, 0x33, 0x37, 0x31, 0x30, 0x36, 0x35와 비교한다. (각각의 byte의 대응되는 아스키 코드는 8,4,3,7,1,0,6,5이다.)  
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

> Ebp-4는 0x804c160임  
> Ebp-8 : 변수1, eax+4의 값을 저장하고 있음  
> Ebp-0xc 는 0. 

![blue1](https://user-images.githubusercontent.com/47182864/61187707-c53b5b80-a6af-11e9-992d-f06045478957.png)

> 변수 graph가 뭘 가리키나 봄

![blue2](https://user-images.githubusercontent.com/47182864/61187708-c5d3f200-a6af-11e9-87a0-81279aa92599.png)

> 계속 해봄 뭔가 반복됨

![blue3](https://user-images.githubusercontent.com/47182864/61187709-c5d3f200-a6af-11e9-91db-c98d68a4c42a.png)

> 입력이 'L', 'R', '\n'인지 검사하기 때문에 input은 string이어야 하며, 유효한 문자는 L, R , \n이다. `0x08049a84`를 보면 input 문자열이 15byte보다 작거나 같아야 됨을 알 수 있다.

![blue4](https://user-images.githubusercontent.com/47182864/61187710-c5d3f200-a6af-11e9-887a-1ce6dbdfc103.png)
![blue5-2](https://user-images.githubusercontent.com/47182864/61187711-c5d3f200-a6af-11e9-99c0-f3a6944ea5a5.png)
![blue6](https://user-images.githubusercontent.com/47182864/61187712-c66c8880-a6af-11e9-8b61-a69f585ebed1.png)

> L을 입력할 시 ->  `var_4h`가 0x0804c160(--> 0x0804c19c). `var_4h`의 값이 된다.  
> R을 입력할 시 ->  `var_4h`에서 값을 가져와서 동일한 주소에 +8byte, `var_4h`에 다시 값을 넣는다.  
> `var_4h`에 저장된 주소에 +4byte하고, 해당 값을 `var_8h`에 저장된 값과 XOR 한 다음 결과를 다시 `var_8h`에 넣는다?
> 마지막에 `var_8h`랑 obj.solution이랑 일치하면 답이 될 것이다 ?
뭘까 . . 


---
### +) plus
---
* `jmp`와 `call`의 차이점
	* `jmp`는 특정 지역으로 이동, `call`은 인자 하나를 받아서, 해당 주소의 함수 또는 loop와 같은 문을 부른다. 
	* '부른다' : 주소까지 갈 필요가 없으며, 해당 위치에서 수행하며, 돌아올 주소인 ret을 스텍에 저장한다는 점이 jmp와 다르다.

* 어셈블리어 기초 참고 자료 
	* <http://index-of.co.uk/Assembly/vangelis.pdf>

	
---
### 2. Etc
---
이렇게 배울 수 있는 건 정말 감사한 일이다 
