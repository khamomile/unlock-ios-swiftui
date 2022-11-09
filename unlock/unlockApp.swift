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
    
    let unlockService: UnlockService = UnlockService.shared
    
    var body: some Scene {
        WindowGroup {
            UserInitialView()
                .environmentObject(unlockService)
        }
    }
}

