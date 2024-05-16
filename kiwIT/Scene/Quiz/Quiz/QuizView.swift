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
    @State private var userPreviousOXAnswer: Bool? = nil
    
    @State private var userMultipleAnswer = [Int]()
    @State private var userPreviousMultipleAnswer: Int = 0
    
    @State private var userShortAnswer = [String]()
    @State private var userPreviousShortAnswer = ""
    
    
    @State private var isQuizCompleted = false
    
    //차후 quiz payload 받아서 하나씩 나타내기
    //답변 한 만큼 새롭게 나타나도록 하기 (개수 count 필요)
    
    //Payload 종류에 따른 View 나타내기 판단 로직 필요 (OX, 객관식, 단답형 조건 비교 필요)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                //MARK: - 수정 고려사항
                
                //퀴즈 payload index 같이 보내기
            
                //퀴즈 폰트: LectureView에서 적용한 폰트 슬라이더 활용, 폰트 크기도 같이 전달하기
                
                //이전 답변 보여주기: 이전 선택한 답변 or 작성한 답변 나타내기: 답변 배열에서 이전 문항 해당하는 index의 답변 다시 보내기?
                
                QuizContentOX(content: $testDataForQuestion[quizIndex], 
                              quizIndex: quizIndex, quizCount: testDataForQuestion.count,
                              previous: userPreviousOXAnswer) { result in
                    switch result {
                    case .success(let answer):
                        
//                        userOXAnswer.insert(answer, at: quizIndex)
                        
                        print("so far answered count: \(userOXAnswer.count)")
                        print("this question's index: \(quizIndex)")
                        
                        userOXAnswer.append(answer)
                        
//                        if userOXAnswer.count <= quizIndex {
//                            print("new answer")
//                            userOXAnswer.append(answer)
//                        } else {
//                            print("already answered, but changed")
//                            userOXAnswer[quizIndex] = answer
//                        }
                                                
                        print("user's answer: \(userOXAnswer)")
                        if userOXAnswer.count == testDataForQuestion.count {
                            //ViewModel로 정답 전달하기 (혹은 같은 ViewModel 활용 시, 다음 View로 넘어가기)
                            isQuizCompleted = true
                            
                            quizIndex = 0
                            userOXAnswer.removeAll()
                            print("Quiz is done")
                            
                        } else {
                            quizIndex += 1
                            userPreviousOXAnswer = nil
                        }
                    case .failure(.backToPreviousQuestion):
                        if quizIndex == 0 {
                            //Alert로 나타내기
                            print("맨 처음 문제입니다!!!")
                        } else {
                            print("user's answer: \(userOXAnswer)")
                            quizIndex -= 1
                            userPreviousOXAnswer = userOXAnswer[quizIndex]
                            userOXAnswer.remove(at: userOXAnswer.count - 1)
                        }
                    }
                }
                .navigationDestination(isPresented: $isQuizCompleted) {
                    QuizResultView()
                }
                
                
                //이전 답변 가져오기 설정 필요
                
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
//                            userMultipleAnswer.remove(at: userMultipleAnswer.count - 1)
//                            print("user's answer: \(userMultipleAnswer)")
//                            quizIndex -= 1
//                        }
//                    }
//                }
//                                   .navigationDestination(isPresented: $isQuizCompleted) {
//                                       QuizResultView()
//                                   }
                
//                    QuizContentShortAnswer(content: $testDataForQuestion[quizIndex]) { result in
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
//                                userShortAnswer.remove(at: userShortAnswer.count - 1)
//                                print("user's answer: \(userShortAnswer)")
//                                quizIndex -= 1
//                            }
//                        }
//                    }
//                    .navigationDestination(isPresented: $isQuizCompleted) {
//                        QuizResultView()
//                    }
                
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
