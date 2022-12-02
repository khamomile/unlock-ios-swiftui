//
//  MainView.swift
//  unlock
//
//  Created by Paul Lee on 2022/12/02.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = SignInViewModel()

    var body: some View {
        if appState.loggedIn {
            MainTabView()
                .environmentObject(appState)
        } else {
            RegisterOrLoginView()
                .environmentObject(appState)
                .environmentObject(viewModel)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(AppState.shared)
    }
}
