//
//  LectureViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation
import Combine

final class LectureContentListViewModel: ObservableObject {
        
    //MARK: - Debounce 설정 필요
    
    @Published var lectureContentListLevelType: [LectureContentListPayload] = []
    @Published var lectureContentListCategoryType: [LectureCategoryContentResponse] = []
    
    @Published var isLoginAvailable = false
    
    //MARK: - 에러 처리 위한 방안? 빈 화면?
    @Published var showEmptyView = false
    
    private let dataCountPerRequestForLevelContentRequest = 4
    private var currentDataForLevelContentRequest = 0
    private var canLoadMoreData = true
    
    private var cancellables = Set<AnyCancellable>()

    var typeId: Int
    var navTitle: String
    
    init(typeId: Int, navTitle: String, lectureType: LectureListType) {
        self.typeId = typeId
        self.navTitle = navTitle
        print("About to call request content data!!!")
        self.requestContentData(lectureType, typeId: typeId)
    }
    
    func requestContentData(_ type: LectureListType, typeId: Int) {
        print("Check Token Data in LectureContentListViewModel")
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            isLoginAvailable = false
            return
        }
        requestContentLayer(tokenData.0, userId: tokenData.1, type: type, typeId: typeId)
    }
    
    func loadMoreContentListLevelType() {
        guard canLoadMoreData else { return }
        print("About to Load More Level Content!!!")
        currentDataForLevelContentRequest += 1
        requestContentData(.level, typeId: typeId)
    }
    
    private func requestContentLayer(_ tokenData: UserTokenValue, userId: String, type: LectureListType, typeId: Int) {
        switch type {
        case .category:
            requestCategoryTypeContent(tokenData, userId: userId, categoryId: typeId)
        case .level:
            requestLevelTypeContent(tokenData, userId: userId, levelNum: typeId)
        }
    }
    
    private func requestCategoryTypeContent(_ token: UserTokenValue, userId: String, categoryId: Int) {
        NetworkManager.shared.request(type: [LectureCategoryContentResponse].self, api: .lectureCategoryListContentCheck(request: LectureCategoryContentRequest(categoryId: categoryId, access: token.access)), errorCase: .lectureCategoryListContentCheck)
            .sink { completion in
               
                //MARK: - 콘텐츠 리스트 가져오기 에러 처리?
                
                if case .failure(let error) = completion {
                    if let categoryContentError = error as? NetworkError {
                        switch categoryContentError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId, type: .category, typeId: categoryId)
                        case .invalidPathVariable(_):
                            print("Category Content Error for No Category: \(categoryContentError.description)")
                            
                        default:
                            print("Category Content Error: \(categoryContentError.description)")
                            
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        
                    }
                }
            } receiveValue: { response in
                print("Response for Getting this category content data list: \(response)")
                self.lectureContentListCategoryType.append(contentsOf: response)
            }
            .store(in: &self.cancellables)
    }
    
    private func requestLevelTypeContent(_ token: UserTokenValue, userId: String, levelNum: Int) {
        NetworkManager.shared.request(type: [LectureContentListPayload].self, api: .lectureLevelListContentCheck(request: LectureLevelContentRequest(levelId: levelNum, access: token.access, next: currentDataForLevelContentRequest, limit: dataCountPerRequestForLevelContentRequest)), errorCase: .lectureLevelListContentCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    
                    //MARK: - 콘텐츠 리스트 가져오기 에러 처리?
                    
                    if let levelContentError = error as? NetworkError {
                        switch levelContentError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId, type: .category, typeId: levelNum)
                        case .invalidPathVariable(_):
                            print("Category Content Error for No Category: \(levelContentError.description)")
                            
                        default:
                            print("Category Content Error: \(levelContentError.description)")
                            
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                    }
                }
            } receiveValue: { response in
                print("Response for Getting this Level Data content list: \(response)")
                self.lectureContentListLevelType.append(contentsOf: response)
                self.canLoadMoreData = response.count >= self.dataCountPerRequestForLevelContentRequest
            }
            .store(in: &self.cancellables)
    }
    
    //MARK: - Refresh Token 어디서나 동일 작업 But 후속 조치가 viewmodel마다 달라짐...
    //MARK: - 공통 함수로 처리, 결과물 publish 하도록 처리?
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String, type: LectureListType, typeId: Int) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.isLoginAvailable = false
                        default: 
                            print("Refresh Token Error for network reason: \(refreshError.description)")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.isLoginAvailable = false
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        self.isLoginAvailable = false
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self.requestContentLayer(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), userId: userId, type: type, typeId: typeId)
            }
            .store(in: &self.cancellables)
    }
   
}
