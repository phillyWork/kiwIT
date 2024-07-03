//
//  LectureViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation
import Combine

final class LectureContentListViewModel: ObservableObject {
    
    @Published var lectureContentListLevelType: [LectureContentListPayload] = []
    @Published var lectureContentListCategoryType: [LectureCategoryContentResponse] = []
    
    @Published var shouldLoginAgain = false
    
    @Published var showEmptyView = true
    
    private let dataCountPerRequestForLevelContentRequest = 15
    private var currentDataForLevelContentRequest = 0
    private var canLoadMoreData = true
    
    private var cancellables = Set<AnyCancellable>()
    
    var typeId: Int
    var navTitle: String
    
    init(typeId: Int, navTitle: String, lectureType: LectureListType) {
        self.typeId = typeId
        self.navTitle = navTitle
        print("About to call request content data!!!")
        requestContentData(lectureType, typeId: typeId)
    }
    
    func requestContentData(_ type: LectureListType, typeId: Int) {
        print("Check Token Data in LectureContentListViewModel")
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        requestContentLayer(tokenData.0, userId: tokenData.1, type: type, typeId: typeId)
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
                if case .failure(let error) = completion {
                    if let categoryContentError = error as? NetworkError {
                        switch categoryContentError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId, contentType: .category, typeId: categoryId)
                        default:
                            print("Category Content Error: \(categoryContentError.description)")
                            self.showEmptyView = true
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        self.showEmptyView = true
                    }
                }
            } receiveValue: { response in
                print("Response for Getting this category content data list: \(response)")
                self.lectureContentListCategoryType.append(contentsOf: response)
                self.showEmptyView = false
            }
            .store(in: &self.cancellables)
    }
    
    private func requestLevelTypeContent(_ token: UserTokenValue, userId: String, levelNum: Int) {
        NetworkManager.shared.request(type: [LectureContentListPayload].self, api: .lectureLevelListContentCheck(request: LectureLevelContentRequest(levelId: levelNum, access: token.access, next: currentDataForLevelContentRequest, limit: dataCountPerRequestForLevelContentRequest)), errorCase: .lectureLevelListContentCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let levelContentError = error as? NetworkError {
                        switch levelContentError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId, contentType: .category, typeId: levelNum)
                        default:
                            print("Category Content Error: \(levelContentError.description)")
                            if self.lectureContentListLevelType.isEmpty {
                                //pagination 실패 경우 처리
                                self.showEmptyView = true
                            }
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        if self.lectureContentListLevelType.isEmpty {
                            self.showEmptyView = true
                        }
                    }
                }
            } receiveValue: { response in
                print("Response for Getting this Level Data content list: \(response)")
                self.lectureContentListLevelType.append(contentsOf: response)
                self.canLoadMoreData = response.count >= self.dataCountPerRequestForLevelContentRequest
                self.showEmptyView = false
            }
            .store(in: &self.cancellables)
    }
    
    func loadMoreContentListLevelType() {
        guard canLoadMoreData else { return }
        print("About to Load More Level Content!!!")
        currentDataForLevelContentRequest += 1
        requestContentData(.level, typeId: typeId)
    }
    
    //MARK: - Refresh Token 어디서나 동일 작업 But 후속 조치가 viewmodel마다 달라짐...
    //MARK: - 공통 함수로 처리, 결과물 publish 하도록 처리?
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String, contentType: LectureListType, typeId: Int) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.shouldLoginAgain = true
                        default:
                            print("Refresh Token Error for network reason: \(refreshError.description)")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.shouldLoginAgain = true
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        self.shouldLoginAgain = true
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self.requestContentLayer(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), userId: userId, type: contentType, typeId: typeId)
            }
            .store(in: &self.cancellables)
    }
    
}
