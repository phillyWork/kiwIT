//
//  Setup+ContentStrings+SignUp.swift
//  kiwIT
//
//  Created by Heedon on 7/3/24.
//

import Foundation

extension Setup.ContentStrings {

    enum SignUp {
        static let userInfo = "회원 가입 정보"
        static let email = "이메일: "
        static let nickname = "닉네임: "
        static let requiredToFillInNickname = "닉네임 입력은 필수입니다"
        static let serviceProvider = "서비스: "
        static let apple = "애플"
        static let kakao = "카카오"
        static let checkInfoAndAgree = "안내 사항을 확인하고 동의합니다"
        static let signUpText = "회원 가입"
        static let cannotSignUpText = "필수 사항 입력이 우선됩니다"
        static let notReadyToSignUpErrorAlertTitle = "회원 가입을 시도할 수 없습니다"
        static let notReadyToSignUpErrorAlertMessage = "닉네임을 입력해주시고 안내 사항을 체크해주셔야 회원 가입을 할 수 있습니다"
        static let signUpErrorAlertTitle = "회원 가입 오류!"
        static let signUpErrorAlertMessage = "닉네임 중복 또는 회원 가입을 할 수 없는 계정입니다. 다시 시도해주세요."

        //MARK: - 법적 확인 및 동의 내용 작성하기

        static let infoToBeGiven = "만 14세 이상 확인 안내\n\n본 서비스는 개인정보 보호법에 따라 만 14세 미만의 이용자는 회원으로 가입하실 수 없습니다. 회원 가입을 진행하기 위해서는 귀하가 만 14세 이상임을 확인해야 합니다.\n\n회원 가입을 진행함으로써 귀하가 만 14세 이상이며, 서비스 이용 약관 및 개인정보 처리 방침에 동의하는 것으로 간주됩니다.\n\n만 14세 미만임에도 불구하고 허위 정보를 제공하여 가입할 경우, 이용 제한 또는 법적 조치가 취해질 수 있습니다."
        
    }

}
