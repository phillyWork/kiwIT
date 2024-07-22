//
//  UserSubscriptionViewModel.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import Foundation

import Combine
import StoreKit

enum SubscriptionAction {
    case receiptVerification
}

final class UserSubscriptionViewModel: ObservableObject, RefreshTokenHandler {

    typealias ActionType = SubscriptionAction
    
    @Published var shouldLoginAgain = false
    
    @Published var productIdentifiers: Set<String> = [
        Bundle.main.infoDictionary?["SUBSCRIBE_PRODUCT_IDENTIFIER"] as! String
    ]

    @Published var showPurchaseFailureAlert = false
    
    private var verificationResult: VerificationResult<Transaction>?
    
    var cancellables = Set<AnyCancellable>()
    
    func handleCompletion(_ product: Product, result: Result<Product.PurchaseResult, any Error>) {
        switch result {
        case .success(let success):
            switch success {
            case .success(let verificationResult):
                requestReceiptVerification(verificationResult)
            case .userCancelled:
                showPurchaseFailureAlert = true
            case .pending:
                showPurchaseFailureAlert = true
            @unknown default:
                showPurchaseFailureAlert = true
            }
        case .failure(let failure):
            print("Error for Purchase: \(failure.localizedDescription)")
            showPurchaseFailureAlert = true
        }
    }
    
    private func requestReceiptVerification(_ result: VerificationResult<Transaction>) {
        
        //MARK: - Network API
        
        //MARK: - Invalid Token: verificationResult에 result 할당하기
        
    }
    
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: SubscriptionAction) {
        switch action {
        case .receiptVerification:
            if let verificationResult = verificationResult {
                requestReceiptVerification(verificationResult)
            }
        }
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            shouldLoginAgain = true
        }
    }

}
