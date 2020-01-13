# GBC Security_06

## HW #6

### Buffer Overflow
---
#### 1. bof2

> bat ./bof2로 해당 소스 코드를 살펴본다.  
> main에서 인자로 argv[1]의 값을 입력받아 vuln()함수의 파라미터로 전달하여 함수 vlun이 실행되고 있다. 
> `strcpy`로 vuln이 입력받은 파라미터를 `buf`에 복사해주고 있다.  
> 이 때, `strcpy`함수는 `buf`의 크기를 고려하지 않고, 그대로 복사해버린다. 따라서, 해당 크기보다 큰 값을 인자로 전달하면 넘쳐 다른 메모리를 침범하게 된다.  
> __[Conclusion]__ 인자에 buf보다 큰 값을 전달하면, innocent 변수 직전까지 값이 채워져 그 이후 입력한 값이 innocent 변수를 덮어쓸 수 있게 될 것이다.
 
![b1](https://user-images.githubusercontent.com/47182864/61272722-c0c38f80-a7e2-11e9-9cef-b50ffcef9f4d.png)


> strcpy까지 가서 buf의 주소를 확인한다.
> > buf의 시작주소를 얻기 위해 strcpy에 break point를 걸고 rax의 값을 얻는다.  
> > rax값은 strcpy를 call하기 위해 넣어주는 buffer의 주소값이다.

![b2](https://user-images.githubusercontent.com/47182864/61272723-c0c38f80-a7e2-11e9-894d-975a0965ba4b.png)
![b3](https://user-images.githubusercontent.com/47182864/61272724-c0c38f80-a7e2-11e9-907a-9010d791f190.png)

> ~~innocent와 KEY값을 비교하는 cmp명령어에서 innocent의 주소값을 확인한다.~~

![b4](https://user-images.githubusercontent.com/47182864/61272725-c15c2600-a7e2-11e9-81a3-627ea74ef151.png)
![b5](https://user-images.githubusercontent.com/47182864/61272728-c15c2600-a7e2-11e9-800e-cde51e0836b9.png)

> rsp와 rax의 차이값을 구해 buf의 크기를 안다.

![b11](https://user-images.githubusercontent.com/47182864/61275748-932e1480-a7e9-11e9-9410-7b60d46cd209.png)
![b12](https://user-images.githubusercontent.com/47182864/61275750-932e1480-a7e9-11e9-9e3f-17e728dac29d.png)

다음과 같은 코드를 입력하여 실행시킨다.

```shell
./bof2 `python -c "print 'a'*144"`
```

![r1](https://user-images.githubusercontent.com/47182864/61273316-25cbb500-a7e4-11e9-8fb7-20b8f646ba74.png)

#### 2. bof3

> bat ./bof3로 해당 소스 코드를 살펴본다.  
> `gets()`가 input data의 길이를 체크하지 않는 것을 볼 수 있다. 

![bof3](https://user-images.githubusercontent.com/47182864/61276869-dee1bd80-a7eb-11e9-834a-c5cc4f77fc01.png)

> `vuln`함수의 어셈블리 코드를 확인한다. 
> `gets`함수의 시작 주소를 얻는다. 

![bof3-1](https://user-images.githubusercontent.com/47182864/61276865-de492700-a7eb-11e9-93bd-72499957bb10.png)
![bof3-2](https://user-images.githubusercontent.com/47182864/61276866-dee1bd80-a7eb-11e9-9f16-8e6c23cc0ac4.png)
![bof3-3](https://user-images.githubusercontent.com/47182864/61276868-dee1bd80-a7eb-11e9-98c9-87652ff04436.png)

> KEY값이 0x61이기 때문에 144/4 = 36하여, 36개만큼 a를 넣어준다!

다음과 같은 코드를 입력하여 실행시킨다.

```shell
(python -c "print 'a\x00\x00\x00'*36";cat) | ./bof3
```

![r2](https://user-images.githubusercontent.com/47182864/61277689-a511b680-a7ed-11e9-9325-8eb6ecbdc346.png)


*  `;cat`,`|` 관계 : `|`를 통해 input stream을 표준 입력이 아닌 다른 출력으로 리다이렉트 시킬 경우, 다른 프로그램이 끝났을 때 입력 스트림이 종료되기 때문에 프로그램이 종료된다. 그렇기 때문에, `cat`을 이용해서 출력 프로그램이 종료되더라도 `cat`은 종료되지 않게 하여, Input stream이 종료되지 않게 해야한다.


#### 3. bof4

> bat ./bof4로 해당 소스 코드를 살펴본다.   
> > main에서 인자로 argv[1]의 값을 입력받아 vuln()함수의 파라미터로 전달하여 함수 vlun이 실행되고 있다. `strcpy`로 vuln이 입력받은 파라미터를 `buf`에 복사해주고 있다. 이 때, `strcpy`함수는 `buf`의 크기를 고려하지 않고, 그대로 복사해버린다. 따라서, 해당 크기보다 큰 값을 인자로 전달하면 넘쳐 다른 메모리를 침범하게 된다. 

> 위에와 같은 방식으로 ..

![bof4](https://user-images.githubusercontent.com/47182864/61278281-dd65c480-a7ee-11e9-8c48-2d12bd34d639.png)

![bof4-1](https://user-images.githubusercontent.com/47182864/61278278-dccd2e00-a7ee-11e9-9e17-59edb63e7274.png)

![bof4-2](https://user-images.githubusercontent.com/47182864/61278279-dccd2e00-a7ee-11e9-922c-2a0adcff5923.png)

![bof4-3](https://user-images.githubusercontent.com/47182864/61278280-dd65c480-a7ee-11e9-8a4f-ce65773f2e1a.png)

다음과 같은 코드를 입력하여 실행시킨다.

```shell
./bof4 `python -c "print '\x78\x56\x34\x12'*36"`
```

![r3](https://user-images.githubusercontent.com/47182864/61279523-3d5d6a80-a7f1-11e9-9eb9-5a16dd1e2c11.png)


---
### +) plus
---

* 버퍼(buffer) - 어떤 데이터가 한곳에서 다른곳으로 이동할 때, 그 데이터가 일시적으로 보관되는 임시기억공간.

* 오버플로우(overflow) - 사용자가 입력한 데이터의 크기가 너무 과하여 제한된 버퍼의 용량을 넘어서 버린것.

* 버퍼오버플로우 -  사용자가 입력한 데이터의 크기가 제한된 버퍼의 용량을 초과하는 것. 
	* 공격 대상 -  사용자로부터 어떠한 입력을 받는, 또 그 입력 값에 따라 프로그램의 실행결과가 달라지는 프로그램들이 버퍼 오버플로우의 공격대상이 됨
	* Buffer Overflow 공격에 취약한 함수 : strcpy, strcat, gets, fscanf, scanf, sprintf, sscanf와 같이 문자열의 길이를 검사하지 않는 함수들

* Stack 기반 overflow - stack에는 지역변수, 인자, 함수종료후 돌아갈 곳의 주소(ret값)이 저장 되어 있다. 이 RET값을 다른 주소값으로 변환하여 관리자 권한을 획득하거나 악성코드의 주소등으로 바꾸는 것 등이 있다.

* Heap 기반 overflow - heap에는 malloc, calloc 등의 함수를 이용하여 프로그래머가 직접 공간을 할당하게 되는데, 이곳에 저장된 데이터 및 함수를 변경하여 원하는 결과를 얻어낼 수 있다. 

* 빅 엔디언, 리틀 엔디언 
![little](https://user-images.githubusercontent.com/47182864/61281272-5582b900-a7f4-11e9-9eaf-cfc5df62cf67.png)
> 해당 수치를 data단위로 나눴을 때, 그 단위가 거꾸로 배열됨

![little2](https://user-images.githubusercontent.com/47182864/61281273-5582b900-a7f4-11e9-8d16-cdd5fe281c1a.png)


	
---
