//
//  CreateInterviewSheet.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

struct CreateInterviewSheet: View {
        
    @Binding var passedCategory: [LectureCategoryListPayload]
    @Binding var passedLevel: [LectureLevelListPayload]
    
    @State private var chosenCategory: LectureCategoryListPayload?
    @State private var chosenLevel: LectureLevelListPayload?
    
    @State private var numOfQuestions = 5
    @State private var expectedTotalTime = 5
    @State private var shouldBeIncludedString = ""
    
    var confirmAction: (CreateInterviewContent) -> Void

    init(category: Binding<[LectureCategoryListPayload]>, level: Binding<[LectureLevelListPayload]>, confirmAction: @escaping (CreateInterviewContent) -> Void) {
        self._passedCategory = category
        self._passedLevel = level
        self.confirmAction = confirmAction
    }
    
    var body: some View {
        ScrollView {
            GroupBox(label: Text("인터뷰 분야")
                .foregroundStyle(Color.textColor)
                .font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if passedCategory.isEmpty {
                        ProgressView {
                            Text("불러오는 중...")
                        }
                    } else {
                        ForEach(passedCategory, id: \.self) { category in
                            HStack {
                                Button(action: {
                                    chosenCategory = category
                                }, label: {
                                    Image(systemName: chosenCategory == category ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                                })
                                Text(category.title)
                                    .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                                    .foregroundStyle(Color.textColor)
                            }
                        }
                    }
                }
            })
            .backgroundStyle(Color.backgroundColor)
            GroupBox(label: Text("본인의 위치")
                .foregroundStyle(Color.textColor)
                .font(.custom(Setup.FontName.notoSansBold, size: 20)), content: {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if passedLevel.isEmpty {
                        ProgressView {
                            Text("불러오는 중...")
                        }
                    } else {
                        ForEach(passedLevel, id: \.self) { level in
                            HStack {
                                Button(action: {
                                    chosenLevel = level
                                }, label: {
                                    Image(systemName: chosenLevel == level ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                                })
                                Text(level.title)
                                    .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                                    .foregroundStyle(Color.textColor)
                            }
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
                if let chosenCategory = chosenCategory, let chosenLevel = chosenLevel {
                    print("option chosen done!!!")
                    confirmAction(CreateInterviewContent(categoryId: chosenCategory.id, levelNum: chosenLevel.num, timeLimit: expectedTotalTime, etcRequest: shouldBeIncludedString, questionsCnt: numOfQuestions))
                }
            }
            .padding(.vertical, 10)
        }
        .background(Color.backgroundColor)
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}
