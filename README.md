# kiwIT

<img src = "https://github.com/user-attachments/assets/3dd04065-5a02-4707-8534-9886fad1d4cf" width="30%" height="30%">

#### 모두에게 필요한 기초 IT 지식부터 전공자를 위한 CS까지, IT 학습 서비스 앱입니다.

# 개발 기간 및 인원
- 2024.04. ~ 2024.08.
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

- `JWT` 토큰 활용 인증 구현
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

<img src = "https://github.com/user-attachments/assets/1d193ce3-736d-4332-86a4-d72bfef7a2f4" width="50%" height="50%">

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

JWT 토큰을 활용해서 모든 네트워크 요청을 시도하기에 모든 ViewModel에서는 Invalid Access Token인 경우, Refresh Token을 활용해서 Access Token을 업데이트 하는 기능이 필요했다.
문제는 각 ViewModel에서 사용할 네트워크 요청 종류가 다르기에 새로운 Valid Access Token을 발급받았을 경우에 처리할 일을 공통적으로 작성할 수 없다는 점이었다.

따라서 Update Access Token 기능 자체는 동일하게 모든 ViewModel에서 처리해야 하지만 개별 ViewModel에서 그 이후 처리할 일에 대한 정의는 각 ViewModel에서 처리하도록 구분을 지어야 했다.

이를 위해 먼저 Update Access Token 기능은 Protocol의 Default 함수로 정의했다. 해당 Protocol을 채택하는 모든 클래스는 따로 정의하지 않는 한 `requestRefreshToken` 함수가 extension에 정의된 형태로 수행된다.

```swift
// MARK: 공통 작업 타입 정의

protocol RefreshTokenHandler: AnyObject {
    associatedtype ActionType
    var cancellables: Set<AnyCancellable> { get set }
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: ActionType)
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String)
}

extension RefreshTokenHandler {
    //default refresh token method
    func requestRefreshToken(_ token: UserTokenValue, userId: String, action: ActionType) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            self?.handleRefreshTokenError(isRefreshInvalid: true, userId: userId)
                        default:
                            self?.handleRefreshTokenError(isRefreshInvalid: false, userId: userId)
                        }
                    } else {
                        self?.handleRefreshTokenError(isRefreshInvalid: false, userId: userId)
                    }
                }
            } receiveValue: { [weak self] response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self?.handleRefreshTokenSuccess(response: UserTokenValue(access: response.accessToken, refresh: response.refreshToken), userId: userId, action: action)
            }
            .store(in: &self.cancellables)
    }
}
```

`requestRefreshToken` 함수가 성공해서 새로운 토큰 정보를 받을 경우 실행할 `handleRefreshTokenSuccess` 함수에서 각 ViewModel에서 활용할 네트워크 요청들을 enum으로 묶은 개별 ActionType을 `associatedType`으로 정의한다.
Protocol에서 이 ActionType을 Generic하게 정의만 했으므로 각 ViewModel은 이 Protocol을 채택할 때마다 각자의 실제 ActionType을 활용할 수 있다.

```swift
// MARK: 예시: 전체 Trophy 리스트 및 유저가 획득한 Trophy 목록을 불러오는 TrophyListViewModel 

enum TrophyActionType {
    case wholeTrophyList
    case acquiredTrophyList
}

final class TrophyListViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = TrophyActionType

    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: TrophyActionType) {
        switch action {
        case .wholeTrophyList:
            requestWholeTrophyList()
        case .acquiredTrophyList:
            requestAcquiredTrophyList()
        }
    }
}
```

------

### C. Child View에서 Refresh Token 만료 시에 전체 로그아웃 및 SignIn 처리

B에서 언급했지만 로그아웃 요청조차 Access Token을 활용하기에 Refresh Token 만료 시에는 당연히 로그아웃 요청이 실패하게 된다. 
로그인 세션 만료 Alert를 띄우고, 확인을 누를 시 Keychain에 저장한 토큰 정보를 삭제 후 LoginView가 나타나도록 구조를 구성했다.

문제는 NavigationStack 구성으로 Child View의 깊이가 깊어질 경우, Parent View로 어떻게 전달할 것인지였다.
처음에는 각 View가 `@StateObject`로 담고있는 ViewModel을 Child View에는 `@ObservedObject`로 전달하는 방식을 고려했다. 이렇게 하면 각 ViewModel이 로그인 여부를 Bool값을 지니고, 어느 ViewModel에서 Invalid Refresh Token 상황인 경우, Parent level로 전달하도록 했다.

역할 분리 측면에서 의미는 있었지만 Child View의 ViewModel에서 Parent View의 ViewModel로 전달할 때 과정이 복잡해졌다.

1. Child ViewModel에서 Invalid Refresh Token 상황 직면
2. Child View에서 invalidRefreshToken여부 판단하는 `@Published` Bool type 값의 변화 확인
3. Parent ViewModel에게 전달
4. Parent ViewModel은 전달받아서 invalidRefreshToken여부 판단하는 `@Published` Bool type 값 업데이트
5. 헤당 값을 구독중인 Parent View는 업데이트에 따라 필요 작업 진행

이를 해결하기 위해서 먼저 View 구조를 다음과 같이 구성했다.

1. 앱의 메인이 되는 MainTabBarView 구성
2. ViewModel에서 로그인 여부를 체크해서 로그인이 필요한 경우에 LoginView, 성공했거나 아직 Refresh Token이 만료되지 않은 경우 TabViewsView를 띄우도록 처리
3. TabViewsView는 TabItem이 되는 각 View들을 갖고 있음
4. 각 TabItem은 `@ObservedObject`로 TabViewsViewModel을 전달받으면서 NavigationLink로 Child View를 갖게 될 경우, TabViewsViewModel의 `@Published var isLoginAvailable` 값을 `@Binding`으로 전달받음

간단하게 그림으로 나타내면 다음과 같다.

<img src = "https://github.com/user-attachments/assets/8f47ed4d-511b-4179-9643-fd122c566ccd" width="50%" height="50%">

NavigationStack에 속하는 Child View에서 Invalid Refresh Token 상황일 때 `@Binding`으로 엮인 TabViewsViewModel에게 값을 업데이트하도록 전달한다.

한편 다시 로그인해서 토큰 정보가 갱신되면 TabViewsView가 메모리에 올라오면서 내부 각 TabItem View들과 그 ViewModel들의 init 시 필요한 네트워크 요청을 한번에 보내는 것을 확인할 수 있었다.
이를 위해 LazyView 구조체를 정의해서 실제 화면에 나타나기 전까지 생성되지 않도록 유도한다. (UIKit에서 lazy와 유사한 역할을 하도록 한다)

```swift
// MARK: 로그인 성공 및 Refresh Token 만료되지 않은 경우의 Base 역할

struct LazyView<Content: View>: View {
    //get real view as function
    let build: () -> Content
    
    //init: not calling build function, save in property
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    //when actually shows on screen: calls build function, which initializes view
    var body: Content {
        build()
    }
}

struct TabViews: View {
    
    @StateObject var tabViewsVM = TabViewsViewModel()
    @ObservedObject var mainTabBarVM: MainTabBarViewModel
    
    var body: some View {
        TabView(selection: $tabViewsVM.selectedTab) {
            LazyView(HomeView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("홈", systemImage: Setup.ImageStrings.defaultHome)
                }
                .tag(TabType.home)
            LazyView(LectureListView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
                }
                .tag(TabType.lecture)
            LazyView(QuizListView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("퀴즈", systemImage: Setup.ImageStrings.defaultQuiz)
                }
                .tag(TabType.quiz)
            LazyView(ProfileView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("나", systemImage: Setup.ImageStrings.defaultProfile)
                }
                .tag(TabType.profile)
        }
        .onReceive(tabViewsVM.$isLoginAvailable) { isAvailable in
            mainTabBarVM.checkLoginStatus.send(isAvailable)
        }
    }
}
```

------

# 회고

- API 수정 및 팀원 일정 등으로 원래 추가하려던 인터뷰 기능이 빠져서 조금은 아쉬웠다.
  - 기획할 당시에는 GPT API를 붙여서 학습 컨텐츠 내역을 전달하면 인터뷰 문항을 구성하도록 flow를 구성하려 했다.
  - 구독 유저 여부로 인터뷰 기능 해금을 구현해보려 했으나 유료 앱기능 활성화(개인 사업자 혹은 법인 내용 증명)가 필요해 단념할 수 밖에 없어서 아쉬웠다.
  - WWDC24에서 등장한 Apple Intelligence와 Siri가 어디 수준까지 API로 지원해줄 지 모르겠지만 만약 인터뷰를 산출해줄 수 있다면 유저가 로컬에서라도 인터뷰 기능을 활용하는 것은 향후 구현해볼 수 있을 것 같다.
- TDD를 도입하려 했고 UserDefaults나 KeyChain 부문은 실제 테스트 작동까지 확인할 수 있었다. 다만 네트워크 부분은 XCTest를 구성할 때마다 Access Token를 위해 실제 로그인 처리를 매번 해야하고, 테스트 진행 순서에 따라 토큰 여부 체크를 위한 스트림 판단이 어려워서 포기를 했다.
  - 향후 Access Token용 코드를 모듈화로 따로 Manager로 분리해서 XCTest를 구성할 때는 해당 모듈만 가져오도록 구성을 해보면 조금 더 편리하게 XCTest를 해볼 수 있지 않을까 하는 예상을 한다.
