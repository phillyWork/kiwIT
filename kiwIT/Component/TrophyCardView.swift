//
//  TrophyCardView.swift
//  kiwIT
//
//  Created by Heedon on 7/24/24.
//

import SwiftUI

struct TrophyCardView: View {
    
    var trophy: TrophyEntity
    
    var body: some View {
        VStack {
            Text(trophy.title)
            HStack {
                Text(trophy.type.description)
                Text(": \(trophy.threshold)")
            }
        }
        .frame(width: 300, height: 300)
        .background(Color.surfaceColor)
    }
}

#Preview {
    TrophyCardView(trophy: TrophyEntity(id: 1, title: "mocktest", imageUrl: "https://", type: .chapterClear, threshold: 300))
}
