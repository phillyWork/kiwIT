//
//  GPTView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

//MARK: - Interview: 추가 필요
struct AIInterviewView: View {
    
    @StateObject var aiInterviewVM = AIInterviewViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    var body: some View {
        
        VStack {
            Text("AIInterviewView")
        }
        .frame(maxHeight: .infinity)
        .frame(width: Setup.Frame.devicePortraitWidth)
        .background(Color.backgroundColor)
    }
}

#Preview {
//    AIInterviewView(tabViewsVM: TabViewsViewModel(MainTabBarViewModel().userProfileData))
    AIInterviewView(tabViewsVM: TabViewsViewModel())
}
