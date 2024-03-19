//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureView: View {
    
    @Environment(\.dismiss) var dismiss
    
    //콘텐츠 학습 완료: 스크롤 맨 마지막 버튼에서 학습 완료되었다고 버튼 눌러야 확인 완료
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ForEach(0..<100) { row in
                        //Viewmodel에서 서버에서 받은 Payload의 내부 컨텐츠 타입이 text인지 image인지 받아서 해당 타입에 따른 object 구성하기
                        Text("Hi There, \(row)")
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Section 1.")
                        .font(.headline)
                    Text("\"컴퓨터란\" 1분 요약")
                        .font(.subheadline)
                        .bold()
                }
            }
            ToolbarItem(placement: .topBarLeading) {
                Button("나가기") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    LectureView()
}
