//
//  TabViewsViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

//모든 Network 요청: access token 기반 --> KeyChain에서 불러와서 Network 요청하기

final class TabViewsViewModel: ObservableObject {
    
    @Published var isTokenAvailable = true
    @Published var profileData: ProfileResponse?
    @Published var didUpdateProfileFromOtherView = false
    
    private var cancellables = Set<AnyCancellable>()
        
    func checkProfile(with profile: ProfileResponse?) {
        if let profile = profile {
            self.profileData = profile
            print("Passed Profile Data: \(profileData)")
        } else {
            print("No Profile Data Passed!!!")
            requestUserProfile()
        }
    }
    
    private func requestUserProfile() {
        if let token = KeyChainManager.shared.read() {
            NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.access)), errorCase: .profileCheck)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        if let profileError = error as? NetworkError {
                            print("Error for Requesting Profile Data: \(profileError.description)")
                        } else {
                            print("Error for Other Reason: \(error.localizedDescription)")
                        }
                    }
                } receiveValue: { response in
                    print("Profile Response: \(response)")
                    self.profileData = response
                }
                .store(in: &self.cancellables)
        } else {
            //No Token Saved From KeyChain!!!
            print("No Token Saved in KeyChain in TabsViewModel!!!")
            isTokenAvailable = false
        }
    }
    
    func updateProfileFromProfileView(_ newProfile: ProfileResponse) {
        self.profileData = newProfile
        self.didUpdateProfileFromOtherView = true
    }
}
