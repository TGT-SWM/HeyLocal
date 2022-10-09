# 현지야 - 내 손안의 여행 길잡이
## 프로젝트 설명
여행 스케줄 작성에 어려움을 겪는 사람들을 위한 여행 솔루션.  

### 여행 목적에 맞는 장소 공유
사용자가 본인이 원하는 여행에 대한 설명을 게시하고, 해당 설명을 기반으로 서비스 사용자들로부터 방문할 장소를 추천받을 수 있음.  
이렇게 추천받은 장소를 내 여행 스케줄표에 추가할 수 있음.  
또한, 직접 다른 사용자들에게 장소를 추천해줄 수 있음.

### 여행 스케줄 관리
사용자가 자신의 여행 스케줄을 쉽게 관리할 수 있는 여행 스케줄표 기능을 제공함.  
사용자가 방문할 장소들을 리스트 형식으로 관리함.  
현재 여행 중인 경우, 사용자의 현재 위치 정보를 기반으로 스케줄표를 실시간 업데이트하여 '장소 도착 예정 정보', '길찾기 정보' 등을 제공함.


## 디렉토리 구조
```
└── HeyLocal
    ├── Frameworks : 사용한 프레임워크
    │   └── DaumMap.embeddedframework
    ├── HeyLocal
    │   ├── Assets.xcassets : 이미지 외 여러 에셋 관리
    │   ├── Colors.xcassets : 색상 에셋
    │   ├── Configurations : 
    │   ├── Models : 구조체 타입
    │   ├── Networking : 네트워크 
    │   ├── Preview Content : 프리뷰 
    │   ├── Repositories : 레파지토리
    │   ├── Services : 서비스
    │   ├── UI : 화면
    │   │   ├── Components : 화면을 구성하는 컴포넌트 (재사용 가능)
    │   │   │   ├── ProfileComponent : 프로필 컴포넌트
    │   │   │   ├── RegionComponent : 지역 컴포넌트
    │   │   │   └── TravelOnList : 여행On 컴포넌트
    │   │   ├── Screens : 화면
    │   │   │   ├── AuthScreen : 로그인·회원가입 화면
    │   │   │   ├── HomeScreen : 홈 화면
    │   │   │   ├── MyPlanScreen : 내 플랜 화면
    │   │   │   ├── PlaceSearchScreen : 장소 검색 화면
    │   │   │   ├── PlanCreateScreen : 플랜 생성 화면
    │   │   │   ├── PlanDetailScreen : 플랜 상세 화면
    │   │   │   ├── ProfileScreen : 사용자 프로필 화면
    │   │   │   ├── RegionPickerScreen : 지역선택 화면
    │   │   │   └── TravelOnScreen : 여행On 화면
    │   │   └── Styles : 버튼·토글 스타일 (재사용 가능)
    │   └── Utils : 유틸리티
    └── HeyLocal.xcodeproj : 프로젝트 설정 파일
``` 


## 환경
### 기술 스택
<span><img src="https://img.shields.io/badge/swift-F05138?style=for-the-badge&logo=swift&logoColor=white"></span>
<span><img src="https://img.shields.io/badge/swiftui-0D48A1?style=for-the-badge&logo=swift&logoColor=white"></span>
<span><img src="https://img.shields.io/badge/combine-F05138?style=for-the-badge&logo=swift&logoColor=white"></span>

### 개발 환경
- 개발 운영체제 : macOS Monterey 12.6
- Xcode 13.4.1
- Swift 5.6.1

### 구동 환경
- iPhone
- iOS 15.0 이상


## 프로젝트 결과물
### 기능
* 여행On 목록 조회

<img width="228" alt="image" src="https://i.imgur.com/CJcN31F.png"> |<img width="228" alt="image" src="https://i.imgur.com/p9JLmAO.png">
--- | --- |


* 여행On 상세조회

<img width="228" alt="image" src="https://i.imgur.com/dxWh1aZ.png"> |<img width="228" alt="image" src="https://i.imgur.com/5J08GvL.png">
--- | --- |

* 여행On 등록·수정

<img width="228" alt="image" src="https://i.imgur.com/SWR1BOY.png"> |<img width="228" alt="image" src="https://i.imgur.com/UlPsypd.png">
--- | --- |

* 여행On 삭제

<img width="228" alt="image" src="https://i.imgur.com/DU6VOzh.png"> |
--- |

* 마이플랜 조회

<img width="228" alt="image" src="https://i.imgur.com/ynhryMr.png"> |
--- |


* 플랜 등록·삭제

<img width="228" alt="image" src="https://i.imgur.com/TZtCJQj.png"> |<img width="228" alt="image" src="https://i.imgur.com/PaO1aBE.png">
--- | --- |

* 플랜 조회

<img width="228" alt="image" src="https://i.imgur.com/0alPXbA.png"> |<img width="228" alt="image" src="https://i.imgur.com/smJSlhi.png">
--- | --- |

* 스케줄 수정

<img width="228" alt="image" src="https://i.imgur.com/US8t1es.png"> |<img width="228" alt="image" src="https://i.imgur.com/dhaNJwr.png">
--- | --- |

* 장소 검색

<img width="228" alt="image" src="https://i.imgur.com/kgol3Ua.png"> |
--- |


### 화면

|진행 상황|이름|설명|
|---|---|---|
|✅|인트로 화면|앱 시작 시 나타나는 화면|
|✅|로그인 화면|로그인 기능 제공 (아이디•비밀번호 로그인과 소셜 로그인 제공)|
|✅|회원가입 화면|회원가입 기능 제공|
||메인 화면|인기 장소, 최근 여행 On, 사용자 랭킹 정보 제공|
||알림 리스트 화면|받은 푸시 알림 리스트|
||랭킹 화면|사용자 상위 30인 랭킹|
|✅|여행 On 화면|전체 여행 On 조회, 검색 기능 제공|
|✅|여행 On 작성 화면|여행 On 작성 기능 제공|
|✅|여행 On 조회 화면|여행 On을 조회|
||답변 작성 화면|여행 On에 대한 답변 작성 기능 제공|
||답변 상세보기 화면|답변 상세 정보를 조회|
||플랜 선택 화면|답변에서 추천한 장소를 내 플랜에 추가하기 위해 플랜을 선택|
|✅|마이플랜 목록 화면|내가 작성한 플랜의 리스트를 조회|
|✅|여행 On 선택 화면|새 플랜을 생성하기 위해 여행 On을 선택|
|✅|플랜 상세 화면|플랜을 스케줄 리스트 또는 지도 형태로 조회, 스케줄 수정 기능 제공, 장소 간 거리와 이동 시간 정보 제공|
|✅|장소 검색 화면|플랜에 장소를 추가하기 위해 키워드로 장소 검색 (카카오 API)|
||장소 상세 정보 화면|장소에 대한 상세 정보 조회|
||메시지 리스트 화면|개설되어 있는 채팅방 리스트 조회|
||채팅방 화면|1:1 채팅 기능 제공|
||내 정보 화면|내 프로필 정보, 작성한 여행 On과 답변 리스트 조회|
||프로필 수정 화면|이름, 프로필 사진, 자기소개, 활동지 정보 수정|
||설정 화면|앱 및 서비스 설정|
||프로필 화면|다른 사용자의 프로필 정보, 작성한 여행 On과 답변 리스트 조회|


## 팀
### 기여

|이름|구현|
|---|-------|
|최정인|- 화면 요구사항 설계 <br/> - 비동기 네트워킹을 통한 서버 API 연동 <br/> - 여행 On 탭 화면·기능 구현|
|신우진|- 화면 요구사항 설계 <br/> - 마이플랜 탭 화면·기능 구현 <br/> - 외부 서비스 API 연동|

### 팀원
|   |이름|역할|GitHub|Blog|
|---|---|---|-----|-----|
|<img src="https://avatars.githubusercontent.com/u/76861101?v=4" alt="drawing" width="100"/>|우태균|TL/Server|[GitHub 프로필](https://github.com/TaegyunWoo)|[개발 블로그](https://taegyunwoo.github.io/)|
|<img src="https://avatars.githubusercontent.com/u/76616101?v=4" alt="drawing" width="100"/>|신우진|Server/Client|[GitHub 프로필](https://github.com/gintooooonic)|[개발 블로그](https://woodyshin.com/)|
|<img src="https://avatars.githubusercontent.com/u/37467592?v=4" alt="drawing" width="100"/>|최정인|Client|[GitHub 프로필](https://github.com/choijungp)|[개발 블로그](https://velog.io/@choijungp)|

<br/><br/><br/>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
