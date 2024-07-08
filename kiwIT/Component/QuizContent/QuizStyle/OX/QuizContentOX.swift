//
//  QuizContentItem.swift
//  kiwIT
//
//  Created by Heedon on 5/7/24.
//

import SwiftUI

enum UserOXAnswerState {
    case chosenTrue
    case chosenFalse
    case unchosen
}

struct QuizContentOX: View {
    
    var quizPayload: QuizPayload
    
    @State private var chosenState: UserOXAnswerState = .unchosen
    
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<Bool, QuizError>) -> Void
    
    var body: some View {
        VStack {
            
            withAnimation(.easeInOut) {
                ZStack(alignment: .center) {
                
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()
                    
                    Text(quizPayload.question)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .minimumScaleFactor(1.0)
                    
                    Spacer()
                    
                    HStack {
                        
                        //MARK: - 이전 답변 가져온 것 적용되지 않는 문제 존재
                        
                        Button {
                            //O 표시 확인 및 다음 문제로 넘어가기
                            chosenState = chosenState == .chosenTrue ? .unchosen : .chosenTrue
                        } label: {
                            QuizOXButtonLabel(buttonLabel: "O")
                        }
                        .background(chosenState == .chosenTrue ? Color.brandColor : Color.surfaceColor)
                        
                        Button {
                            //X 표시 확인 및 다음 문제로 넘어가기
                            chosenState = chosenState == .chosenFalse ? .unchosen : .chosenFalse
                        } label: {
                            QuizOXButtonLabel(buttonLabel: "X")
                        }
                        .background(chosenState == .chosenFalse ? Color.brandColor : Color.surfaceColor)
                        
                    }
                    
                    Spacer()
                    
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
        }
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button {
                        print("Tap this button to go back to previous question")
                        self.completion(.failure(.backToPreviousQuestion))
                        chosenState = .unchosen
                    } label: {
                        Text("이전으로")
                    }
                }
                Spacer()
                Button {
                    print("Tap this button to move to next question")
                    if chosenState == .unchosen {
                        //Alert 띄우기
                        print("O, X 중 하나는 선택해야 합니다!!!")
                    } else {
                        chosenState == .chosenTrue ? self.completion(.success(true)) : self.completion(.success(false))
                        chosenState = .unchosen
                    }
                } label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
                }
                Spacer()
            }
            
        }
    }
    
}
