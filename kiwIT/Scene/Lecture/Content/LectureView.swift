//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureView: View {
    
    @Environment(\.dismiss) var dismiss
    
    //userDefaults에 저장한 font size 설정 가져오기
    //없다면 default로 14 설정
    @State private var fontSize: CGFloat = 14
    
    @State private var isPopOverPresented = false
    
    //콘텐츠 학습 완료: 스크롤 맨 마지막 버튼에서 학습 완료되었다고 버튼 눌러야 확인 완료
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
//                    ForEach(0..<100) { row in
//                        //Viewmodel에서 서버에서 받은 Payload의 내부 컨텐츠 타입이 text인지 image인지 받아서 해당 타입에 따른 object 구성하기
//                        
//                        //Image tap: 사진 full cover, 확대 가능하도록
////                        ContentImageView(url: urlString)
//                        
//                        ContentTextView(context: "Hi there, \(row)")
//                        
//                        
//                        //폰트 및 글씨 크기 변경 가능하도록
//                        //slider, option button 등등
//                        
//                        //폰트, 글씨 설정 변경: 로컬에서 저장
//                        //없다면 default 폰트와 크기로 설정 (UserDefaults?)
//                        
//                    }
                    
                    ContentSectionTitleView(title: "Section 0. 데이터 형태를 정해야 할 필요가 있을까요?")
//                        .background(Color.red)
                    
                    ContentImageView(urlString: "https://i.namu.wiki/i/2_NN7d9gqwTIbXcyPdjHJ5LLVFCwTAA6dQSr7SVqBflyUK1JrL6p2K5ld415BKo7FNd1o0GBDyfDz0bWUa6K0A.webp")
                    
                    ContentTextView(context: "이 글을 보러온 분들은 이미 개발 언어를 배워본 적이 있거나, 코딩 테스트를 위해, 혹은 본격적인 개발을 위한 이론을 위해 찾아오신 분들이겠죠?", fontSize: fontSize)
                    
                    ContentTextView(context: "그냥 개발하면 되지 왜 굳이 형태를 정해서 활용하려 할까요?", fontSize: fontSize)
                    
                    ContentTextView(context: "예를 한번 들어볼까요? 다음 사진을 잘 봐주세요", fontSize: fontSize)
                    
                    ActiveButtonView(title: "확인해보기") {
                        print("Code")
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.backgroundColor)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Chapter 1")
                    .font(.custom(Setup.FontName.phuduBold, size: 20))
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                })
                .tint(Color.textColor)
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    self.isPopOverPresented = true
                }) {
                    Image(systemName: Setup.ImageStrings.textSize)
                        .tint(Color.textColor)
                }
                .popover(isPresented: $isPopOverPresented, 
                         attachmentAnchor: .point(.bottom),
                         arrowEdge: .bottom,
                         content: {
                
                    //따로 다른 view로 분리?
                    VStack {
                        Text("폰트 크기 설정: \(Int(fontSize))")
                            .font(.custom(Setup.FontName.notoSansThin, size: 16))
                            .foregroundStyle(Color.textColor)
                        Slider(value: $fontSize, in: 5...100, step: 1)
                            .tint(Color.brandColor)
                    }
                    .padding()
                    .presentationCompactAdaptation(.popover)
                    
                })
            }
        }
    }
}

#Preview {
    LectureView()
}
