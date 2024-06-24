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
    case acquiredTrophyList
    case mostRecentAcquiredTrophy
    
    //case summaryStat
        
    case lectureLevelListCheck
    case lectureLevelListContentCheck
    case startOfLecture
    case completionOfLecture
    case exerciseForLecture
    case lectureCategoryListCheck
    case lectureCategoryListContentCheck
    case lectureNextStudyProgress
    case completedLectureListCheck
    case bookmarkedLectureCheck
    case bookmarkLecture
    
    case quizListCheck
    case startTakingQuiz
    case submitQuizAnswers
    case submitQuizAnswersNTimes
    case mostRecentTakenQuiz
    case takenQuizListCheck
    case bookmarkedQuizCheck
    case bookmarkQuiz
    
}

struct NetworkErrorMessage {
    let status: Int
    let errorCase: NetworkErrorCase
    
    var message: String {
        switch status {
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
            case .acquiredTrophyList:
                return Setup.NetworkErrorMessage.acquiredTrophyListError400
            case .mostRecentAcquiredTrophy:
                return Setup.NetworkErrorMessage.mostRecentAcquiredTrophyError400
            case .exerciseForLecture:
                return Setup.NetworkErrorMessage.exerciseForLectureError400
            case .lectureNextStudyProgress:
                return Setup.NetworkErrorMessage.lectureNextStudyProgressError400
            case .bookmarkLecture:
                return Setup.NetworkErrorMessage.bookmarkLectureError400
            case .quizListCheck:
                return Setup.NetworkErrorMessage.quizListCheckError400
            case .submitQuizAnswers:
                return Setup.NetworkErrorMessage.submitQuizAnswersError400
            case .submitQuizAnswersNTimes:
                return Setup.NetworkErrorMessage.submitQuizAnswersNTimesError400
            case .bookmarkQuiz:
                return Setup.NetworkErrorMessage.bookmarkQuizError
            default:
                return "Error Code 400"
            }
        case 401:
            //case별로 다른 메시지가 필요할 지, 혹은 내부적으로 어차피 access token refresh이므로 그냥 넘어가도 될 지 고민
            return Setup.NetworkErrorMessage.invalidAccessToken
        case 410:
            switch errorCase {
            case .lectureLevelListContentCheck:
                return Setup.NetworkErrorMessage.lectureLevelListContentCheckError410
            case .startOfLecture:
                return Setup.NetworkErrorMessage.startOfLectureError410
            case .completionOfLecture:
                return Setup.NetworkErrorMessage.completionOfLectureError410
            case .exerciseForLecture:
                return Setup.NetworkErrorMessage.exerciseForLectureError410
            case .lectureCategoryListContentCheck:
                return Setup.NetworkErrorMessage.lectureCategoryListContentCheckError410
            case .bookmarkLecture:
                return Setup.NetworkErrorMessage.bookmarkLectureError410
            case .startTakingQuiz:
                return Setup.NetworkErrorMessage.startTakingQuizError410
            case .submitQuizAnswers:
                return Setup.NetworkErrorMessage.submitQuizAnswersError410
            case .submitQuizAnswersNTimes:
                return Setup.NetworkErrorMessage.submitQuizAnswersNTimesError410
            default:
                return "Error Code 410"
            }
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
    case invalidToken(message: String)
    case invalidPathVariable(message: String)
    case invalidContent(message: String)
    
    init?(statusCode: Int, message: String) {
        switch statusCode {
        case 400: self = .invalidRequestBody(message: message)
        case 401: self = .invalidToken(message: message)
        case 410: self = .invalidPathVariable(message: message)
        case 500: self = .invalidContent(message: message)
        default: return nil
        }
    }
    
    var description: String {
        switch self {
        case .invalidRequestBody(let message):
            return message
        case .invalidToken(let message):
            return message
        case .invalidPathVariable(let message):
            return message
        case .invalidContent(let message):
            return message
        }
    }
}
