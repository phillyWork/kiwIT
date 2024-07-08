//
//  UserLectureListView.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import SwiftUI

struct UserLectureListView: View {
    
    @StateObject var lectureListVM = UserLectureListViewModel()
    @ObservedObject var profileVM: ProfileViewModel
    
    var body: some View {
        
        //MARK: - 보관함 삭제: ProfileVM도 처리 필요
        
        //MARK: - 전체 학습 완료한 컨텐츠 목록 보여주기 (Scroll)
        //MARK: - 전체 보관함 담은 컨텐츠 목록 보여주기 (Scroll)
        //MARK: - 해당 컨텐츠 탭: Sheet로 Webview 띄워서 내용만 보여주기
        //MARK: - 2 섹션 구분, 가로 스크롤로 완료 및 보관 나타내기?
        //MARK: - 보관함 버튼 추가: 보관 Request, 성공 시, 앱단 목록에서 삭제하기
        
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        
        Grid {
            <#code#>
        }
        
    }
}

#Preview {
    UserLectureListView(profileVM: ProfileViewModel(updateProfileClosure: { response in
        print("Response: \(response)")
    }))
}
