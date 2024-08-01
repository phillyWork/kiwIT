//
//  LectureViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation
import Combine

enum LectureContentListActionType {
    case contentList
}

final class LectureContentListViewModel: ObservableObject, RefreshTokenHandler {

    typealias ActionType = LectureContentListActionType
    
    @Published var lectureContentListLevelType: [LectureContentListPayload] = []
    @Published var lectureContentListCategoryType: [LectureCategoryContentResponse] = []
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var showEmptyView = true
    
    private let dataCountPerRequestForLevelContentRequest = 15
    private var currentDataForLevelContentRequest = 0
    private var canLoadMoreData = true
    
    var cancellables = Set<AnyCancellable>()
    
    var typeId: Int
    var navTitle: String
    var lectureListType: LectureListType
    
    init(typeId: Int, navTitle: String, lectureType: LectureListType) {
        self.typeId = typeId
        self.navTitle = navTitle
        self.lectureListType = lectureType
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
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let categoryContentError = error as? NetworkError {
                        switch categoryContentError {
                        case .invalidToken(_):
                            self?.requestRefreshToken(token, userId: userId, action: .contentList)
                        default:
                            print("Category Content Error: \(categoryContentError.description)")
                            self?.showEmptyView = true
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        self?.showEmptyView = true
                    }
                }
            } receiveValue: { [weak self] response in
                print("Response for Getting this category content data list: \(response)")
                self?.lectureContentListCategoryType.append(contentsOf: response)
                self?.showEmptyView = false
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
                            self.requestRefreshToken(token, userId: userId, action: .contentList)
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
    
    func checkMorePaginationNeeded(_ item: LectureContentListPayload) {
        print("Check data for pagination!!!")
        if lectureContentListLevelType.last == item {
            print("Last data for list: should call more!!!")
            loadMoreContentListLevelType()
        }
    }
    
    private func loadMoreContentListLevelType() {
        guard canLoadMoreData else { return }
        print("About to Load More Level Content!!!")
        currentDataForLevelContentRequest += 1
        requestContentData(.level, typeId: typeId)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: LectureContentListActionType) {
        requestContentLayer(response, userId: userId, type: lectureListType, typeId: typeId)
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            shouldLoginAgain = true
        } else {
            showUnknownNetworkErrorAlert = true
        }
    }
        
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("LectureContentListViewModel DEINIT")
    }
    
}
