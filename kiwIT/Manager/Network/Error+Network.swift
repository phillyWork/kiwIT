//
//  Error+Network.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

enum NetworkErrorCase {
    
    case signUp
    case signIn
    case signOut
    case refreshToken
    case withdraw
    case profileCheck
    case profileEdit
    
    case lectureLevelListCheck
    case lectureLevelListContentCheck
    case startOfLecture
    case completionOfLecture
    case exerciseForLecture
    case lectureCategoryListCheck
    case lectureCategoryListContentCheck
    case nextLectureToStudyCheck
    case completedLectureListCheck
    case bookmarkedLectureCheck
    case bookmarkLecture
    
    case quizListCheck
    case startTakingQuiz
    case submitQuizAnswers
    case latestTakenQuiz
    case takenQuizListCheck
    case bookmarkedQuizCheck
    case bookmarkQuiz
    
    case wholeTrophyList
    case trophyDetail
    case acquiredTrophyList
    case latestAcquiredTrophy
    
    
    //MARK: - 에러 케이스 분류: API 업데이트 따른 수정 필요
    case interviewList
    case interviewOptionList
    case createInterview
    case deleteInterview
    case editInterview
    case interviewRoomList
    case startInterviewRoom
    case interviewQuestionsList
    case checkInterviewRoomQueue
    case interviewPastAnswers
    case submitInterviewRoom
    case deleteInterviewRoom
    
}

struct NetworkErrorMessage {
    let status: Int
    let errorCase: NetworkErrorCase
    
    var message: String {
        switch status {
        case 204:
            switch errorCase {
            case .latestTakenQuiz:
                return Setup.NetworkErrorMessage.latestTakenQuizError204
            case .latestAcquiredTrophy:
                return Setup.NetworkErrorMessage.latestAcquiredTrophyError204
            default:
                return "Error Code 204"
            }
        case 400:
            switch errorCase {
            case .signUp:
                return Setup.NetworkErrorMessage.signUpError
            case .signIn:
                return Setup.NetworkErrorMessage.signInError400
            case .withdraw:
                return Setup.NetworkErrorMessage.withdrawError400
            case .profileCheck:
                return Setup.NetworkErrorMessage.profileCheckError400
            case .profileEdit:
                return Setup.NetworkErrorMessage.profileEditError400
            case .exerciseForLecture:
                return Setup.NetworkErrorMessage.exerciseForLectureError400
            case .nextLectureToStudyCheck:
                return Setup.NetworkErrorMessage.lectureNextStudyProgressError400
            case .bookmarkLecture:
                return Setup.NetworkErrorMessage.bookmarkLectureError400
            case .quizListCheck:
                return Setup.NetworkErrorMessage.quizListCheckError400
            case .startTakingQuiz:
                return Setup.NetworkErrorMessage.startTakingQuizError400
            case .submitQuizAnswers:
                return Setup.NetworkErrorMessage.submitQuizAnswersError400
            case .bookmarkQuiz:
                return Setup.NetworkErrorMessage.bookmarkQuizError
            case .wholeTrophyList:
                return Setup.NetworkErrorMessage.wholeTrophyListError
            case .trophyDetail:
                return Setup.NetworkErrorMessage.trophyDetailError
            case .acquiredTrophyList:
                return Setup.NetworkErrorMessage.acquiredTrophyListError400
            case .latestAcquiredTrophy:
                return Setup.NetworkErrorMessage.latestAcquiredTrophyError400
            case .interviewList:
                return Setup.NetworkErrorMessage.interviewListError
            case .interviewOptionList:
                return Setup.NetworkErrorMessage.interviewOptionListError
            case .createInterview:
                return Setup.NetworkErrorMessage.createInterviewError
            case .deleteInterview:
                return Setup.NetworkErrorMessage.deleteInterviewError
            case .editInterview:
                return Setup.NetworkErrorMessage.editInterviewError
            case .interviewRoomList:
                return Setup.NetworkErrorMessage.interviewRoomListError
            case .startInterviewRoom:
                return Setup.NetworkErrorMessage.startInterviewRoomError
            case .interviewQuestionsList:
                return Setup.NetworkErrorMessage.interviewQuestionsListError
            case .checkInterviewRoomQueue:
                return Setup.NetworkErrorMessage.checkInterviewRoomQueueError
            case .interviewPastAnswers:
                return Setup.NetworkErrorMessage.interviewPastAnswersError
            case .submitInterviewRoom:
                return Setup.NetworkErrorMessage.submitInterviewRoomError
            case .deleteInterviewRoom:
                return Setup.NetworkErrorMessage.deleteInterviewRoomError
            default:
                return "Error Code 400"
            }
        case 401:
            return Setup.NetworkErrorMessage.invalidAccessToken
        case 500:
            switch errorCase {
            case .profileEdit:
                return Setup.NetworkErrorMessage.profileEditError500
            default:
                return "Error Code 500"
            }
        default:
            return "Network Error: Invalid Case Error Messages"
        }
    }
}

enum NetworkError: Error {
    case invalidRequestBody(message: String)
    case emptyBody(message: String)
    case invalidToken(message: String)
    case invalidContent(message: String)
    
    init?(statusCode: Int, message: String) {
        switch statusCode {
        case 204: self = .emptyBody(message: message)
        case 400: self = .invalidRequestBody(message: message)
        case 401: self = .invalidToken(message: message)
        case 500: self = .invalidContent(message: message)
        default: return nil
        }
    }
    
    var description: String {
        switch self {
        case .emptyBody(let message):
            return message
        case .invalidRequestBody(let message):
            return message
        case .invalidToken(let message):
            return message
        case .invalidContent(let message):
            return message
        }
    }
}
