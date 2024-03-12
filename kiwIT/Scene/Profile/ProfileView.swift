//
//  ProfileView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        Text("ProfileView")
            .tabItem {
                Label("나", systemImage: Setup.ImageStrings.defaultProfile)
            }
    }
}

#Preview {
    ProfileView()
}
