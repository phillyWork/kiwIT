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
        //Config 활용 Main Bundle 내부 등록된 키를 활용
        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        //APIKey.swift 내부 등록한 키값 활용
//        KakaoSDK.initSDK(appKey: APIKey.kakaoAppKey)
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
