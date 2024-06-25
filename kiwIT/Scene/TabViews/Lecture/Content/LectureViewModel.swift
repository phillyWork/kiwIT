//
//  LectureViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import Foundation

import Combine

final class LectureViewModel: ObservableObject {
    
    @Published var dismissLectureView = false
    
    @Published var showLectureExampleAlert = false
    @Published var showExampleAnswerAlert = false
    
    @Published var isThisLectureBookmarked = false
    
    private var userExampleAnswer = false
    private var exampleAnswer = false
    
    //for notion webview design example
    let url = "https://quartz-concrete-fb2.notion.site/af3f2d0e634d4c649eecca118ae41b93?pvs=4"
    
    func updateAnswerAsTrue() {
        userExampleAnswer = true
        showExampleAnswerAlert = true
    }
    
    func updateAnswerAsFalse() {
        userExampleAnswer = false
        showExampleAnswerAlert = true
    }

    func checkExampleAnswer() -> Bool {
        return userExampleAnswer == exampleAnswer
    }
 
    
    
    
    
}
