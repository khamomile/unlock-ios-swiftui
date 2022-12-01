//
//  UserInitialView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct UserInitialView: View {
    @StateObject var viewModel = SignInViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Text("마음을\n열어보다.")
                .multilineTextAlignment(.center)
                .font(.boldTitle2)
                .foregroundColor(.blue1)
        }
        .frame(maxHeight: .infinity)
        .fullScreenCover(isPresented: $viewModel.loggedIn, content: {
            MainTabView()
                .environmentObject(appState)
        })
        .fullScreenCover(isPresented: $viewModel.notLoggedIn) {
            RegisterOrLoginView()
                .environmentObject(viewModel)
        }
    }
}

struct UserInitialView_Previews: PreviewProvider {
    static var previews: some View {
        UserInitialView()
            .environmentObject(AppState.shared)
    }
}
