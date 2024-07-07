//
//  RecentlyAcquiredTrophy.swift
//  kiwIT
//
//  Created by Heedon on 6/6/24.
//

import SwiftUI

struct RecentlyAcquiredTrophy: View {
    
    //MARK: - 빈칸 역할의 트로피 이미지 필요
    
    var tempImageUrlString: String
    
    var body: some View {
        AsyncImage(url: URL(string: tempImageUrlString)) { image in
            //ViewModel에서 변환 처리?
            
            //                let renderer = ImageRenderer(content: image)
            //                if let uiImage = renderer.uiImage {
            //                    self.imageForExpandable = uiImage
            //                }
            
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: Setup.Frame.recentlyAcquiredTrophyContentWidth, height: Setup.Frame.recentlyAcquiredTrophyContentHeight)
        .border(Color.red)
    }
}

#Preview {
    RecentlyAcquiredTrophy(tempImageUrlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s")
}
