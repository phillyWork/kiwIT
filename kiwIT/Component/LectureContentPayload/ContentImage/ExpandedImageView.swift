//
//  ExpandedImageView.swift
//  kiwIT
//
//  Created by Heedon on 4/11/24.
//

import SwiftUI

struct ExpandedImageView: View {
        
    //tap해서 확대시 이미지파일 받고 있을 변수 필요
    var imageForExpandable: UIImage
    
    @Environment(\.dismiss) var dismiss
    
    init(image: UIImage) {
        print("About to show Expanded Image!!!")
        self.imageForExpandable = image
    }
    
    @State private var isTappedToExpand = false
    
    var body: some View {
        ZStack {
            Image(uiImage: imageForExpandable)
                .rotationEffect(.degrees(-90))
                .frame(width: Setup.Frame.expandedContentImageWidth, height: Setup.Frame.expandedContentImageHeight)
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: Setup.ImageStrings.defaultXMark2)
            })
        }
    }
}
