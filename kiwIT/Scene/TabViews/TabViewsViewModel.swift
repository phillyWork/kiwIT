//
//  TabViewsViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

final class TabViewsViewModel: ObservableObject {
    
    
    //MARK: - 각 탭마다 활용하는 데이터 타입 정리해서 공통적으로 활용하는 데이터 여기서 관리하도록 잡아놓기
    
    //하위 Viewmodel에서 해당 데이터 업데이트 시, 이 Viewmodel로도 같이 전달하도록 작성하기
    
    init() {
        print("DEBUG - TabViewsViewModel initialized")
        
        //check user profile data first
        requestUserProfile()
        
        print("DEBUG - End of TabViewsViewModel initialization")
    }
    
    
    private func requestUserProfile() {
        
    }
    
    
    
}
