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
    
    //var quizPayload: QuizPayload
    
    @Binding var content: String
    
    @State private var chosenState = UserOXAnswerState.unchosen
    
    var completion: (Result<Bool, QuizError>) -> Void
        
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()
                    
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 25))
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            //O 표시 확인 및 다음 문제로 넘어가기
                            print("O button is tapped. Move on to next!")
//                            self.completion(true)
                            chosenState = chosenState == .chosenTrue ? .unchosen : .chosenTrue
                        }, label: {
                            QuizOXButtonLabel(buttonLabel: "O")
                        })
                        .background(chosenState == .chosenTrue ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
                            //X 표시 확인 및 다음 문제로 넘어가기
                            print("X button is tapped. Move on to next!")
//                            self.completion(false)
                            chosenState = chosenState == .chosenFalse ? .unchosen : .chosenFalse
                        }, label: {
                            QuizOXButtonLabel(buttonLabel: "X")
                        })
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
            .onDisappear {
                self.content = ""
            }
            
            HStack {
                Spacer()
                Button(action: {
                    print("Tap this button to go back to previous question")
                    self.completion(.failure(.backToPreviousQuestion))
                    chosenState = .unchosen
                }, label: {
                    Text("이전으로")
                })
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    if chosenState == .unchosen {
                        print("O, X 중 하나는 선택해야 합니다!!!")
                    } else {
                        chosenState == .chosenTrue ? self.completion(.success(true)) : self.completion(.success(false))
                        chosenState = .unchosen
                    }
                }, label: {
                    Text("다음으로")
                })
                Spacer()
            }
            
        }
    }
}
