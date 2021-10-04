# ThingLog 
## Requirements

- Swift 5
- iOS 13+
- Xcode 12

## Library 
- `RxSwift`
- `SwiftGen` 
- `SwiftLint` 
- `Fastlane` 
> Library Manage 
- `Carthage`  


## ⚠️ GitHub 플로우
1. 메인 리포에 `Issue` 등록 
    - 적절한 label 등록 및 설명 추가 
2. `folk` 하여 로컬브랜치에 `Issue번호`와 `Issue 주제`로 브렌치 생성
```
<IssueLabel>/<Issue번호>-<Issue주제>
```
- 예시
```
view/47-homeview
```
3. 구현 후 folk 리포에 `pull` 
4. 메인 리포에 `Pull Request` 작성 
5. 리뷰 기다림

## ⚠️ Merge 
- 풀리퀘 올리기전에 `upstream/develop` 머지 하기 보다는, 리뷰 받고서 `approve` 받은 상태 다음에 `upstream/develop` 머지 후 develop 브렌치와 머지한다. 
    - 작업하는 브렌치가 꽤 오래 걸리는 작업이면서 중간 중간에 다른 작업이 계속 머지되는 경우, 이를 작업하는 브렌치에 즉각적으로 반영하지 않는다.
    - 만약 즉각적으로 최신 develop 브렌치를 반영하면서 풀리퀘를 생성한다면, 커밋내역이 시간순서대로 계속 남아있게 되고, 이는 나중에 커밋내역이 작업하는 브랜치와 따로 커밋내역이 생성되므로 매우 곤란해진다.


## ⚠️Commit Convention
- 기본 구조 
```
[#Issue-Number] <Type>: <Message>
```
- 간단한 커밋 
```
[#1] feat: 기능 추가
```
- 부가적인 설명이 필요한 커밋 
```
[#1] feat: 기능 추가
- 작업1
- 작업 2
```

- `feat`: 기능
- `fix`: 버그 수정
- `env`: 환경 변수 또는 프로젝트 환경
- `ref`: 리팩토링
- `style`: 스타일(코드 형식, 세미콜론 추가: 비즈니스 로직에 변경 없음)
- `docs`: 문서 (문서 추가, 수정, 삭제)
- `test`: 테스트(테스트 코드 추가, 수정, 삭제: 비즈니스 로직에 변경 없음)
- `chore`: 기타 변경사항 (빌드 스크립트 수정 등)
