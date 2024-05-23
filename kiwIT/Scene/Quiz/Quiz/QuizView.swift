//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import SwiftUI

struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var testDataForQuestion = ["첫번째 문제입니다", "두번째 문제입니다", "세번째 문제입니다", "네번째 문제입니다", "다섯번째 문제입니다"]
    @State private var quizIndex = 0
    
    @State private var testDataForMultipleChoice = [["A", "B", "C", "D", "E"],
                                                    ["F", "G", "H", "I", "J"],
                                                    ["K", "L", "M", "N", "O"],
                                                    ["P", "Q", "R", "S", "T"],
                                                    ["U", "V", "W", "X", "Y"],]
    
    
    @State private var userOXAnswer = [Bool]()
    
    @State private var userMultipleAnswer = [Int]()
    
    @State private var userShortAnswer = [String]()
        
    @State private var isQuizCompleted = false
    
    //차후 quiz payload 받아서 하나씩 나타내기
    //답변 한 만큼 새롭게 나타나도록 하기 (개수 count 필요)
    
    //Payload 종류에 따른 View 나타내기 판단 로직 필요 (OX, 객관식, 단답형 조건 비교 필요)
    
    
    //userDefaults에 저장한 font size 설정 가져오기
    //없다면 default로 14 설정
    @State private var fontSize: CGFloat = 14
    
    @State private var isPopOverPresented = false
    
    private let answerForOXExample = [true, false, true, true, true]
    
    var body: some View {
        NavigationStack {
            
//            ScrollView {
            VStack {
                
                //MARK: - 수정 고려사항
                
                //퀴즈 폰트: LectureView에서 적용한 폰트 슬라이더 활용, 폰트 크기도 같이 전달하기
                                
                QuizContentOX(content: $testDataForQuestion[quizIndex],
                              quizIndex: quizIndex, 
                              quizCount: testDataForQuestion.count,
                              fontSize: fontSize) { result in
                    switch result {
                    case .success(let answer):
                        userOXAnswer.append(answer)
                                                
                        print("user's answer: \(userOXAnswer)")
                        if userOXAnswer.count == testDataForQuestion.count {
                            //ViewModel로 정답 전달하기 (혹은 같은 ViewModel 활용 시, 다음 View로 넘어가기)
                            isQuizCompleted = true
                            
//                            quizIndex = 0
//                            userOXAnswer.removeAll()
                            print("Quiz is done")
                            
                        } else {
                            quizIndex += 1
                        }
                    case .failure(.backToPreviousQuestion):
                        if quizIndex == 0 {
                            //Alert로 나타내기
                            print("맨 처음 문제입니다!!!")
                        } else {
                            print("user's answer: \(userOXAnswer)")
                            quizIndex -= 1
                            userOXAnswer.remove(at: userOXAnswer.count - 1)
                            
                            //향후 이전 답변 보여줄 경우, 답변 삭제보단 Index-1에서의 답변 확보 및 기존 답변을 새로운 답변으로 대체하는 식의 구성이 필요해보임
                            
                        }
                    }
                }
                .navigationDestination(isPresented: $isQuizCompleted) {
                    
                    //MARK: - 중간에 계산 중 화면 (빈 화면이라도) 만들고 거기서 다시 QuizResultView로 이동할 것
                    
                    QuizResultView(testDataForQuestion: testDataForQuestion, userOXAnswer: userOXAnswer, answers: answerForOXExample)
                }
                
//                QuizMultipleChoice(content: $testDataForQuestion[quizIndex],
//                                   choiceOne: $testDataForMultipleChoice[quizIndex][0],
//                                   choiceTwo: $testDataForMultipleChoice[quizIndex][1],
//                                   choiceThree: $testDataForMultipleChoice[quizIndex][2],
//                                   choiceFour: $testDataForMultipleChoice[quizIndex][3],
//                                   choiceFive: $testDataForMultipleChoice[quizIndex][4],
//                                   quizIndex: quizIndex,
//                                   quizCount: testDataForMultipleChoice.count,
//                                   fontSize: fontSize) { result in
//                    switch result {
//                    case .success(let selectedChoice):
//                        //0인 경우, 선택하지 않았음으로 틀린 답 처리
//                        userMultipleAnswer.append(selectedChoice)
//                        print("user's answer: \(userMultipleAnswer)")
//                
//                        if userMultipleAnswer.count == testDataForQuestion.count {
//                            
//                            //ViewModel로 정답 전달하기 (혹은 같은 ViewModel 활용 시, 다음 View로 넘어가기)
//                            isQuizCompleted = true
//                            
//                            quizIndex = 0
//                            userMultipleAnswer.removeAll()
//                            print("Quiz is done")
//                            
//                        } else {
//                            quizIndex += 1
//                        }
//                    case .failure(.backToPreviousQuestion):
//                        if quizIndex == 0 {
//                            //Alert로 나타내기
//                            print("맨 처음 문제입니다!!!")
//                        } else {
//                            print("user's answer: \(userMultipleAnswer)")
//                            quizIndex -= 1
//                            userMultipleAnswer.remove(at: userMultipleAnswer.count - 1)
//                            
//                            //향후 이전 답변 보여줄 경우, 답변 삭제보단 Index-1에서의 답변 확보 및 기존 답변을 새로운 답변으로 대체하는 식의 구성이 필요해보임
//                        }
//                    }
//                }
//                                   .navigationDestination(isPresented: $isQuizCompleted) {
//                                       QuizResultView()
//                                   }
                
//                    QuizContentShortAnswer(content: $testDataForQuestion[quizIndex],
//                                           quizIndex: quizIndex,
//                                           quizCount: testDataForQuestion.count,
//                                           fontSize: fontSize) { result in
//                        switch result {
//                        case .success(let userAnswer):
//                            self.userShortAnswer.append(userAnswer)
//                            print("user's answer: \(userShortAnswer)")
//                            
//                            if userShortAnswer.count == testDataForQuestion.count {
//                                
//                                //ViewModel로 정답 전달하기 (혹은 같은 ViewModel 활용 시, 다음 View로 넘어가기)
//                                isQuizCompleted = true
//
//                                quizIndex = 0
//                                userShortAnswer.removeAll()
//                                print("Quiz is done")
//                                
//                            } else {
//                                quizIndex += 1
//                            }
//                        case .failure(.backToPreviousQuestion):
//                            if quizIndex == 0 {
//                                //Alert로 나타내기
//                                print("맨 처음 문제입니다!!!")
//                            } else {
//                                print("user's answer: \(userShortAnswer)")
//                                quizIndex -= 1
//                                userShortAnswer.remove(at: userShortAnswer.count - 1)
//                                
//                                //향후 이전 답변 보여줄 경우, 답변 삭제보단 Index-1에서의 답변 확보 및 기존 답변을 새로운 답변으로 대체하는 식의 구성이 필요해보임
//                            }
//                        }
//                    }
//                    .navigationDestination(isPresented: $isQuizCompleted) {
//                        QuizResultView()
//                    }
                
            }
//            .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.backgroundColor)
            
        }
//        .refreshable { print("to disable pull to refresh in ") }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Quiz Title")
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
    QuizView()
}
