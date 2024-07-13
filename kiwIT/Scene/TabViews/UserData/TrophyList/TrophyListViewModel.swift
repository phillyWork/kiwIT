//
//  TrophyListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/18/24.
//

import Foundation

import Combine

final class TrophyListViewModel: ObservableObject {
    
    
    //MARK: - 트로피 관련 API 적용 고민
    //MARK: - 트로피 Post, Delete 기준을 어떻게 잡을 지
    
    //MARK: - 어떤 트로피를 설정할 지...
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("TrophyListViewModel DEINIT")
    }
    
}
