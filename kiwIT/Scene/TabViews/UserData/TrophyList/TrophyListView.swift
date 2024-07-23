//
//  TrophyView.swift
//  kiwIT
//
//  Created by Heedon on 6/4/24.
//

import SwiftUI

struct TrophyListView: View {
    
    //MARK: - 더보기: 화면 이동, 전체 트로피 리스트 및 획득한 영역 구분해서 나타내기
    
    @StateObject var trophyListVM = TrophyListViewModel()
    @ObservedObject var profileVM: ProfileViewModel
        
    var body: some View {
        ScrollView {
            LazyVStack {
//                ForEach(tempTrophyData) { trophy in
                    
//                    for acquired in tempUserAcquiredTrophyData {
//                        if acquired.trophy.id == trophy.id {
//                            TrophyContent(tempTrophyTitle: trophy.title, tempTrophyExplanation: "누적 학습시간 ", tempImageUrlString: trophy.imageUrl, achievedDate: acquired.updatedAt)
//                        } else {
//                            TrophyContent(tempTrophyTitle: trophy.title, tempTrophyExplanation: "누적 학습시간 100시간 돌파", tempImageUrlString: trophy.imageUrl)
//                        }
//                    }
                    
//                    TrophyContent(tempTrophyTitle: trophy.title, tempTrophyExplanation: "누적 학습시간 100시간 돌파", tempImageUrlString: trophy.imageUrl)
                    
//                }
            }
        }
        .background(Color.backgroundColor)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TrophyListView(profileVM: ProfileViewModel(updateProfileClosure: { response in
        print("Response: \(response)")
    }))
}
