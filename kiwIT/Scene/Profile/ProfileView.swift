//
//  ProfileView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        VStack {
            Text("ProfileView")
        }
        .frame(maxHeight: .infinity)
        .frame(width: Setup.Frame.devicePortraitWidth)
        .background(Color.backgroundColor)
    }
}

#Preview {
    ProfileView()
}
