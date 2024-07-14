//
//  QuizResult.swift
//  kiwIT
//
//  Created by Heedon on 5/20/24.
//

import SwiftUI

//다시 풀기, 확인 완료 버튼 타입 설정
enum CompleteQuizButtonType {
    case takeQuizAgain
    case confirmToMoveToQuizList
}

struct QuizResult: View {
    
    var quizTitle: String
    var quizList: [QuizPayload]
    var userAnswerList: [QuizAnswer]
    var result: SubmitQuizResponse
    var completion: (CompleteQuizButtonType) -> Void
    
    @State private var isDetailButtonTapped = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                VStack {
                    Text("\(quizTitle) 결과")
                        .multilineTextAlignment(.center)
                        .font(.custom(Setup.FontName.notoSansBold, size: 25))
                        .frame(height: Setup.Frame.quizContentAnswerHeight * 0.3)
                    
                    //MARK: - 성취도 따른 이미지 추가? (앱단에서 나타내기)
                    AsyncImage(url: URL(string: "https://t3.ftcdn.net/jpg/01/75/28/30/360_F_175283093_kkRke2YnpL6HhNRUNPmRm4pFTV2OyLzY.jpg")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: Setup.Frame.quizContentAnswerResultImageWidth, height: Setup.Frame.quizContentAnswerResultImageWidth)
                    .padding(8)
                    
                    VStack {
                        Text("성취도: \(result.latestScore)")
                            .multilineTextAlignment(.center)
                            .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        Text("최고 점수: \(result.highestScore)")
                            .multilineTextAlignment(.center)
                            .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            
            HStack {
                Spacer()
                
                Button {
                    completion(.takeQuizAgain)
                } label: {
                    Text("다시 풀기")
                }
                Spacer()
                
                Button {
                    isDetailButtonTapped = true
                } label: {
                    Text("상세 보기")
                }
                
                Spacer()
                
                Button {
                    completion(.confirmToMoveToQuizList)
                } label: {
                    Text("확인 완료")
                }
                
                Spacer()
            }
            .fullScreenCover(isPresented: $isDetailButtonTapped, content: {
                //상세 결과 보여주기 위한 View 및 데이터 전달하기
                QuizResultDetailView(quizList, userAnswer: userAnswerList)
                    .presentationBackground(.thickMaterial)
            })
        }
    }
}

//#Preview {
//   QuizResult(questions: <#T##[String]#>, submittedAnswers: <#T##[Bool]#>, answers: <#T##[Bool]#>)
//}
