# GBC Security_05

## HW #5

### 1. Bomb
---
#### 1. yellow
 
> radare2로 열어서 yellow함수의 어셈블리 코드를 본다!  
> ??? 신기하게도 그냥 나와있음 암호가 !!!  
> 각 연속 byte가 0x38, 0x34, 0x33, 0x37, 0x31, 0x30, 0x36, 0x35와 비교한다.
> 이는 각각 84371065와 대응된다.

![bomb](https://user-images.githubusercontent.com/47182864/61140829-3095f980-a507-11e9-8497-6f1f31d88b14.png)

> __[Result]__ `password` : 84371065

![bomb-1](https://user-images.githubusercontent.com/47182864/61141374-6b4c6180-a508-11e9-8bdf-6160e2b9761a.png)

#### 2. Green

> 그냥 열어봤는데 답 같은게 있었다!

![green](https://user-images.githubusercontent.com/47182864/61142406-a51e6780-a50a-11e9-9c7e-e1d342766624.png)

> 응 아니였구 ~~

![green-2](https://user-images.githubusercontent.com/47182864/61142649-3a216080-a50b-11e9-9dd7-eb15a33a597c.png)

#### 3. blue


#### 4. red



---
### 2. Etc
---
이렇게 배울 수 있는 건 정말 감사한 일입니당 