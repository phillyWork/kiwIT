//
//  ActiveButton.swift
//  kiwIT
//
//  Created by Heedon on 4/3/24.
//

import SwiftUI

struct ShrinkAnimationButtonView: View {
    
    var action: () -> Void
    var buttonTitle: String
    
    //image string 입력받기: 다음으로, 로그아웃, 회원탈퇴 용 시스템 이미지 활용???
    var imageString: String?
    
    //color 입력받기: 로그아웃, 회원탈퇴 용 컬러 설정
    var buttonColor: Color?
    
    @State private var tapped = false
    
    init(title: String, tapAction: @escaping () -> Void) {
        self.buttonTitle = title
        self.action = tapAction
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
            //이미지 제거 텍스트 위주 버튼만 구성하기 (혹은 아예 버튼으로 구성할 수도...)
            Button(action: {
                withAnimation {
                    self.tapped.toggle()
                    print("tapped first: \(tapped)")
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0002) {
                    withAnimation {
                        self.tapped.toggle()
                        print("after async: \(tapped)")
//                        self.action()
                    }
                    self.action()
                }
                
            }, label: {
                Text(buttonTitle)
                    .foregroundStyle(Color.textColor)
                    .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
            })
            
            .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
            .background(Color.brandColor)
            .offset(CGSize(width: -8.0, height: -8.0))
        }
        .scaleEffect(tapped ? 0.8 : 1.0)
//        .onTapGesture {
//            withAnimation {
//                self.tapped.toggle()
//            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.0002) {
//                withAnimation {
//                    self.tapped.toggle()
//                }
//            }
//            self.action()
//        }
    }
}

#Preview {
    ShrinkAnimationButtonView(title: "확인") {
        print("Active Button Pressed")
    }
}
