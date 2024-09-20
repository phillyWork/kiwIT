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
                Text(Setup.ContentStrings.pullToRefreshTitle)
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
        .alert(Setup.ContentStrings.Trophy.wholeTrophyListErrorAlertTitle, isPresented: $trophyListVM.showWholeTrophyRequestErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.Trophy.wholeTrophyListErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.Trophy.acquiredTrophyListErrorAlertTitle, isPresented: $trophyListVM.showAcquiredTrophyRequestErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.Trophy.acquiredTrophyListErrorAlertMessage)
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
