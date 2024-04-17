//
//  ActiveButton.swift
//  kiwIT
//
//  Created by Heedon on 4/3/24.
//

import SwiftUI

struct ActiveButtonView: View {
    
    var action: () -> Void
    var buttonTitle: String
    
    @State private var tapped = false
    
    init(title: String, tapAction: @escaping () -> Void) {
        self.buttonTitle = title
        self.action = tapAction
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.nextContentButtonWidth, height: Setup.Frame.nextContentButtonHeight)
            //이미지 제거 텍스트 위주 버튼만 구성하기 (혹은 아예 버튼으로 구성할 수도...)
            VStack {
                Image(systemName: Setup.ImageStrings.defaultLecture2)
                Text(buttonTitle)
            }
            .frame(width: Setup.Frame.nextContentButtonWidth, height: Setup.Frame.nextContentButtonHeight)
            .background(Color.brandColor)
            .offset(CGSize(width: -8.0, height: -8.0))
        }
        .scaleEffect(tapped ? 0.8 : 1.0)
        .onTapGesture {
            self.action()
            withAnimation {
                self.tapped.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) {
                withAnimation {
                    self.tapped.toggle()
                }
            }
        }
    }
}

#Preview {
    ActiveButtonView(title: "확인") {
        print("Active Button Pressed")
    }
}
