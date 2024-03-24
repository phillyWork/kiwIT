//
//  ContentImageView.swift
//  kiwIT
//
//  Created by Heedon on 3/20/24.
//

import SwiftUI

struct ContentImageView: View {
    
    var urlString: String
    
    //cache에 해당 이미지 존재하는지 확인 필요
    //cache에 일정 용량 차면 가장 큰 이미지, 가장 오래된 이미지부터 삭제하도록 설정하기 (kingfisher 활용 캐시?)
    //cache에 이미지 존재하지 않으면 url에서 가져오기

    var body: some View {
        AsyncImage(url: URL(string: urlString)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.contentImageHeight)
    }
}

#Preview {
    ContentImageView(urlString: "")
}
