//
//  Setup+NetworkErrorMessages.swift
//  kiwIT
//
//  Created by Heedon on 4/29/24.
//

import Foundation

extension Setup {
    enum NetworkErrorMessage {
        
        static let invalidAccessToken = "요청 권한이 존재하지 않음. 토큰 리프레시 필요."
        
        
        static let signUpError = "중복된 닉네임이 존재합니다. 다른 닉네임을 입력해주세요."
        static let signInError202 = "회원가입이 필요합니다. 다음을 입력해주세요."
        static let signInError400 = "소셜 로그인에 오류가 발생했습니다. 다시 시도해주세요."
       
        //내부적 처리?
        static let signOutError = "로그아웃 권한이 없습니다.(토큰 리프레시 필요)"
        
        static let refreshTokenError = "사용 권한이 만료되었습니다. 다시 로그인해주세요."
        
        //내부적 처리?
        static let profileCheckError400 = "유저 정보가 존재하지 않습니다."
        static let profileCheckError401 = "유저 정보 확인 권한이 없습니다.(토큰 리프레시 필요)"

        static let profileEditError400 = "중복된 닉네임이 존재합니다. 다른 닉네임을 입력해주세요."
        
        //내부적 처리?
        static let profileEditError401 = "유저 정보 수정 권한이 없습니다.(토큰 리프레시 필요)"

        //미정된 API doc
        static let profileEditError500 = "미확인 사유(분리 예정 필요)"
        
        
        static let withdrawError400 = "잘못된 회원탈퇴 요청입니다. 다시 시도해주세요."
        
        //내부적 처리?
        static let withdrawError401 = "회원 탈퇴 요청 권한이 없습니다. (토큰 리프레시 필요)"
        
        
        static let acquiredTrophyListError400 = "잘못된 요청입니다. 다시 시도해주세요."
        
        //내부적 처리?
        static let acquiredTrophyListError401 = "트로피 획득 내역 확인 권한이 없습니다. (토큰 리프레시 필요)"
        
        
        static let mostRecentAcquiredTrophyError204 = "획득한 트로피가 존재하지 않습니다."
        
        static let mostRecentAcquiredTrophyError400 = "잘못된 요청입니다. 다시 시도해주세요."
       
        //내부적 처리?
        static let mostRecentAcquiredTrophyError401 = "가장 최근 획득한 트로피 확인 권한이 없습니다. (토큰 리프레시 필요)"
        
        
        //case summaryStat
       
        
        
        //내부적 처리?
        static let lectureLevelListCheckError = "레벨 리스트 조회 권한이 없습니다. (토큰 리프레시 필요)"
        static let lectureLevelListContentCheckError401 = "레벨 리스트의 컨텐츠 조회 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let lectureLevelListContentCheckError410 = "해당 레벨의 컨텐츠가 존재하지 않습니다."
        
        //내부적 처리?
        static let startOfLectureError401 = "학습 시작 권한이 없습니다. (토큰 리프레시 필요)"

        static let startOfLectureError410 = "해당 학습 컨텐츠가 존재하지 않습니다."
        
        
        //내부적 처리?
        static let completionOfLectureError401 = "학습 완료 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let completionOfLectureError410 = "해당 학습 컨텐츠가 존재하지 않습니다."

        
        static let exerciseForLectureError400 = "정답을 입력해야 합니다."

        //내부적 처리?
        static let exerciseForLectureError401 = "예제 문제 풀이 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let exerciseForLectureError410 = "해당 학습 컨텐츠가 존재하지 않습니다."
        
        
        //내부적 처리?
        static let lectureCategoryListCheckError = "과목 리스트 조회 권한이 없습니다. (토큰 리프레시 필요)"
        static let lectureCategoryListContentCheckError401 = "과목 리스트의 컨텐츠 조회 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let lectureCategoryListContentCheckError410 = "해당 과목의 컨텐츠가 존재하지 않습니다."
        
        static let lectureNextStudyProgressError400 = "이전에 학습한 내용이 존재하지 않습니다."
      
        //내부적 처리?
        static let lectureNextStudyProgressError401 = "다음 학습 진도 확인 권한이 없습니다. (토큰 리프레시 필요)"
        static let completedLectureListCheckError = "학습 완료 리스트 확인 권한이 없습니다. (토큰 리프레시 필요)"
        static let bookmarkedLectureCheckError = "보관한 학습 컨텐츠 확인 권한이 없습니다. (토큰 리프레시 필요)"

        
        static let bookmarkLectureError400 = "컨텐츠 보관함 처리에 실패했습니다. 다시 시도해주세요."
        static let bookmarkLectureError410 = "보관함 처리할 해당 학습 컨텐츠가 존재하지 않습니다."
        
     
        static let quizListCheckError400 = "잘못된 퀴즈 리스트 요청입니다. 다시 시도해주세요."
        
        //내부적 처리?
        static let quizListCheckError401 = "퀴즈 리스트 요청 권한이 없습니다. (토큰 리프레시 필요)"
        static let startTakingQuizError401 = "퀴즈 풀이 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let startTakingQuizError410 = "해당 퀴즈는 조회할 수 업습니다."
        
        static let submitQuizAnswersError400 = "모든 문제의 답안을 작성해야 제출할 수 있습니다."
        
        //내부적 처리?
        static let submitQuizAnswersError401 = "문제 답안 제출 권한이 없습니다. (토큰 리프레시 필요)"
    
        static let submitQuizAnswersError410 = "해당 퀴즈는 문제 풀이가 불가능합니다."
        

        static let submitQuizAnswersNTimesError400 = "모든 문제의 답안을 작성해야 제출할 수 있습니다."
        
        //내부적 처리?
        static let submitQuizAnswersNTimesError401 = "문제 답안 제출 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let submitQuizAnswersNTimesError410 = "해당 퀴즈는 문제 풀이가 불가능합니다."
        
     
        static let mostRecentTakenQuizError204 = "최근 답안을 제출한 퀴즈가 존재하지 않습니다."
        
        //내부적 처리?
        static let mostRecentTakenQuizError401 = "가장 최근에 답안을 제출한 퀴즈 확인 권한이 없습니다. (토큰 리프레시 필요)"
        static let takenQuizListCheckError = "답안을 제출한 퀴즈 리스트 확인 권한이 없습니다. (토큰 리프레시 필요)"
        static let bookmarkedQuizCheckError = "보관한 퀴즈 확인 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let bookmarkQuizError = "퀴즈 보관함 처리에 실패했습니다. 다시 시도해주세요."
        
    }
}
