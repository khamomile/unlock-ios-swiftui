//
//  MainTabView.swift
//  unlock
//
//  Created by Paul Lee on 2022/10/24.
//

import SwiftUI
import Introspect

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    
    @StateObject var homeFeedViewModel: HomeFeedViewModel = HomeFeedViewModel()
    @StateObject var discoverFeedViewModel: DiscoverFeedViewModel = DiscoverFeedViewModel()
    @StateObject var notificationViewModel: NotificationViewModel = NotificationViewModel()
    @StateObject var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        CustomZStackView {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        selectedTab == .home ? Tab.home.activeImage : Tab.home.nonActiveImage
                    }
                    .tag(Tab.home)

                DiscoverView()
                    .tabItem {
                        selectedTab == .discover ? Tab.discover.activeImage : Tab.discover.nonActiveImage
                    }
                    .tag(Tab.discover)

                NotiView()
                    .tabItem {
                        if notificationViewModel.hasUnread {
                            selectedTab == .notification ? Image("noti-active-red") : Image("noti-non-active-red")
                        } else {
                            selectedTab == .notification ? Tab.notification.activeImage : Tab.notification.nonActiveImage
                        }
                    }
                    .tag(Tab.notification)

                MyProfileView()
                    .tabItem {
                        selectedTab == .my ? Tab.my.activeImage : Tab.my.nonActiveImage
                    }
                    .tag(Tab.my)
            }
            .environmentObject(homeFeedViewModel)
            .environmentObject(discoverFeedViewModel)
            .environmentObject(notificationViewModel)
            .environmentObject(profileViewModel)
        }
        .navigationBarHidden(true)
        .onAppear {
            appState.getMe()
            notificationViewModel.getUnreadNoti()

            if appState.notiReceived == true {
                selectedTab = .notification
                appState.notiReceived = false
            }
        }
        .onChange(of: appState.notiReceived) { newValue in
            print("Noti received 2: \(appState.notiReceived)")
            if newValue == true {
                selectedTab = .notification
                appState.notiReceived = false
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState.shared)
    }
}
