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
    
    //tap해서 확대시 이미지파일 받고 있을 변수 필요
    var imageForExpandable: UIImage? = nil
    
    @State private var isTappedToExpand = false
    
    var body: some View {
        if isTappedToExpand {
            ExpandedImageView(image: imageForExpandable!)
        } else {
            ZStack {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.contentImageHeight)
                
                //Expanded 처리때문에 kingfisher 혹은 직접 URLSession 활용도 고민해봐야 할 듯 (Data load해서 uiimage로 가져오기)
                
                AsyncImage(url: URL(string: urlString)) { image in
                    image.resizable()
                    
                    //ViewModel에서 변환 처리?
                    
//                    let renderer = ImageRenderer(content: image)
//                    if let uiImage = renderer.uiImage {
//                        self.imageForExpandable = uiImage
//                    }
                    
                } placeholder: {
                    ProgressView()
                }
                .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.contentImageHeight)
                .offset(CGSize(width: -8.0, height: -8.0))
            }
            .onTapGesture {
                print("isTappedToExpand: \(isTappedToExpand)")
                isTappedToExpand.toggle()
                print("updated isTappedToExpand: \(isTappedToExpand)")
            }
        }
    }
}

#Preview {
    ContentImageView(urlString: "https://i.namu.wiki/i/2_NN7d9gqwTIbXcyPdjHJ5LLVFCwTAA6dQSr7SVqBflyUK1JrL6p2K5ld415BKo7FNd1o0GBDyfDz0bWUa6K0A.webp")
}
