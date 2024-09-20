//
//  AIInterviewViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/17/24.
//

import Foundation

import Combine

import Alamofire

enum InterviewListActionType {
    case loadCreatedInterviews
    case loadNewInterviewOptions
    case checkPolling
    case createNewInterview
    case deleteInterview
}

//MARK: - GPT 요청 다수 부담 트래픽 처리 위한 Polling 처리 필요
//MARK: - sheet로 생성 옵션 선택 후 Request로 대기열 처리: 대기열 화면 보여줄 처리 필요
//MARK: - 지속적 처리 ~ 대기열 해소 ~ 그 때 sheet 내리기

final class InterviewListViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = InterviewListActionType
    
    @Published var shouldLoginAgain = false

    @Published var showLoadingInterviewListErrorAlert = false
    @Published var showCreateNewInterviewErrorAlert = false
    @Published var showDeleteInterviewErrorAlert = false
    @Published var showUnknownNetworkErrorAlert = false
    @Published var showRetrieveInterviewOptionErrorAlert = false
    
    @Published var showCreateNewInterviewSheet = false
    @Published var showNewlyCreatedInterview = false
    
    @Published var interviewList: [InterviewPayload] = []
    
    @Published var optionCategory: [LectureCategoryListPayload] = []
    @Published var optionLevel: [LectureLevelListPayload] = []
    
    private let loadInterviewSubject = PassthroughSubject<Void, Never>()
    private let selectedInterviewIdSubject = PassthroughSubject<Int, Never>()
    private let setupInterviewCreateSheetSubject = PassthroughSubject<Void, Never>()
    private let createInterviewSubject = PassthroughSubject<CreateInterviewContent, Never>()
    
    private let dataPerInterviewListPage = 30
    private var currentPageForInterviewList = 0
    private var canLoadMoreInterviewList = true
    
    private var debouncedCreateInterviewContent = CreateInterviewContent(title: "", categoryId: -1, levelNum: -1, timeLimit: -1, etcRequest: "", questionsCnt: -1)
    private var currentOffsetToDelete: IndexSet?
    
    var selectedId = -1
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        bind()
        requestInterviewList()
    }
    
    private func bind() {
        loadInterviewSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.resetDataToRefresh()
            }
            .store(in: &self.cancellables)
        
        selectedInterviewIdSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink(receiveValue: { [weak self] id in
                self?.selectedId = id
            })
            .store(in: &self.cancellables)
        
        setupInterviewCreateSheetSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.setupInterviewCreateSheet()
            }
            .store(in: &self.cancellables)
        
        createInterviewSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] content in
                self?.requestCreateInterview(content)
            }
            .store(in: &self.cancellables)
    }
    
    func debouncedRefreshInterview() {
        loadInterviewSubject.send(())
    }
    
    func debouncedSelectedInterviewId(_ id: Int) {
        selectedInterviewIdSubject.send(id)
    }
    
    func debouncedSetupCreateInterviewSheet() {
        setupInterviewCreateSheetSubject.send(())
    }
    
    func debouncedCloseSheet() {
        showCreateNewInterviewSheet = false
    }
    
    func debouncedCreateInterview(_ content: CreateInterviewContent) {
        showCreateNewInterviewSheet = false
        debouncedCreateInterviewContent = content
        createInterviewSubject.send(content)
    }
    
    private func requestInterviewList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: InterviewListResponse.self, api: .interviewList(request: InterviewListRequest(access: tokenData.0.access, next: currentPageForInterviewList, limit: dataPerInterviewListPage)), errorCase: .interviewList)
            .sink { completion in
                if case .failure(let error) = completion {
                    
                }
            } receiveValue: { response in
                self.interviewList.append(contentsOf: response.interviewList)
                
            }
            .store(in: &self.cancellables)
    }
    
    private func setupInterviewCreateSheet() {
        showCreateNewInterviewSheet = true
        requestInterviewOptions()
    }
    
    private func requestInterviewOptions() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: CreateInterviewOptionResponse.self, api: .interviewOptionList(request: AuthorizationRequest(access: tokenData.0.access)), errorCase: .interviewOptionList)
            .sink { completion in
                
                //MARK: - 싪패 시: 닫는 alert 띄우기 (showRetrieveInterviewOptionErrorAlert = true)

                if case .failure(let error) = completion {
                    
                }
            } receiveValue: { response in
                
                //MARK: - 성공 시, 해당 data로 전달하기
                
            }
            .store(in: &self.cancellables)
    }
    
    private func requestCreateInterview(_ content: CreateInterviewContent) {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        
        //MARK: - 인터뷰 생성 요청
        NetworkManager.shared.request(type: InterviewPayload.self, api: .createInterview(request: CreateInterviewRequest(access: tokenData.0.access, content: content)), errorCase: .createInterview)
            .sink { completion in
                
                
                
            } receiveValue: { response in
             
                //MARK: - 성공 시, response에서 어떻게 오는지 확인 필요 (with polling)
                
                //MARK: - 고려할 점: 실제로 데이터 만들어질 시, 0번 Index에 넣을 것: 유저가 처음 알아보도록

                //MARK: - 성공 시, InterviewHistoryView로 이동할 것 by update showNewlyCreatedInterview (w/o polling)
                
            }
            .store(in: &self.cancellables)
    }
    
    //MARK: - GPT 생성 요청 과도화 부담 줄이기 목적, 구현은 서버 구현 이후 차후에 작성하기
    private func requestCheckPolling() {
        
    }
    
    
    private func resetDataToRefresh() {
        interviewList.removeAll()
        optionCategory.removeAll()
        optionLevel.removeAll()
        
        showCreateNewInterviewSheet = false
        
        currentPageForInterviewList = 0
        canLoadMoreInterviewList = true
        
        debouncedCreateInterviewContent = CreateInterviewContent(title: "", categoryId: -1, levelNum: -1, timeLimit: -1, etcRequest: "", questionsCnt: -1)
        selectedId = -1
        
        requestInterviewList()
    }
    
    func deleteItems(at offsets: IndexSet) {
        print("swipe to delete")
        
        currentOffsetToDelete = offsets
                
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        
        offsets.forEach { index in
            let id = interviewList[index].id
            
            NetworkManager.shared.request(type: Empty.self, api: .deleteInterview(request: BasicInterviewRequest(access: tokenData.0.access, interviewId: id)), errorCase: .deleteInterview)
                .sink { completion in
                    //MARK: - 실패 시: 에러 표시하기
                    
                } receiveValue: { response in
                    //MARK: - 성공 시, 앱단 데이터에서도 삭제하기
                    self.interviewList.removeAll { $0.id == id }
                    
                }
                .store(in: &self.cancellables)
        }
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewListActionType) {
        switch action {
        case .loadCreatedInterviews:
            requestInterviewList()
        case .loadNewInterviewOptions:
            requestInterviewOptions()
        case .checkPolling:
            requestCheckPolling()
        case .createNewInterview:
            requestCreateInterview(debouncedCreateInterviewContent)
        case .deleteInterview:
            if let offset = currentOffsetToDelete {
                deleteItems(at: offset)
            }
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
    
    deinit {
        print("InterviewViewModel DEINIT")
    }
}
