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
    case signOut(access: String)
    case refreshToken(request: RefreshAccessTokenRequest)
    case withdraw(access: String)
    
    //추가 작업 필요 (프로필 확인 추가 필요)
    case acquiredTrophyList
    case mostRecentAcquiredTrophy
    case summaryStat
    
    //MARK: - Lecture Contents
    
    
    
    //MARK: - Quiz
    
    
    
    //MARK: - RequestSetup
    
    private var baseURL: URL {
        return URL(string: APIKey.baseURL)!
    }
    
    private var path: String {
        switch self {
        case .signUp:
            return Setup.NetworkEndpointStrings.userSignUp
        case .signIn:
            return Setup.NetworkEndpointStrings.userSignIn
        case .signOut:
            return Setup.NetworkEndpointStrings.userSignOut
        case .refreshToken:
            return Setup.NetworkEndpointStrings.userRefreshAccessToken
        case .withdraw:
            return Setup.NetworkEndpointStrings.user
            
        case .acquiredTrophyList:
            return ""
        case .mostRecentAcquiredTrophy:
            return ""
        case .summaryStat:
            return ""
            
            
            
        }
    }
    
    private var header: HTTPHeaders {
        switch self {
        case .signUp, .signIn, .refreshToken:
            return []
        case .signOut(let access):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: access]
        case .withdraw(let access):
            return [Setup.NetworkStrings.accessTokenToCheckTitle: access]
        
        case .acquiredTrophyList:
            return []
        case .mostRecentAcquiredTrophy:
            return []
        case .summaryStat:
            return []
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .signUp, .signIn:
            return .post
        case .signOut, .refreshToken:
            return .patch
        case .withdraw:
            return .delete
            
        case .acquiredTrophyList, .mostRecentAcquiredTrophy, .summaryStat:
            return .get
        }
    }
    
    private var body: [String: String] {
        switch self {
        case .signUp(let request):
            return [
                Setup.NetworkStrings.emailTitle: request.email,
                Setup.NetworkStrings.nicknameTitle: request.nickname,
                Setup.NetworkStrings.providerTitle: request.provider
            ]
        case .signIn(let request):
            return [
                Setup.NetworkStrings.accessTokenTitle: request.token,
                Setup.NetworkStrings.providerTitle: request.provider
            ]
        case .signOut:
            return ["": ""]
        case .refreshToken(let request):
            return [Setup.NetworkStrings.refreshTokenTitle: request.refreshToken]
        case .withdraw(let access):
            return ["": ""]
            
        case .acquiredTrophyList:
            return []
        case .mostRecentAcquiredTrophy:
            return []
        case .summaryStat:
            return []
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appending(path: path)
        var request = URLRequest(url: url)
        request.headers = header
        request.method = method
        
        //그 외 header에 json 없거나 multipart/data-form과 같은 경우
//        request = try URLEncodedFormParameterEncoder(destination: .methodDependent).encode(body, into: request)

        //json인 경우
        request = try JSONParameterEncoder(encoder: JSONEncoder()).encode(body, into: request)
        
    }
    
}
