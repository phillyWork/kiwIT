//
//  LectureViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation
import Combine

final class LectureContentListViewModel: ObservableObject {
    
//    @Published var lectureContentInsideLevel = false
    
    @Published var lectureContentListLevelType: [LectureContentListPayload] = []
    @Published var lectureContentListCategoryType: [LectureCategoryContentResponse] = []
    
    init() {
        
    }
    
    func requestContentData() {
        
    }
    
    func requestLectureContent() {
        
    }
   
}
