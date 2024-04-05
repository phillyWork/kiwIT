//
//  ActiveButton.swift
//  kiwIT
//
//  Created by Heedon on 4/3/24.
//

import SwiftUI

struct ActiveButton: View {
    
    var action: () -> Void
    @State private var tapped = false
    
    init(tapAction: @escaping () -> Void) {
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
                Text("다음에 학습할 내용")
            }
            .frame(width: Setup.Frame.nextContentButtonWidth, height: Setup.Frame.nextContentButtonHeight)
            .background(Color.brandColor)
            .offset(CGSize(width: -8.0, height: -8.0))
        }
        .scaleEffect(tapped ? 0.9 : 1.0)
        .onTapGesture {
            self.action()
            withAnimation {
                self.tapped.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    self.tapped.toggle()
                }
            }
        }
    }
}

#Preview {
    ActiveButton {
        print("Active Button Pressed")
    }
}
