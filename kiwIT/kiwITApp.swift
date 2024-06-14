//
//  kiwITApp.swift
//  kiwIT
//
//  Created by Heedon on 3/10/24.
//

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth

@main
struct kiwITApp: App {
    
    init() {
        //Config 활용 Main Bundle 내부 등록된 키를 활용
//        let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] ?? ""
        let kakaoAppKey = Bundle.main.infoDictionary?[Setup.ContentStrings.kakaoNativeKeyString] ?? ""
        
        KakaoSDK.initSDK(appKey: kakaoAppKey as! String)
        
        //APIKey.swift 내부 등록한 키값 활용
//        KakaoSDK.initSDK(appKey: APIKey.kakaoAppKey)
        
        
        //앱 처음 실행인지 체크
        //처음이라면 KeyChain 모두 삭제 후, 앱 실행 시작
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabBarView()
                .onOpenURL(perform: { url in
                    //Kakao
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        AuthController.handleOpenUrl(url: url)
                    }
                })
        }
    }
}
