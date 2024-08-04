//
//  InterviewPastAnswersView.swift
//  kiwIT
//
//  Created by Heedon on 8/1/24.
//

import SwiftUI

struct InterviewPastAnswersView: View {
    var body: some View {
        
        ScrollView {
            
            //MARK: - expandable 내부에 답변 표시하기
            
            
//            ForEach(<#T##data: RandomAccessCollection##RandomAccessCollection#>, id: \.self) { eachInterview in
//            ContentExpandableChapterItemView(itemTitle: <#T##String#>) {
//                <#code#>
//            }
//            }
            
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

#Preview {
    InterviewPastAnswersView()
}
