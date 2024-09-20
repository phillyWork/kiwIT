//
//  Setup+NetworkErrorMessages.swift
//  kiwIT
//
//  Created by Heedon on 4/29/24.
//

import Foundation

enum Setup {
    enum NetworkErrorMessage {
        
        static let invalidAccessToken = "요청 권한이 존재하지 않음. 토큰 리프레시 필요."
        
        static let signInError400 = "소셜 로그인에 오류가 발생했습니다. 다시 시도해주세요."
        
        static let signUpError = "닉네임 중복 혹은 이미 가입되어 있는 계정입니다. 다시 시도해주세요."
        
        //내부적 처리?
        static let signOutError = "로그아웃 권한이 없습니다.(토큰 리프레시 필요)"
        
        static let refreshTokenError = "사용 권한이 만료되었습니다. 다시 로그인해주세요."
        
        //내부적 처리?
        static let profileCheckError400 = "유저 정보가 존재하지 않습니다."

        static let profileEditError400 = "중복된 닉네임이 존재합니다. 다른 닉네임을 입력해주세요."

        //미정된 API doc
        static let profileEditError500 = "미확인 사유(분리 예정 필요)"
        
        
        static let withdrawError400 = "잘못된 회원탈퇴 요청입니다. 다시 시도해주세요."
        
        //case summaryStat
       
        
        //내부적 처리?
        static let lectureLevelListCheckError = "레벨 리스트 조회 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let lectureLevelListContentCheckError410 = "해당 레벨의 컨텐츠가 존재하지 않습니다."
        
        static let startOfLectureError410 = "해당 학습 컨텐츠가 존재하지 않습니다."
        
        static let completionOfLectureError410 = "해당 학습 컨텐츠가 존재하지 않습니다."

        
        static let exerciseForLectureError400 = "정답을 입력해야 합니다."

        static let exerciseForLectureError410 = "해당 학습 컨텐츠가 존재하지 않습니다."
        
        
        //내부적 처리?
        static let lectureCategoryListCheckError = "과목 리스트 조회 권한이 없습니다. (토큰 리프레시 필요)"
       
        static let lectureCategoryListContentCheckError410 = "해당 과목의 컨텐츠가 존재하지 않습니다."
        
        static let lectureNextStudyProgressError400 = "이전에 학습한 내용이 존재하지 않습니다."
      
        static let completedLectureListCheckError = "학습 완료 리스트 확인 권한이 없습니다. (토큰 리프레시 필요)"
        static let bookmarkedLectureCheckError = "보관한 학습 컨텐츠 확인 권한이 없습니다. (토큰 리프레시 필요)"

        
        static let bookmarkLectureError400 = "컨텐츠 보관함 처리에 실패했습니다. 다시 시도해주세요."
        static let bookmarkLectureError410 = "보관함 처리할 해당 학습 컨텐츠가 존재하지 않습니다."
        
     
        static let quizListCheckError400 = "잘못된 퀴즈 리스트 요청입니다. 다시 시도해주세요."
        
        
        static let startTakingQuizError400 = "해당 퀴즈는 조회할 수 업습니다."
        
        static let submitQuizAnswersError400 = "모든 문제의 답안을 작성해야 제출할 수 있습니다."
        
        static let latestTakenQuizError204 = "아직 푼 퀴즈가 없습니다."
        
        static let takenQuizListCheckError = "답안을 제출한 퀴즈 리스트 확인 권한이 없습니다. (토큰 리프레시 필요)"
        static let bookmarkedQuizCheckError = "보관한 퀴즈 확인 권한이 없습니다. (토큰 리프레시 필요)"
        
        static let bookmarkQuizError = "퀴즈 보관함 처리에 실패했습니다. 다시 시도해주세요."
        
        
        static let wholeTrophyListError = "잘못된 요청입니다. 트로피 리스트를 가져올 수 없습니다."
        
        static let trophyDetailError = "잘못된 트로피 정보입니다. 다시 시도해주세요."
        
        static let acquiredTrophyListError400 = "잘못된 요청입니다. 다시 시도해주세요."
        
        static let latestAcquiredTrophyError204 = "아직 획득한 트로피가 없습니다."
        
        static let latestAcquiredTrophyError400 = "잘못된 요청입니다. 다시 시도해주세요."
       
        static let confirmTrophyAcquisitionError = "잘못된 요청입니다. 존재하지 않는 트로피입니다."
        
        static let cancelTrophyAcquisitionError = "잘못된 취소 요청입니다. 다시 시도해주세요."
        
        
        //MARK: - API 수정 따라 업데이트 및 case 추가 필요
        static let interviewListError = "잘못된 요청입니다. 다시 시도해주세요."
        
        static let interviewOptionListError = "옵션 항목을 불러올 수 없어요. 다시 시도해주세요."
        
        static let createInterviewError = "인터뷰 생성 실패! 다시 시도해주세요."
        
        static let deleteInterviewError = "인터뷰 삭제 실패! 다시 시도해주세요."

        static let editInterviewError = "제목 수정 실패! 다시 시도해주세요."

        static let interviewRoomListError = "과거 기록을 불러올 수 없어요. 다시 시도해주세요."

        static let startInterviewRoomError = "인터뷰를 새롭게 시작할 수 없어요. 다시 시도해주세요."

        static let interviewQuestionsListError = "문항을 불러올 수 없어요. 다시 시도해주세요."

        static let checkInterviewRoomQueueError = "대기열 확인 실패! 다시 시도해주세요."

        static let interviewPastAnswersError = "이전 답변을 불러올 수 없어요. 다시 시도해주세요."

        static let submitInterviewRoomError = "제출 실패! 다시 시도해주세요."

        static let deleteInterviewRoomError = "과거 기록 삭제 실패! 다시 시도해주세요."
        
    }
}
