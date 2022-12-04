# Unlock - 마음을 열어보다
> 개발 기간: 2022.10.24 ~ 진행중

[![N|AppStore](https://camo.githubusercontent.com/256c4c0f137426227c87b21c9d7230e30362eba3d7bdd69cd212c343bb9a132c/68747470733a2f2f646576696d616765732d63646e2e6170706c652e636f6d2f6170702d73746f72652f6d61726b6574696e672f67756964656c696e65732f696d616765732f62616467652d646f776e6c6f61642d6f6e2d7468652d6170702d73746f72652e737667)](https://apps.apple.com/us/app/unlock-%EB%A7%88%EC%9D%8C%EC%9D%84-%EC%97%B4%EC%96%B4%EB%B3%B4%EB%8B%A4/id1612819350)

## About
![N|Description](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/c6c64f6c-fa5a-4c4f-91fa-875bf8aa250f/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221204%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221204T023940Z&X-Amz-Expires=86400&X-Amz-Signature=251a1d0809b57f61b1d48c3cda061efaee170ae805c7e5e8847aaf0937bb1c18&X-Amz-SignedHeaders=host&response-content-disposition=filename%3D%22Untitled.png%22&x-id=GetObject)

Unlock은 지인과 함께 사용할 수 있는 프라이빗, 익명 커뮤니티입니다.
Unlock은 ️기존 소셜미디어와 달리 댓글을 달기 전까지 게시물 작성자를 알 수 없습니다.

Unlock만이 제공하는 특별한 경험🌟
1️⃣ 눈치 보지말고 내가 경험한 세상을 공유해요
2️⃣ 편견없이 댓글을 남기는 이들에게만 나를 공개해요
3️⃣ 뜻밖의 사람을 발견하고 새로운 인연을 만들어요

## Dev Skills
Unlock은 다음과 같은 기술로 만들어진 서비스입니다:
- SwiftUI & Combine
- MVVM Pattern
- Github Actions (`develop` 브랜치 - Build & Test, `release` 브랜치 - TestFlight 업로드)
- CocoaPods

## Library
Unlock은 다음과 같은 라이브러리를 사용합니다:
- [Introspect](https://github.com/siteline/SwiftUI-Introspect) - UIKit 컴포넌트를 SwiftUI에서 간편하게 이용하기 위해 사용
- [Moya](https://github.com/Moya/Moya) - 편리한 API 통신을 위해 사용
- [Kingfisher](https://github.com/onevcat/Kingfisher) - 편리한 이미지 다운로드 & 관리를 위해 사용
- [FirebaseMessaging](https://firebase.google.com/docs/cloud-messaging/ios/client) - 푸시 알림 기능을 위해 사용

## Limitations & To-do
Unlock iOS앱은 빠른 출시를 위해 여러가지 개발적 한계점을 가지고 만들어진 프로젝트입니다.

점차 아래의 부분들을 개선해나갈 예정입니다:
- 현재는 viewModel이 서로 다른 viewModel을 물어 (참조하여) 여러 화면에 있는 글(Post) 상태를 업데이트 해주고 있습니다. 이는 좋지 않은 패턴으로 보이며, PostManager와 같은 중간 관리형 객체를 만들어 글 상태를 관리하는 방향으로 개선해나갈 예정입니다.
- 현재는 몇 몇 View에서 데이터를 직접 생산하고 있습니다. MVVM 패턴에서 View는 온전히 화면을 그리는 역할(UI)만 수행해야합니다. View에 사용될 데이터를 모두 ViewModel이 공급해주는 방향으로 개선해나갈 예정입니다.
- 현재는 AppState를 통해 전역으로 에러 팝업, 확인 팝업 등을 띄우고 있는 형태입니다. 각각의 View가 직접 팝업을 띄워줄 수 있게 SwiftUI의 기본 .alert()를 커스터마이징 하는 방향으로 개선해나갈 예정입니다.
