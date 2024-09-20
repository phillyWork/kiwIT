//
//  UserSubscriptionView.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

import StoreKit

//MARK: - 구독 상품 및 구독 상품 구입하기 설정
//MARK: - 유료 앱 설정 필요 문제 (코드 구조 구성만)

struct UserSubscriptionView: View {
    
    @StateObject var subscriptionVM: UserSubscriptionViewModel
    @ObservedObject var interviewListVM: InterviewListViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(_ interviewListVM: InterviewListViewModel) {
        self._subscriptionVM = StateObject(wrappedValue: UserSubscriptionViewModel())
        self.interviewListVM = interviewListVM
    }
    
    var body: some View {
        SubscriptionStoreView(productIDs: subscriptionVM.productIdentifiers) {
            VStack {
                Text("kiwIT 월간 구독")
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 15))
                Text("월간 구독을 하신 분께 AI 인터뷰 생성 기능을 제공합니다.")
            }
            .foregroundStyle(Color.textColor)
            .containerBackground(Color.brandColor, for: .subscriptionStore)
        }
        .subscriptionStorePolicyDestination(for: .privacyPolicy) {
            Text("Privacy Policy URL to show")
        }
        .subscriptionStorePolicyDestination(for: .termsOfService) {
            Text("Terms of Service URL to show")
        }
        .storeButton(.visible, for: .restorePurchases)
        .subscriptionStoreControlStyle(.prominentPicker)
        .background(Color.backgroundColor)
        .onInAppPurchaseCompletion { product, result in
            subscriptionVM.handleCompletion(product, result: result)
        }
        .alert(Text("구매 실패!"), isPresented: $subscriptionVM.showPurchaseFailureAlert) {
            ErrorAlertConfirmButton { }
        } message: {
            Text("구독에 실패했습니다! 다시 시도해주세요!")
        }
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $subscriptionVM.shouldLoginAgain) {
            Button {
                interviewListVM.shouldLoginAgain = true
                dismiss()
            } label: {
                Text(Setup.ContentStrings.confirm)
            }
        } message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        }

    }

}

#Preview {
    UserSubscriptionView(InterviewListViewModel())
}
