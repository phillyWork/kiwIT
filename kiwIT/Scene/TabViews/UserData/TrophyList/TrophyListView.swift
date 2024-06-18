//
//  TrophyView.swift
//  kiwIT
//
//  Created by Heedon on 6/4/24.
//

import SwiftUI

struct TrophyListView: View {
    
    //viewModel, trophyData
    @StateObject var trophyListVM = TrophyListViewModel()
    
    
    //from user data (acquired trophy data)
    let tempUserAcquiredTrophyData = [
        AcquiredTrophy(id: "aaa123", trophy: TrophyEntity(id: "111111111", title: "지금까지의 노력, 최고에요!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"), createdAt: "2024-02-11", updatedAt: "2024-05-23"),
        AcquiredTrophy(id: "aaa123", trophy: TrophyEntity(id: "333333333", title: "그대의 노력에 건배", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"), createdAt: "2024-02-11", updatedAt: "2024-05-23")
    ]
    
    //basic default trophy data
    let tempTrophyData = [
        TrophyEntity(id: "111111111", title: "지금까지의 노력, 최고에요!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"),
        TrophyEntity(id: "222222222", title: "이 정도로 해낼줄이야!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"),
        TrophyEntity(id: "333333333", title: "그대의 노력에 건배", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"),
        TrophyEntity(id: "444444444", title: "미쳐 날뛰는 중", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"),
        TrophyEntity(id: "555555555", title: "빠밤빠밤! 당신은 만렙 고인물!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s")
    ]

    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(tempTrophyData) { trophy in
                    
//                    for acquired in tempUserAcquiredTrophyData {
//                        if acquired.trophy.id == trophy.id {
//                            TrophyContent(tempTrophyTitle: trophy.title, tempTrophyExplanation: "누적 학습시간 ", tempImageUrlString: trophy.imageUrl, achievedDate: acquired.updatedAt)
//                        } else {
//                            TrophyContent(tempTrophyTitle: trophy.title, tempTrophyExplanation: "누적 학습시간 100시간 돌파", tempImageUrlString: trophy.imageUrl)
//                        }
//                    }
                    
                    TrophyContent(tempTrophyTitle: trophy.title, tempTrophyExplanation: "누적 학습시간 100시간 돌파", tempImageUrlString: trophy.imageUrl)
                    
                }
            }
        }
        .background(Color.backgroundColor)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TrophyListView()
}
