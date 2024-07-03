//
//  HomeViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation

import Combine

final class HomeViewModel: ObservableObject {
    
    
    
    func checkProfile(with profile: ProfileResponse?) {
        if let profile = profile {
            
        } else {
            print("No Profile Passed From!!!")
            requestProfile()
        }
    }
    
    func requestProfile() {
        //MARK: - 결과물 tabViewsViewModel에도 업데이트 필요
    }
}
