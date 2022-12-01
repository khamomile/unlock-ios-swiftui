//
//  unlockApp.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI

@main
struct unlockApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let appState: AppState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            UserInitialView()
                .environmentObject(appState)
        }
    }
}

