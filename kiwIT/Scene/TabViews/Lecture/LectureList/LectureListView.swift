//
//  LectureCategoryListView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

enum LectureListType: String, CaseIterable {
    case category = "과목"
    case level = "레벨"
}

//MARK: - Lecture: 레벨 및 과목 리스트, 내역 조회, 학습 시작, 학습 보관, 결과
struct LectureListView: View {
    
    @StateObject var lectureListVM = LectureListViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Pick", selection: $lectureListVM.lectureType) {
                    ForEach(LectureListType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 8)
                .onChange(of: lectureListVM.lectureType) { _ in
                    lectureListVM.updateViewByPickerSelection()
                }
                
                ScrollView {
                    VStack {
                        Image(systemName: Setup.ImageStrings.topDirection)
                            .scaledToFit()
                        Text("당겨서 새로고침")
                            .font(.custom(Setup.FontName.lineThin, size: 12))
                            .foregroundStyle(Color.textColor)
                    }
                    if (lectureListVM.showLectureList) {
                        LazyVStack(spacing: 4) {
                            switch lectureListVM.lectureType {
                            case .category:
                                ForEach(lectureListVM.lectureCategoryListData, id: \.self) { data in
                                    NavigationLink {
                                        LectureContentListView(lectureListVM: lectureListVM)
                                            .toolbar(.hidden, for: .tabBar)
                                    } label: {
                                        LectureCategoryItemView(title: data.title, ratio: 0.75, imageUrl: data.thumbnailUrl)
                                    }
                                }
                                .frame(maxHeight: .infinity)
                            case .level:
                                ForEach(lectureListVM.lectureLevelListData, id: \.self) { data in
                                    NavigationLink {
                                        LectureContentListView(lectureListVM: lectureListVM)
                                            .toolbar(.hidden, for: .tabBar)
                                    } label: {
                                        LectureCategoryItemView(title: data.title, ratio: 0.75)
                                    }
                                }
                                .frame(maxHeight: .infinity)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
                    } else {
                        EmptyView()
                            .frame(maxWidth: .infinity)
                            .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle("학습 카테고리")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
                .onChange(of: lectureListVM.isLoginAvailable) { newValue in
                    if !newValue {
                        tabViewsVM.isLoginAvailable = false
                    }
                }
            }
            .background(Color.backgroundColor)
        }
        .refreshable {
            print("Pull to Refresh Lecture List in \(lectureListVM.lectureType)!!!")
            lectureListVM.requestLectureList()
        }
    }
}

#Preview {
    LectureListView(tabViewsVM: TabViewsViewModel())
}
