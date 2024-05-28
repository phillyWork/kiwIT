//
//  kiwITApp.swift
//  kiwIT
//
//  Created by Heedon on 3/10/24.
//

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth

import GoogleSignIn

@main
struct kiwITApp: App {
    
    init() {
        KakaoSDK.initSDK(appKey: APIKey.kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .onOpenURL(perform: { url in
                    //Kakao
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        AuthController.handleOpenUrl(url: url)
                    }
                    
                    //Google
                    GIDSignIn.sharedInstance.handle(url)
                    
                    //Restore User Login Status in Google?
                    GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                        // Check if `user` exists; otherwise, do something with `error`
                    }
                    
                })
        }
    }
}
