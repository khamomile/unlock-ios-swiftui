//
//  UserInitialView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/26.
//

import SwiftUI

struct UserInitialView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            Text("마음을\n열어보다.")
                .multilineTextAlignment(.center)
                .font(.boldTitle2)
                .foregroundColor(.blue1)
        }
        .frame(maxHeight: .infinity)
        .fullScreenCover(isPresented: $appState.loginStatusReceived) {
            MainView()
                .environmentObject(appState)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                appState.getUserLoggedIn()
            }
        }
    }
}

struct UserInitialView_Previews: PreviewProvider {
    static var previews: some View {
        UserInitialView()
            .environmentObject(AppState.shared)
    }
}
