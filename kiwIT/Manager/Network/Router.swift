//
//  Router.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

import Alamofire

enum Router: URLRequestConvertible {
    
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

    //MARK: - 누적 통계 필요???
    case summaryStat
        
    //MARK: - Lecture Contents
    case lectureLevelListCheck(request: AuthorizationRequest)
    case lectureLevelListContentCheck(request: LectureLevelContentRequest)
    case startOfLecture(request: HandleLectureRequest)
    case completionOfLecture(request: HandleLectureRequest)
    case exerciseForLecture(request: ExerciseForLectureRequest)
    case lectureCategoryListCheck(request: AuthorizationRequest)
    case lectureCategoryListContentCheck(request: LectureCategoryContentRequest)
    case lectureNextStudyProgress(request: AuthorizationRequest)
    case completedLectureListCheck(request: CompletedLectureListCheckRequest)
    case bookmarkedLectureCheck(request: BookmarkedLectureCheckRequest)
    case bookmarkLecture(request: HandleLectureRequest)
    
    //MARK: - Quiz
    case quizListCheck(request: QuizGroupListRequest)
    case startTakingQuiz(request: StartQuizRequest)
    case submitQuizAnswers(request: SubmitQuizRequest)
    case submitQuizAnswersNTimes(request: SubmitQuizRequest)
    case mostRecentlyTakenQuiz(request: AuthorizationRequest)
    case takenQuizListCheck(request: CheckCompletedOrBookmarkedQuizRequest)
    case bookmarkedQuizCheck(request: CheckCompletedOrBookmarkedQuizRequest)
    case bookmarkQuiz(request: BookmarkQuizRequest)
    
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
        case .lectureLevelListContentCheck(let request):
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureLevel + "/:\(request.levelId)"
        case .startOfLecture(let request), .completionOfLecture(let request):
            return Setup.NetworkEndpointStrings.lectureContent + "/:\(request.contentId)"
        case .exerciseForLecture(let request):
            return Setup.NetworkEndpointStrings.lectureContent + "/:\(request.contentId)" + Setup.NetworkEndpointStrings.exerciseForLecture
        case .lectureCategoryListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureCategory
        case .lectureCategoryListContentCheck(let request):
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureCategory + "/:\(request.categoryId)"
        case .lectureNextStudyProgress:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureNextStudyProgress
        case .completedLectureListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.completedLecture
        case .bookmarkedLectureCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.bookmark
        case .bookmarkLecture(let request):
            return Setup.NetworkEndpointStrings.lectureContent + "/:\(request.contentId)" + Setup.NetworkEndpointStrings.bookmark
        case .quizListCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList
        case .startTakingQuiz(let request):
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + "/:\(request.quizGroupId)"
        case .submitQuizAnswers(let request), .submitQuizAnswersNTimes(let request):
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + "/:\(request.quizGroupId)"
        case .mostRecentlyTakenQuiz:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + Setup.NetworkEndpointStrings.quizMostRecentTaken
        case .takenQuizListCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + Setup.NetworkEndpointStrings.quizTakenList
        case .bookmarkedQuizCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.bookmark
        case .bookmarkQuiz(let request):
            return Setup.NetworkEndpointStrings.quiz + "/:\(request.quizId)" + Setup.NetworkEndpointStrings.bookmark
        }
    }
        
    private var header: HTTPHeaders {
        switch self {
        case .signUp, .signIn, .refreshToken:
            return []
        case .signOut(let request), .withdraw(let request), .profileCheck(let request), .lectureLevelListCheck(let request), .lectureCategoryListCheck(let request), .lectureNextStudyProgress(let request), .mostRecentlyTakenQuiz(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .acquiredTrophyList(let request), .mostRecentAcquiredTrophy(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .profileEdit(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .summaryStat:
            return []
        case .lectureLevelListContentCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .startOfLecture(let request), .completionOfLecture(let request), .bookmarkLecture(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .exerciseForLecture(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .lectureCategoryListContentCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .completedLectureListCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .bookmarkedLectureCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .quizListCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .startTakingQuiz(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .submitQuizAnswers(let request), .submitQuizAnswersNTimes(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .takenQuizListCheck(let request), .bookmarkedQuizCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .bookmarkQuiz(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        default:
            return []
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .signUp, .signIn, .completionOfLecture, .submitQuizAnswers:
            return .post
        case .signOut, .refreshToken, .profileEdit, .exerciseForLecture, .bookmarkLecture, .submitQuizAnswersNTimes, .bookmarkQuiz:
            return .patch
        case .withdraw:
            return .delete
        case .profileCheck, .acquiredTrophyList, .mostRecentAcquiredTrophy, .summaryStat, .lectureLevelListCheck, .lectureLevelListContentCheck, .startOfLecture, .lectureCategoryListCheck, .lectureCategoryListContentCheck, .lectureNextStudyProgress, .completedLectureListCheck, .bookmarkedLectureCheck, .quizListCheck, .startTakingQuiz, .mostRecentlyTakenQuiz, .takenQuizListCheck, .bookmarkedQuizCheck:
            return .get
        default:
            return .get
        }
    }

    //MARK: - element들 String화하기
    
    private var body: [String: String]? {
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
        case .exerciseForLecture(let request):
            return [Setup.NetworkStrings.lectureExerciseAnswerTitle: "\(request.answer)"]
        case .submitQuizAnswers(let request), .submitQuizAnswersNTimes(let request):
            return [Setup.NetworkStrings.submitQuizAnswerListTitle: "\(request.answerList)"]
        case .signOut, .withdraw, .profileCheck, .mostRecentAcquiredTrophy, .lectureLevelListCheck, .startOfLecture, .completionOfLecture, .lectureCategoryListCheck, .lectureCategoryListContentCheck, .lectureNextStudyProgress, .bookmarkLecture, .startTakingQuiz, .mostRecentlyTakenQuiz, .bookmarkedQuizCheck, .bookmarkQuiz:
            return nil
        case .summaryStat:
            return nil
        case .acquiredTrophyList(let request):
            guard let next = request.next, let limit = request.limit else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)"
            ]
        case .lectureLevelListContentCheck(let request):
            guard let next = request.next, let limit = request.limit else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)"
            ]
        case .completedLectureListCheck(let request):
            guard let next = request.next, let limit = request.limit, let byLevel = request.byLevel else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)",
                Setup.NetworkStrings.queryStringByLevelTitle: "\(byLevel)"
            ]
        case .bookmarkedLectureCheck(let request):
            guard let next = request.next, let limit = request.limit else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)"
            ]
        case .quizListCheck(let request):
            guard let next = request.next, let limit = request.limit, let tag = request.tag else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)",
                Setup.NetworkStrings.queryStringTagTitle: "\(tag)"
            ]
        case .takenQuizListCheck(let request):
            guard let next = request.next, let limit = request.limit else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)"
            ]
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
        case .acquiredTrophyList, .lectureLevelListCheck, .completionOfLecture, .bookmarkedLectureCheck, .quizListCheck, .takenQuizListCheck:
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(body, into: request)
        default:
            //json인 경우
            request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(body, into: request)
        }
        return request
    }
    
}
