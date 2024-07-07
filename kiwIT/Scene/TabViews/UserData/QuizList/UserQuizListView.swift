//
//  UserQuizListView.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import SwiftUI

struct UserQuizListView: View {
    
    @StateObject var quizListVM = UserQuizListViewModel()
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        
        //MARK: - 보관함 삭제: ProfileVM도 처리 필요
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    UserQuizListView(profileVM: ProfileViewModel(updateProfileClosure: { response in
        print("Response: \(response)")
    }))
}
