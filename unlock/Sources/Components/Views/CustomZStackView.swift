//
//  CustomZStackView.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/10.
//

import SwiftUI

struct CustomZStackView<Content: View>: View {
    @EnvironmentObject var appState: AppState

    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            self.content

            if let errorMessage = appState.errorMessage {
                ErrorPopupView(errorText: errorMessage)
                    .zIndex(1)
            }

            if appState.showImageView {
                if let post = appState.postToShowImage {
                    PostImageView(title: post.title, imageURL: post.images.first?.url ?? "", opacity: 0.4)
                        .zIndex(1)
                }
            }

            if appState.showPopup {
                if let doublePopupToShow = appState.doublePopupToShow {
                    DoublePopupView(doublePopupInfo: doublePopupToShow)
                        .zIndex(1)
                }
            }
        }
    }
}

struct CustomZStackView_Previews: PreviewProvider {
    static var previews: some View {
        CustomZStackView(content: { Text("Hi") })
            .environmentObject(AppState.shared)
    }
}

