//
//  AlertConfirmButton.swift
//  kiwIT
//
//  Created by Heedon on 7/3/24.
//

import SwiftUI

struct ErrorAlertConfirmButton: View {
    
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(Setup.ContentStrings.confirm)
                .foregroundStyle(Color.errorHighlightColor)
        }
    }
}

#Preview {
    ErrorAlertConfirmButton {
        print("")
    }
}
