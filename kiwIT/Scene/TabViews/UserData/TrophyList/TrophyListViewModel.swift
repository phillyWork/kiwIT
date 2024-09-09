//
//  TrophyListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/18/24.
//

import Foundation

import Combine

enum TrophyActionType {
    case wholeTrophyList
    case acquiredTrophyList
}

final class TrophyListViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = TrophyActionType
    
    @Published var shouldLoginAgain = false
    
    @Published var showWholeTrophyRequestErrorAlert = false
    @Published var showAcquiredTrophyRequestErrorAlert = false
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var wholeTrophyList: [TrophyEntity] = []
    @Published var acquiredTrophyList: [AcquiredTrophy] = []
    
    private let requestToRefreshSubject = PassthroughSubject<Void, Never>()
    
    private let dispatchGroup = DispatchGroup()
    
    private let dataPerTrophyRequest = 30
    private var currentPageForWholeTrophy = 0
    private var currentPageForAcquiredTrophy = 0
    
    private var canLoadMoreWholeTrophy = true
    private var canLoadMoreAcquiredTrophy = true
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
        dispatchGroupRequest()
    }
    
    private func bind() {
        requestToRefreshSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.handleRefreshRequest()
            }
            .store(in: &cancellables)
    }
    
    func debouncedRefreshRequest() {
        requestToRefreshSubject.send(())
    }
    
    func checkToLoadMoreTrophyies(_ trophy: TrophyEntity) {
        if wholeTrophyList.last == trophy {
            loadMoreTrophy()
        }
    }
    
    private func handleRefreshRequest() {
        wholeTrophyList.removeAll()
        currentPageForWholeTrophy = 0
        canLoadMoreWholeTrophy = true
        acquiredTrophyList.removeAll()
        currentPageForAcquiredTrophy = 0
        canLoadMoreAcquiredTrophy = true
        dispatchGroupRequest()
    }
    
    private func dispatchGroupRequest() {
        requestWholeTrophyList()
        dispatchGroup.notify(queue: .main) {
            if !self.wholeTrophyList.isEmpty {
                self.requestAcquiredTrophyList()
            }
        }
    }
    
    private func requestWholeTrophyList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = false
            return
        }
        dispatchGroup.enter()
        NetworkManager.shared.request(type: [TrophyEntity].self, api: .wholeTrophyList(request: TrophyListRequest(access: tokenData.0.access, next: currentPageForWholeTrophy, limit: dataPerTrophyRequest)), errorCase: .wholeTrophyList)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let wholeTrophyError = error as? NetworkError {
                        switch wholeTrophyError {
                        case .invalidRequestBody(_):
                            self?.showWholeTrophyRequestErrorAlert = true
                            self?.dispatchGroup.leave()
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .wholeTrophyList)
                        default:
                            self?.showWholeTrophyRequestErrorAlert = true
                            self?.dispatchGroup.leave()
                        }
                    } else {
                        self?.showWholeTrophyRequestErrorAlert = true
                        self?.dispatchGroup.leave()
                    }
                }
            } receiveValue: { response in
                self.wholeTrophyList.append(contentsOf: response)
                self.canLoadMoreWholeTrophy = response.count >= self.dataPerTrophyRequest
                self.dispatchGroup.leave()
            }
            .store(in: &self.cancellables)
    }
    
    private func loadMoreTrophy() {
        guard canLoadMoreWholeTrophy else { return }
        currentPageForWholeTrophy += 1
        requestWholeTrophyList()
    }
    
    private func requestAcquiredTrophyList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = false
            return
        }
        NetworkManager.shared.request(type: [AcquiredTrophy].self, api: .acquiredTrophyList(request: TrophyListRequest(access: tokenData.0.access, next: currentPageForAcquiredTrophy, limit: dataPerTrophyRequest)), errorCase: .acquiredTrophyList)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let acquiredTrophyError = error as? NetworkError {
                        switch acquiredTrophyError {
                        case .invalidRequestBody(_):
                            self?.showAcquiredTrophyRequestErrorAlert = true
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .acquiredTrophyList)
                        default:
                            self?.showAcquiredTrophyRequestErrorAlert = true
                        }
                    } else {
                        self?.showAcquiredTrophyRequestErrorAlert = true
                    }
                }
            } receiveValue: { response in
                self.acquiredTrophyList.append(contentsOf: response)
                self.canLoadMoreAcquiredTrophy = response.count >= self.dataPerTrophyRequest
                self.loadMoreAcquiredTrophy()
            }
            .store(in: &self.cancellables)
    }
    
    private func loadMoreAcquiredTrophy() {
        guard canLoadMoreAcquiredTrophy else { return }
        currentPageForAcquiredTrophy += 1
        requestAcquiredTrophyList()
    }
    
    func checkWhetherAcquired(_ trophy: TrophyEntity) -> Bool {
        return acquiredTrophyList.map { $0.id }.contains(trophy.id)
    }
    
    func retrieveAcquiredDate(_ trophy: TrophyEntity) -> String {
        let acquired = acquiredTrophyList.filter { $0.id == trophy.id }
        return acquired.isEmpty ? "" : acquired.map { $0.creationCompactDate }.joined()
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: TrophyActionType) {
        switch action {
        case .wholeTrophyList:
            requestWholeTrophyList()
        case .acquiredTrophyList:
            requestAcquiredTrophyList()
        }
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
    }
    
    deinit {
        print("TrophyListViewModel DEINIT")
    }
    
}
