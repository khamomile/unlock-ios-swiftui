//
//  SettingViewModel+Bridge.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/09.
//

import Foundation

extension SettingViewModel {
    // SETTING UP VIEWMODEL
    func setViewModel(homeFeedViewModel: HomeFeedViewModel, discoverFeedViewModel: DiscoverFeedViewModel) {
        self.homeFeedViewModel = homeFeedViewModel
        self.discoverFeedViewModel = discoverFeedViewModel
    }
    
    func bridgeUnblockedUser(unblockedUserId: String) {
        guard let homeFeedViewModel = homeFeedViewModel, let discoverFeedViewModel = discoverFeedViewModel else { return }
        
        homeFeedViewModel.updateUnblockedUser(unblockedUserId: unblockedUserId)
        discoverFeedViewModel.updateUnblockedUser(unblockedUserId: unblockedUserId)
    }
}
