# kiwIT

<img src = "https://github.com/user-attachments/assets/3dd04065-5a02-4707-8534-9886fad1d4cf" width="30%" height="30%">

#### 모두에게 필요한 기초 IT 지식부터 전공자를 위한 CS까지, IT 학습 서비스 앱입니다.

# 개발 기간 및 인원
- 2024.04. ~ 2023.08.
- 최소 버전: iOS 17.4
- 2인 개발
  - 담당 업무: iOS 개발, 디자인 컨셉
  - 공통 업무: 컨텐츠 기획 및 API 구조 설계

# 사용 기술
- **SwiftUI, Combine, WebKit, AuthenticationServices**
- **Alamofire, KakaoSDK**
- **MVVM, Router, Singleton**
- **GCD, Keychain, UserDefaults, Codable, Hashable**

------

# 기능 구현

- `JWT` 토큰 활용 로그인 및 인증 구현
  - Access Token 만료시 Refresh 토큰을 활용한 Token 갱신
  - `Keychain` 활용, 유저의 Access & Refresh token 저장
- `Combine` 활용, 학습 컨텐츠 CRUD
  - Input/Output 패턴을 활용, 단방향 데이터 흐름을 통한 상태 관리
  - 컨텐츠 학습 완료, 퀴즈 문제 풀이, 북마크 기능, 닉네임 수정 및 로그아웃, 회원탈퇴 구현

------

# Trouble Shooting

### A. Input/Output 패턴으로 `@Published` variable의 update 분리

RxSwift와 달리 SwiftUI와 Combine의 조합에서는 다음과 같이 간단하게 구독 관리를 구현할 수 있다.

1. `ObservableObject`를 채택하는 클래스 내에서 `@Published` 속성 wrapper를 활용
2. `@Published` 속성은 변경 사항을 해당 속성을 구독한 모든 View에 알림
3. View는 `@StateObject` 혹은 `@ObservedObject`를 활용해 이 `ObservableObject` 클래스를 등록

이렇게 하면 View 내부의 UI 구성요소는 `@Published` 속성 값의 변화에 따라 UI를 업데이트할 수 있다.
초반 코드를 작성할 당시엔 data는 ViewModel 클래스에 있지만 View에서 user interaction이나 새로운 값 입력 등의 변화가 있을 경우 해당 입력을 ViewModel의 속성값을 업데이트 하도록 전달하는 식으로 구성을 했다.

```swift
// MARK: 퀴즈 시작 에러 Alert 나타내기

final class QuizViewModel: ObservableObject {

  @Published var showStartQuizErrorAlert = false

  // VM methods
}

struct QuizView: View {
  @StateObject var quizVM = QuizViewModel()

  var body: some View {
    ScrollView {
      // UI contents
    }
    .alert("Start Quiz Error!", isPresented: $quizVM.showStartQuizErrorAlert) {
      Button {
        // Alert Action
      }
    }
  }
}
```

View에서 ViewModel의 데이터 값을 직접 업데이트하는 경우도 존재해서 구조가 고도화되어 갈 수록 **데이터 흐름을 판단하기 어려울 상황**이 나타나는 경우가 빈번하게 나타났다는 문제점이 두각되었다.

이를 해결하기 위해 Combine 자체적으로 Input/Ouput을 직접 구현할 필요는 없지만 `View --> ViewModel` 단방향 데이터 업데이트가 이뤄지도록 Input/Ouput 패턴만 구현해보았다.
이를 위해 초기화를 위한 값이 따로 필요없는 `PassthroughSubject`를 활용했다. 

위에 언급한 순서를 Input/Output 패턴으로 수정하면 다음과 같다.
1. `ObservedObject`를 채택하는 클래스 내에서 `PassthroughSubject` 변수 초기화
2. 해당 클래스의 init 시에 PassthroughSubject에게 새로운 값이 전달될 경우, 처리할 작업을 정의 (RxSwift의 bind와 유사)
3. 실제 View에서 데이터 값 업데이트 필요시, PassthroughSubject에게 전달
4. PassthroughSubject는 전달받은 값을 가지고 init때 정의된 작업 수행
5. 작업 수행 후, `@Published` 속성 값 업데이트, 구독한 View는 해당 변화를 감지하고 UI 업데이트

간단한 그림으로 나타내면 다음과 같다.



프로젝트 수정 중 3번에서 PassthroughSubject에게 값 전달도 함수로 처리해서 실제 데이터 처리는 모두 ViewModel에서, View는 변화를 ViewModel에 함수 호출로 전달하는 식으로 한번 더 감쌌다.
이렇게 하니 실제 업데이트 요청 작업과 해당 함수가 어디서 불리고 어떻게 흘러가는지 스트림을 이해하는 데 도움이 되었다.

```swift
// MARK: 퀴즈 북마크 처리 및 에러 Alert 나타내기

final class QuizViewModel: ObservableObject {

  @Published var showBookmarkQuizErrorAlert = false

  private let requestBookmarkSubject = PassthroughSubject<Void, Never>()

  init() {
      bind()
  }

  private func bind() {
        requestBookmarkSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestBookmarkQuiz()
            }
            .store(in: &cancellables)
  }

  private func requestBookmarkQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else { return }
        NetworkManager.shared.request(type: BookmarkQuizResponse.self, api: .bookmarkQuiz(request: BookmarkQuizRequest(quizId: quizIdToBookmark, access: tokenData.0.access)), errorCase: .bookmarkQuiz)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let bookmarkQuizError = error as? NetworkError {
                        switch bookmarkQuizError {
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .bookmark)
                        default:
                            self?.showBookmarkQuizErrorAlert = true
                        }
                    } else {
                        self?.showBookmarkQuizErrorAlert = true
                    }
                }
            } receiveValue: { response in
                if let quizData = self.quizData {
                    self.quizData?.quizList[self.quizIndex].kept = !(quizData.quizList[self.quizIndex].kept)
                } else {
                    self.showBookmarkQuizErrorAlert = true
                }
            }
            .store(in: &self.cancellables)
  }

  func updateBookmarkedStatus(_ id: Int) {
      quizIdToBookmark = id
      debouncedBookmarkThisQuiz()
  }
    
  private func debouncedBookmarkThisQuiz() {
      requestBookmarkSubject.send(())
  }
  
}

struct QuizView: View {
  @StateObject var quizVM = QuizViewModel()

  var body: some View {
    ScrollView {
      QuizMultipleChoice(quiz: quizVM.data) { result in
        switch result {
          // handle user quiz answer
        }
      } bookmarkAction: { id in
        quizVM.updateBookmarkedStatus(id)
      }
    }
    .alert("Bookmark Quiz Error!", isPresented: $quizVM.showBookmarkQuizErrorAlert) {
      Button {
        // Alert Action
      }
    }
  }
}
```

+ 추가사항: debounce를 위한 schedueler를 보통 `MainQueue` 혹은 `RunLoop`를 활용하는데, 버튼을 비롯한 대부분 User Interaction 처리에는 RunLoop를 scheduler로 등록해야했다.
실제 유저가 버튼을 제대로 누른건지, 오래 누르다가 swipe해서 버튼 누름 취소를 하는 액션도 있을 수 있어서 RunLoop를 활용했다. 그 이외에는 DispatchQueue.main을 scheduler로 활용했다.

-----

### B. 공통적인 Refresh Token 처리: Protocol화



------

### C. Child View에서 Access Token 만료 시에 전체 로그아웃 및 SignIn 처리

(B에서 이어지는 내용)



------

# 회고


