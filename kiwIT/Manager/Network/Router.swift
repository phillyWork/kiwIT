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

    //MARK: - Lecture Contents
    case lectureLevelListCheck(request: AuthorizationRequest)
    case lectureLevelListContentCheck(request: LectureLevelContentRequest)
    case startOfLecture(request: HandleLectureRequest)
    case completionOfLecture(request: HandleLectureRequest)
    case exerciseForLecture(request: ExerciseForLectureRequest)
    case lectureCategoryListCheck(request: AuthorizationRequest)
    case lectureCategoryListContentCheck(request: LectureCategoryContentRequest)
    case nextLectureToStudyCheck(request: AuthorizationRequest)
    case completedLectureListCheck(request: CompletedLectureListCheckRequest)
    case bookmarkedLectureCheck(request: BookmarkedLectureCheckRequest)
    case bookmarkLecture(request: HandleLectureRequest)
    
    //MARK: - Quiz
    case quizListCheck(request: QuizGroupListRequest)
    case startTakingQuiz(request: StartQuizRequest)
    case submitQuizAnswers(request: SubmitQuizRequest)
    case latestTakenQuiz(request: AuthorizationRequest)
    case takenQuizListCheck(request: CheckCompletedOrBookmarkedQuizRequest)
    case bookmarkedQuizCheck(request: CheckCompletedOrBookmarkedQuizRequest)
    case bookmarkQuiz(request: BookmarkQuizRequest)
    
    //MARK: - Trophy
    case wholeTrophyList(request: TrophyListRequest)
    case trophyDetail(request: TrophyRequest)
    case acquiredTrophyList(request: TrophyListRequest)
    case latestAcquiredTrophy(request: AuthorizationRequest)
    
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

        case .lectureLevelListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureLevel
        case .lectureLevelListContentCheck(let request):
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureLevel + "/\(request.levelId)"
        case .startOfLecture(let request), .completionOfLecture(let request):
            return Setup.NetworkEndpointStrings.lectureContent + "/\(request.contentId)"
        case .exerciseForLecture(let request):
            return Setup.NetworkEndpointStrings.lectureContent + "/\(request.contentId)" + Setup.NetworkEndpointStrings.exerciseForLecture
        case .lectureCategoryListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureCategory
        case .lectureCategoryListContentCheck(let request):
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureCategory + "/\(request.categoryId)"
        case .nextLectureToStudyCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.lectureNextToStudy
        case .completedLectureListCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.completedLecture
        case .bookmarkedLectureCheck:
            return Setup.NetworkEndpointStrings.lectureContent + Setup.NetworkEndpointStrings.bookmark
        case .bookmarkLecture(let request):
            return Setup.NetworkEndpointStrings.lectureContent + "/\(request.contentId)" + Setup.NetworkEndpointStrings.bookmark
        case .quizListCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList
        case .startTakingQuiz(let request):
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + "/\(request.quizGroupId)"
        case .submitQuizAnswers(let request):
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + "/\(request.quizGroupId)"
        case .latestTakenQuiz:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + Setup.NetworkEndpointStrings.quizMostRecentTaken
        case .takenQuizListCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.quizList + Setup.NetworkEndpointStrings.quizTakenList
        case .bookmarkedQuizCheck:
            return Setup.NetworkEndpointStrings.quiz + Setup.NetworkEndpointStrings.bookmark
        case .bookmarkQuiz(let request):
            return Setup.NetworkEndpointStrings.quiz + "/\(request.quizId)" + Setup.NetworkEndpointStrings.bookmark
        case .wholeTrophyList:
            return Setup.NetworkEndpointStrings.trophy
        case .trophyDetail(let request):
            return Setup.NetworkEndpointStrings.trophy + "/\(request.trophyId)"
        case .acquiredTrophyList:
            return Setup.NetworkEndpointStrings.trophy + Setup.NetworkEndpointStrings.acquiredTrophyList
        case .latestAcquiredTrophy:
            return Setup.NetworkEndpointStrings.trophy + Setup.NetworkEndpointStrings.acquiredTrophyList + Setup.NetworkEndpointStrings.latestAcquiredTrophy
        }
    }
        
    private var header: HTTPHeaders {
        switch self {
        case .signUp, .signIn, .refreshToken:
            return []
        case .signOut(let request), .withdraw(let request), .profileCheck(let request), .lectureLevelListCheck(let request), .lectureCategoryListCheck(let request), .nextLectureToStudyCheck(let request), .latestTakenQuiz(let request), .latestAcquiredTrophy(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .profileEdit(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
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
        case .submitQuizAnswers(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .takenQuizListCheck(let request), .bookmarkedQuizCheck(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .bookmarkQuiz(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .wholeTrophyList(let request), .acquiredTrophyList(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        case .trophyDetail(let request):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: Setup.NetworkStrings.authorizationPrefixHeaderTitle + request.access]
        default:
            return []
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .signUp, .signIn, .completionOfLecture, .submitQuizAnswers, .bookmarkQuiz:
            return .post
        case .signOut, .refreshToken, .profileEdit, .exerciseForLecture, .bookmarkLecture:
            return .patch
        case .withdraw:
            return .delete
        case .profileCheck, .lectureLevelListCheck, .lectureLevelListContentCheck, .startOfLecture, .lectureCategoryListCheck, .lectureCategoryListContentCheck, .nextLectureToStudyCheck, .completedLectureListCheck, .bookmarkedLectureCheck, .quizListCheck, .startTakingQuiz, .latestTakenQuiz, .takenQuizListCheck, .bookmarkedQuizCheck, .wholeTrophyList, .trophyDetail, .acquiredTrophyList, .latestAcquiredTrophy:
            return .get
        default:
            return .get
        }
    }

    //MARK: - element들 String화하기
    private var query: [String: String]? {
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
        case .signOut, .withdraw, .profileCheck, .lectureLevelListCheck, .startOfLecture, .completionOfLecture, .lectureCategoryListCheck, .lectureCategoryListContentCheck, .nextLectureToStudyCheck, .bookmarkLecture, .startTakingQuiz, .submitQuizAnswers, .latestTakenQuiz, .bookmarkQuiz, .trophyDetail, .latestAcquiredTrophy:
            return nil
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
        case .bookmarkedQuizCheck(let request):
            guard let next = request.next, let limit = request.limit else { return nil }
            return [
                Setup.NetworkStrings.queryStringNextPageTitle: "\(next)",
                Setup.NetworkStrings.queryStringLimitPageTitle: "\(limit)"
            ]
        case .wholeTrophyList(let request), .acquiredTrophyList(let request):
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
        case .wholeTrophyList, .acquiredTrophyList, .lectureLevelListContentCheck, .completedLectureListCheck, .bookmarkedLectureCheck, .quizListCheck, .takenQuizListCheck, .bookmarkedQuizCheck:
            request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(query, into: request)
        case .submitQuizAnswers(let submitRequest):
            //request body: answerList Object 자체로 필요
            let parameters = [Setup.NetworkStrings.submitQuizAnswerListTitle: submitRequest.answerList]
            request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(parameters, into: request)
        default:
            //json인 경우
            request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(query, into: request)
        }
        return request
    }
    
}
