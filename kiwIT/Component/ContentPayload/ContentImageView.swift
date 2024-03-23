//
//  ContentImageView.swift
//  kiwIT
//
//  Created by Heedon on 3/20/24.
//

import SwiftUI

struct ContentImageView: View {
    
    var urlString: String
    
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
