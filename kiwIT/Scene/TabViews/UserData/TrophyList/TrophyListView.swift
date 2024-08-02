//
//  TrophyView.swift
//  kiwIT
//
//  Created by Heedon on 6/4/24.
//

import SwiftUI

struct TrophyListView: View {
    
    @StateObject var trophyListVM = TrophyListViewModel()
    @Binding var isLoginAvailable: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                Image(systemName: Setup.ImageStrings.downDirection)
                    .scaledToFit()
                Text("당겨서 새로고침")
                    .font(.custom(Setup.FontName.lineThin, size: 12))
                    .foregroundStyle(Color.textColor)
            }
            LazyVStack {
                ForEach(trophyListVM.wholeTrophyList, id: \.self) { trophy in
                    TrophyContent(trophy: trophy, achievedDate: trophyListVM.retrieveAcquiredDate(trophy))
                        .onAppear {
                            trophyListVM.checkToLoadMoreTrophyies(trophy)
                        }
                }
            }
        }
        .background(Color.backgroundColor)
        .frame(maxWidth: .infinity)
        .alert("트로피 에러", isPresented: $trophyListVM.showWholeTrophyRequestErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("트로피 목록을 불러오는데 실패했습니다. 다시 시도해주세요")
        })
        .alert("획득한 트로피 에러", isPresented: $trophyListVM.showAcquiredTrophyRequestErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("획득한 트로피 목록을 불러오는데 실패했습니다. 다시 시도해주세요")
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $trophyListVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        .refreshable {
            trophyListVM.debouncedRefreshRequest()
        }
        .onDisappear {
            trophyListVM.cleanUpCancellables()
        }
    }
}
