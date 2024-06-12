//
//  SignUpInfoViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/9/24.
//

import Foundation

import Combine

final class SignUpInfoViewModel: ObservableObject {
    
    var userDataForSignUp: SignUpRequest
    
    @Published var isToggleSwitchOn = false
    @Published var isNicknameEmpty = false
    @Published var showSignUpRequestIsNotSetAlert = false
    
    init(userDataForSignUp: SignUpRequest) {
        print("DEBUG - initialize SignUpInfo ViewModel")
        self.userDataForSignUp = userDataForSignUp
    }
        
    func updateNicknameEmptiness() {
       isNicknameEmpty = userDataForSignUp.nickname.isEmpty
    }
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    func requestSignUp() {
        print("data so far to request signup: \(userDataForSignUp)")
        
        
        
//        NetworkManager.shared.request(type: SignUpResponse.self, api: .signUp(request: userDataForSignUp), errorCase: .signUp)
//            .sink { completion in
//                
//            } receiveValue: { response in
//                
//            }

        
    }
    
   
    
}
