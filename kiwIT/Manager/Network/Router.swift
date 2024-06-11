//
//  Router.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

import Alamofire

enum Router: URLRequestConvertible {
    
    //의문: request type은 다르지만 사실상 내부 내용물 동일할 경우 타입 동일화 Or 각자 케이스 구분?
    
    //MARK: - User
    case signUp(request: SignUpRequest)
    case signIn(request: SignInRequest)
    case signOut(request: AuthorizationRequest)
    case refreshToken(request: RefreshAccessTokenRequest)
    case withdraw(request: AuthorizationRequest)
    case profileCheck(request: AuthorizationRequest)
    case profileEdit(request: ProfileEditRequest)
    case acquiredTrophyList(request: TrophyRequest)
    case mostRecentAcquiredTrophy(request: TrophyRequest)

    //누적 통계 필요?
    case summaryStat
    
    //MARK: - Lecture Contents
    
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
    
    //MARK: - Quiz
    
    case quizListCheck
    case startTakingQuiz
    case submitQuizAnswers
    case submitQuizAnswersNTimes
    case mostRecentTakenQuiz
    case takenQuizListCheck
    case bookmarkedQuizCheck
    case bookmarkQuiz
    
    //MARK: - RequestSetup
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    //request id: db 바로 접근 못하게 처리, path 처리 동일 (jwt 토큰으로 verify하고 파악하기 때문)
    //id 받아올 필요 있음
    private var path: String {
        switch self {
        case .signUp:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userSignUp
        case .signIn:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userSignIn
        case .signOut:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userSignOut
        case .refreshToken:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userRefreshAccessToken
        case .withdraw, .profileCheck, .profileEdit:
            return Setup.NetworkEndpointStrings.user
        case .acquiredTrophyList:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userAcquiredTrophyList
        case .mostRecentAcquiredTrophy:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userAcquiredTrophyList + Setup.NetworkEndpointStrings.userRecentAcquiredTrophy
        case .summaryStat:
            return Setup.NetworkEndpointStrings.user + Setup.NetworkEndpointStrings.userSummaryStat
        case .lectureLevelListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureLevel
        case .lectureLevelListContentCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureLevel + "/:id"
        case .startOfLecture, .completionOfLecture:
            return Setup.NetworkEndpointStrings.lectureContent + "/:id"
        case .exerciseForLecture:
            return Setup.NetworkEndpointStrings.lectureContent + "/:id" + Setup.NetworkEndpointStrings.exerciseForLecture
        case .lectureCategoryListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureCategory
        case .lectureCategoryListContentCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureCategory + "/:id"
        case .lectureNextStudyProgress:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureNextStudyProgress
        case .completedLectureListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.completedLecture
        case .bookmarkedLectureCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.bookmark
        case .bookmarkLecture:
            return Setup.NetworkEndpointStrings.lectureContent + "/:id" + Setup.NetworkEndpointStrings.bookmark
        case .quizListCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList
        case .startTakingQuiz, .submitQuizAnswers, .submitQuizAnswersNTimes:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + "/:id"
        case .mostRecentTakenQuiz:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + Setup.NetworkEndpointStrings.quizMostRecentTaken
        case .takenQuizListCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + Setup.NetworkEndpointStrings.quizTakenList
        case .bookmarkedQuizCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.bookmark
        case .bookmarkQuiz:
            return Setup.NetworkEndpointStrings.quiz + "/:id" + Setup.NetworkEndpointStrings.bookmark
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .signUp, .signIn, .refreshToken:
            return []
        case .signOut(let request), .withdraw(let request), .profileCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .acquiredTrophyList(let request), .mostRecentAcquiredTrophy(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .profileEdit(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .summaryStat:
            return []






        default:
            return []
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .signUp, .signIn:
            return .post
        case .signOut, .refreshToken, .profileEdit:
            return .patch
        case .withdraw:
            return .delete
        case .profileCheck, .acquiredTrophyList, .mostRecentAcquiredTrophy, .summaryStat:
            return .get



        default:
            return .get
        }
    }
    
    private var body: [String: String] {
        switch self {
        case .signUp(let request):
            return [
                Setup.NetworkStrings.emailTitle: request.email,
                Setup.NetworkStrings.nicknameTitle: request.nickname,
                Setup.NetworkStrings.providerTitle: request.provider.rawValue
            ]
        case .signIn(let request):
            return [
                Setup.NetworkStrings.accessTokenTitle: request.token,
                Setup.NetworkStrings.providerTitle: request.provider.rawValue
            ]
        case .refreshToken(let request):
            return [Setup.NetworkStrings.refreshTokenTitle: request.refreshToken]
        case .profileEdit(let request):
            return [Setup.NetworkStrings.nicknameTitle: request.nickname]
        case .signOut, .withdraw, .profileCheck, .mostRecentAcquiredTrophy, .acquiredTrophyList:
            return ["": ""]
            
        //Pagination 활용 목적
//        case .acquiredTrophyList(let request):
//            if let next = request.next, let limit = request.limit {
//                return [
//                    Setup.NetworkStrings.trophyNextPageQueryTitle: next,
//                    Setup.NetworkStrings.trophyLimitPageQueryTitle: limit
//                ]
//            } else {
//                return ["": ""]
//            }
            
        case .summaryStat:
            return ["": ""]
            
            
        default:
            return ["": ""]
        }
    }
    
    //Pagination 활용 목적
    private var parameters: [String: Int]? {
        switch self {
        case .acquiredTrophyList(let request):
            if let next = request.next, let limit = request.limit {
                return [
                    Setup.NetworkStrings.trophyNextPageQueryTitle: next,
                    Setup.NetworkStrings.trophyLimitPageQueryTitle: limit
                ]
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appending(path: path)
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
                
        switch self {
            //header에 json 없거나 multipart/data-form과 같은 경우
        case .acquiredTrophyList:
            
//            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(body, into: request)
            
            if let parameters = parameters {
                request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(parameters, into: request)
            } else {
                request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(body, into: request)
            }
        default:
            //json인 경우
            request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(body, into: request)
        }
        
        return request
    }
    
}
