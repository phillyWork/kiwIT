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
    var buttonColor: Color
    var buttonTitleFont: String
    
    @State private var tapped = false
    
    init(title: String, font: String, color: Color, tapAction: @escaping () -> Void) {
        self.buttonTitle = title
        self.action = tapAction
        self.buttonColor = color
        self.buttonTitleFont = font
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
            Button {
                withAnimation {
                    self.tapped.toggle()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
                    withAnimation {
                        self.tapped.toggle()
                    }
                    self.action()
                }
            } label: {
                Text(buttonTitle)
                    .foregroundStyle(Color.black)
                    .font(.custom(buttonTitleFont, size: 13))
                    .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
            }
            .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
            .background(buttonColor)
            .offset(CGSize(width: -8.0, height: -8.0))
        }
        .scaleEffect(tapped ? 0.8 : 1.0)
    }
}

#Preview {
    ShrinkAnimationButtonView(title: "확인", font: Setup.FontName.galMuri11Bold, color: Color.brandColor) {
        print("Active Button Pressed")
    }
}
