//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import SwiftUI

struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var testDataForQuestion = ["1입니다", "2입니다", "3입니다", "4입니다", "5입니다"]
    @State private var quizIndex = 0
    
    @State private var testDataForMultipleChoice = [["A", "B", "C", "D", "E"],
                                                    ["F", "G", "H", "I", "J"],
                                                    ["K", "L", "M", "N", "O"],
                                                    ["P", "Q", "R", "S", "T"],
                                                    ["U", "V", "W", "X", "Y"],]
    
    //차후 quiz payload 받아서 하나씩 나타내기
    //답변 한 만큼 새롭게 나타나도록 하기 (개수 count 필요)
    
    var body: some View {
        NavigationStack {
            ScrollView {
//                QuizContentOX(content: $testDataForQuestion[quizIndex]) { isTappedOnO in
//                    if isTappedOnO {
//                        //plus on O, move on to next quiz
//                        print("O is tapped!!!")
//                    } else {
//                        //plus on X, move on to next quiz
//                        print("X is tapped!!!")
//                    }
//                    quizIndex += 1
//                    
//                    if quizIndex == testDataForQuestion.count {
//                        print("Quiz is done")
//                        quizIndex = 0
//                    }
//                }
                
                QuizMultipleChoice(content: $testDataForQuestion[quizIndex],
                                   choiceOne: $testDataForMultipleChoice[quizIndex][0],
                                   choiceTwo: $testDataForMultipleChoice[quizIndex][1],
                                   choiceThree: $testDataForMultipleChoice[quizIndex][2],
                                   choiceFour: $testDataForMultipleChoice[quizIndex][3],
                                   choiceFive: $testDataForMultipleChoice[quizIndex][4]) { selectedChoice in
                    switch selectedChoice {
                    case 1: print("1 is selected")
                    case 2: print("2 is selected")
                    case 3: print("3 is selected")
                    case 4: print("4 is selected")
                    case 5: print("5 is selected")
                    default:
                        print("wrong error")
                    }
                    quizIndex += 1
                    if quizIndex == testDataForQuestion.count {
                        print("Quiz is done")
                        quizIndex = 0
                    }
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
