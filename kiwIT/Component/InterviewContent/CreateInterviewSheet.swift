//
//  CreateInterviewSheet.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

enum InterViewTopic: String, CaseIterable {
    case dataStructure = "자료구조"
    case operatinSystem = "운영체제"
    case iOSSwift = "Swift & iOS"
    case javaSpring = "Java & Spring"
    case javaScriptNode = "Javascript & Node"
    case basicWebDev = "웹 개발"
}

enum UserLevel: String, CaseIterable {
    case newbie = "첫 시작"
    case freshmen = "해당 분야 학습 시작"
    case sophomore = "학습 과정 완료"
    case junior = "포폴 준비 중"
    case senior = "신입"
    case experienced = "경력직"
}

struct CreateInterviewSheet: View {
        
    @State private var selectedTopic: InterViewTopic = .dataStructure
    @State private var userLevel: UserLevel = .sophomore
    @State private var numOfQuestions = 5
    @State private var expectedTotalTime = 5
    @State private var shouldBeIncludedString = ""
    
    var confirmAction: (CreateInterviewContent) -> Void

    init(_ confirmAction: @escaping (CreateInterviewContent) -> Void) {
        self.confirmAction = confirmAction
    }
    
    var body: some View {
        ScrollView {
            GroupBox(label: Text("인터뷰 분야")
                .foregroundStyle(Color.textColor)
                .font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(InterViewTopic.allCases, id: \.self) { topic in
                        HStack {
                            Button(action: {
                                selectedTopic = topic
                            }, label: {
                                Image(systemName: selectedTopic == topic ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                            })
                            Text(topic.rawValue)
                                .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                                .foregroundStyle(Color.textColor)
                        }
                    }
                }
            })
            .backgroundStyle(Color.backgroundColor)
            GroupBox(label: Text("본인의 위치")
                .foregroundStyle(Color.textColor)
                .font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(UserLevel.allCases, id: \.self) { level in
                        HStack {
                            Button(action: {
                                userLevel = level
                            }, label: {
                                Image(systemName: userLevel == level ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                            })
                            Text(level.rawValue)
                                .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                                .foregroundStyle(Color.textColor)
                        }
                    }
                }
            })
            .backgroundStyle(Color.backgroundColor)
            
            //MARK: - 3~5분 설정하기 (polling 활용, 타이머 설정 필요)
            GroupBox(label: Text("총 예상 답변 시간").font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                Picker(selection: $expectedTotalTime) {
                    ForEach(0..<12) { index in
                        let minute = (index + 1) * 5
                        Text("\(minute) 분")
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                            .tag(minute)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.menu)
            })
            .backgroundStyle(Color.backgroundColor)
            
            //MARK: - 3~5문항 설정 (polling 활용, 타이머 설정 필요)
            GroupBox(label: Text("문항 수").font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                Picker(selection: $numOfQuestions) {
                    ForEach(0..<6) { index in
                        let questions = (index + 1) * 5
                        Text("\(questions) 문제")
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                            .tag(questions)
                    }
                } label: {
                    Text("")
                }
                .pickerStyle(.palette)
            })
            .backgroundStyle(Color.backgroundColor)
            GroupBox(label: Text("추가 요구사항").font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("한 문장으로 간결하게 작성해주세요")
                        .font(.custom(Setup.FontName.notoSansRegular, size: 12))
                        .foregroundStyle(Color.textColor)
                    TextField("", text: $shouldBeIncludedString, prompt: Text("문장을 입력해주세요").font(.custom(Setup.FontName.notoSansRegular, size: 15)))
                }
            })
            .backgroundStyle(Color.backgroundColor)
            ShrinkAnimationButtonView(title: "생성하기", font: Setup.FontName.galMuri11Bold, color: Color.brandBlandColor) {
                confirmAction(CreateInterviewContent(topic: selectedTopic.rawValue, numOfQuestions: numOfQuestions, expectedTotalAnswerTime: expectedTotalTime, shouldBeIncludedString: shouldBeIncludedString))
            }
            .padding(.vertical, 10)
        }
        .background(Color.backgroundColor)
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

#Preview {
    CreateInterviewSheet { content in
        print("content: \(content)")
    }
}
