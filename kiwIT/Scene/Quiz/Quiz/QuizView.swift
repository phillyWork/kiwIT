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
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
//                QuizContentOX(content: $testDataForQuestion[quizIndex]) { result in
//                    switch result {
//                    case .success(let answer):
//                        userOXAnswer.append(answer)
//                        print("user's answer: \(userOXAnswer)")
//                        if userOXAnswer.count == testDataForQuestion.count {
//                            print("Quiz is done")
//                            isQuizCompleted = true
//                            quizIndex = 0
//                            userOXAnswer.removeAll()
//                        } else {
//                            quizIndex += 1
//                        }
//                    case .failure(.backToPreviousQuestion):
//                        if quizIndex == 0 {
//                            print("맨 처음 문제입니다!!!")
//                        } else {
//                            userOXAnswer.remove(at: userOXAnswer.count - 1)
//                            print("user's answer: \(userOXAnswer)")
//                            quizIndex -= 1
//                        }
//                    }
//                }
//                .navigationDestination(isPresented: $isQuizCompleted) {
//                    QuizResultView()
//                }
                
//                QuizMultipleChoice(content: $testDataForQuestion[quizIndex],
//                                   choiceOne: $testDataForMultipleChoice[quizIndex][0],
//                                   choiceTwo: $testDataForMultipleChoice[quizIndex][1],
//                                   choiceThree: $testDataForMultipleChoice[quizIndex][2],
//                                   choiceFour: $testDataForMultipleChoice[quizIndex][3],
//                                   choiceFive: $testDataForMultipleChoice[quizIndex][4]) { result in
//                    switch result {
//                    case .success(let selectedChoice):
//                        //0인 경우, 선택하지 않았음으로 틀린 답 처리
//                        userMultipleAnswer.append(selectedChoice)
//                        print("user's answer: \(userMultipleAnswer)")
//                
//                        if userMultipleAnswer.count == testDataForQuestion.count {
//                            print("Quiz is done")
//                            isQuizCompleted = true
//                            quizIndex = 0
//                            userMultipleAnswer.removeAll()
//                        } else {
//                            quizIndex += 1
//                        }
//                    case .failure(.backToPreviousQuestion):
//                        if quizIndex == 0 {
//                            print("맨 처음 문제입니다!!!")
//                        } else {
//                            userMultipleAnswer.remove(at: userMultipleAnswer.count - 1)
//                            print("user's answer: \(userMultipleAnswer)")
//                            quizIndex -= 1
//                        }
//                    }
//                }
//                                   .navigationDestination(isPresented: $isQuizCompleted) {
//                                       QuizResultView()
//                                   }
                
                    QuizContentShortAnswer(content: $testDataForQuestion[quizIndex]) { result in
                        switch result {
                        case .success(let userAnswer):
                            self.userShortAnswer.append(userAnswer)
                            print("user's answer: \(userShortAnswer)")
                            
                            if userShortAnswer.count == testDataForQuestion.count {
                                print("Quiz is done")
                                isQuizCompleted = true
                                quizIndex = 0
                                userShortAnswer.removeAll()
                            } else {
                                quizIndex += 1
                            }
                        case .failure(.backToPreviousQuestion):
                            if quizIndex == 0 {
                                print("맨 처음 문제입니다!!!")
                            } else {
                                userShortAnswer.remove(at: userShortAnswer.count - 1)
                                print("user's answer: \(userShortAnswer)")
                                quizIndex -= 1
                            }
                        }
                    }
                    .navigationDestination(isPresented: $isQuizCompleted) {
                        QuizResultView()
                    }
               
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            
        }
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
        }
       
    }
}

#Preview {
    QuizView()
}
