//
//  SignUpInfoViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/9/24.
//

import Foundation

import Combine

final class SignUpInfoViewModel: ObservableObject {
        
    //Input
    let toggleSwitchTab = PassthroughSubject<Void, Never>()
    let nicknameSubmitTab = PassthroughSubject<Void, Never>()
    let signUpRequestButtonTab = PassthroughSubject<Void, Never>()

    //Output
    @Published var isToggleSwitchOn = false
    @Published var showSignUpRequestIsNotSetAlert = false
    @Published var didSignUpSucceed = false
    @Published var showSignUpErrorAlert = false
    
    @Published var isNicknameEmpty: Bool
    
    private var cancellables = Set<AnyCancellable>()

    var userDataForSignUp: SignUpRequest
    var signedUpProfile: ProfileResponse?
    
    init(userDataForSignUp: SignUpRequest) {
        print("DEBUG - initialize SignUpInfo ViewModel")
        self.userDataForSignUp = userDataForSignUp
        self.isNicknameEmpty = userDataForSignUp.nickname.isEmpty ? true : false
        bind()
    }
    
    private func bind() {
        toggleSwitchTab
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.isToggleSwitchOn.toggle()
            }
            .store(in: &self.cancellables)
            
        nicknameSubmitTab
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.updateNicknameEmptiness()
            }
            .store(in: &self.cancellables)
        
        signUpRequestButtonTab
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.handleSignUpRequest()
            }
            .store(in: &self.cancellables)
    }
        
    private func updateNicknameEmptiness() {
       isNicknameEmpty = userDataForSignUp.nickname.isEmpty
    }
    
    private func handleSignUpRequest() {
        if isToggleSwitchOn && !isNicknameEmpty {
            requestSignUp()
        } else {
            showSignUpRequestIsNotSetAlert = true
        }
    }
    
    private func requestSignUp() {
        NetworkManager.shared.request(type: SignUpResponse.self, api: .signUp(request: userDataForSignUp), errorCase: .signUp)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showSignUpErrorAlert = true
                }
            } receiveValue: { [weak self] response in
                self?.requestProfile(response)
            }
            .store(in: &self.cancellables)
    }
    
    private func requestProfile(_ userToken: SignUpResponse) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: userToken.accessToken)), errorCase: .profileCheck)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.didSignUpSucceed = true
                }
            } receiveValue: { [weak self] response in
                self?.updateToken(token: userToken, profile: response)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateToken(token: SignUpResponse, profile: ProfileResponse) {
        //새로 가입 성공: 기존 저장된 Keychain 삭제, 그 후 새롭게 UserDefaults와 Keychain create
        KeyChainManager.shared.deleteAll()
        
        UserDefaultsManager.shared.saveToUserDefaults(newValue: String(profile.id), forKey: Setup.UserDefaultsKeyStrings.userIdString)
        
        KeyChainManager.shared.create(UserTokenValue(access: token.accessToken, refresh: token.refreshToken), id: String(profile.id))
        
        signedUpProfile = profile
        didSignUpSucceed = true
    }
    
    deinit {
        print("SignUpInfoViewModel DEINIT")
    }
    
}
