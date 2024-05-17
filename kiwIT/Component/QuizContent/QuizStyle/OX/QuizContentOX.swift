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
    
    //이전 답변 보여주기: viewModel에서 답변도 보유, 해당 답변 참조해서 이전 문항의 답변 통해 색칠하기?
    
    func updateHeight(height: CGFloat, fontSize: CGFloat) -> CGFloat {
        if (fontSize <= 15) {
            return height
        } else if (fontSize <= 25) {
            return height * 1.2
        } else if (fontSize <= 50) {
            return height * 2
        } else {
            return height * 3
        }
    }
    
    @Binding var content: String
    
    @State private var chosenState: UserOXAnswerState = .unchosen
    
    var quizIndex: Int
    var quizCount: Int
    
    var fontSize: CGFloat
    
    var completion: (Result<Bool, QuizError>) -> Void
    
    var body: some View {
        VStack {
            
            withAnimation(.easeInOut) {
                ZStack(alignment: .center) {
                
                Rectangle()
                    .fill(Color.shadowColor)
                //.frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: updateHeight(height: Setup.Frame.quizContentOXItemHeight, fontSize: fontSize))
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()
                    
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: fontSize))
                    
                    Spacer()
                    
                    HStack {
                        
                        //MARK: - 이전 답변 가져온 것 적용되지 않는 문제 존재
                        
                        Button(action: {
                            //O 표시 확인 및 다음 문제로 넘어가기
                            chosenState = chosenState == .chosenTrue ? .unchosen : .chosenTrue
                        }, label: {
                            QuizOXButtonLabel(buttonLabel: "O")
                        })
                        .background(chosenState == .chosenTrue ? Color.brandColor : Color.surfaceColor)
                        
                        Button(action: {
                            //X 표시 확인 및 다음 문제로 넘어가기
                            chosenState = chosenState == .chosenFalse ? .unchosen : .chosenFalse
                        }, label: {
                            QuizOXButtonLabel(buttonLabel: "X")
                        })
                        .background(chosenState == .chosenFalse ? Color.brandColor : Color.surfaceColor)
                        
                    }
                    
                    Spacer()
                    
                }
                //                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                .frame(width: Setup.Frame.quizContentItemWidth, height: updateHeight(height: Setup.Frame.quizContentOXItemHeight, fontSize: fontSize))
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            .onDisappear {
                self.content = ""
            }
        }
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button(action: {
                        print("Tap this button to go back to previous question")
                        self.completion(.failure(.backToPreviousQuestion))
                        chosenState = .unchosen
                    }, label: {
                        Text("이전으로")
                    })
                }
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    if chosenState == .unchosen {
                        //Alert 띄우기
                        print("O, X 중 하나는 선택해야 합니다!!!")
                    } else {
                        chosenState == .chosenTrue ? self.completion(.success(true)) : self.completion(.success(false))
                        chosenState = .unchosen
                    }
                }, label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
                })
                Spacer()
            }
            
        }
    }
    
}
