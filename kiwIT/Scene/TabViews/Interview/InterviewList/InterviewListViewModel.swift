//
//  AIInterviewViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/17/24.
//

import Foundation

import Combine

enum InterviewListActionType {
    case loadCreatedInterviews
    case createNewInterview
    case deleteInterview
}

final class InterviewListViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = InterviewListActionType
    
    @Published var shouldLoginAgain = false

    @Published var showLoadingInterviewListErrorAlert = false
    @Published var showCreateNewInterviewErrorAlert = false
    @Published var showDeleteInterviewErrorAlert = false
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var showCreateNewInterviewSheet = false
    @Published var showNewlyCreatedInterview = false
    
    //data to show interviewlist --> pass interviewId for selected interview
    
    private let loadInterviewSubject = PassthroughSubject<Void, Never>()
    private let createInterviewSubject = PassthroughSubject<CreateInterviewContent, Never>()
    
    private var debouncedCreateInterviewContent = CreateInterviewContent(topic: "", numOfQuestions: 0, expectedTotalAnswerTime: 0, shouldBeIncludedString: "")

    private var userProfile: ProfileResponse?
    private var currentOffsetToDelete: IndexSet?
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ profile: ProfileResponse?) {
        self.userProfile = profile
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
    
    func debouncedCreateInterview(_ content: CreateInterviewContent) {
        showCreateNewInterviewSheet = false
        debouncedCreateInterviewContent = content
        createInterviewSubject.send(content)
    }
    
    private func requestInterviewList() {
        //MARK: - 유저가 생성한 인터뷰 목록 가져오기
        
    }
    
    private func requestCreateInterview(_ content: CreateInterviewContent) {
        
        //MARK: - 인터뷰 생성 요청
        
        //MARK: - 고려할 점: 실제로 데이터 만들어질 시, 0번 Index에 넣을 것: 유저가 처음 알아보도록
        
        //MARK: - 성공 시, InterviewHistoryView로 이동할 것 by update showNewlyCreatedInterview

        
        
    }
    
    
    private func resetDataToRefresh() {
        //MARK: - 당겨서 새로고침: 기존 데이터 삭제 후 네트워크로 다시 불러오기
        
        requestInterviewList()
    }
    
    func deleteItems(at offsets: IndexSet) {
        print("swipe to delete")
        
        currentOffsetToDelete = offsets
                
        //MARK: - 화면 상으로는 삭제, 데이터 상으로 삭제 필요
        
        //.remove(atOffsets: offsets)
        
        
        if true {
            print("Cannot delete data!!")
        }

        
        
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewListActionType) {
        switch action {
        case .loadCreatedInterviews:
            requestInterviewList()
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
