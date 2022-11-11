//
//  AppDelegate.swift
//  unlock
//
//  Created by Paul Lee on 2022/11/09.
//

import Foundation
import FirebaseCore
import FirebaseMessaging

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // FIREBASE SETTING
        FirebaseApp.configure()
        
        // CLOUD MESSAGING REGISTER
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        // MESSAGING DELEGATE
        Messaging.messaging().delegate = self
        
        // PUSH FOREGROUND SETTING
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    // fcm 토큰이 등록 되었을 때
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate : MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("AppDelegate - 파베 토큰을 받았다.")
        print("AppDelegate - Firebase registration token: \(String(describing: fcmToken))")
        
        guard let fcmToken = fcmToken else { return }
        
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
}

extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // 푸시메세지가 앱이 켜져 있을때 나올때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // let userInfo = notification.request.content.userInfo
        
        // print("willPresent: userInfo: ", userInfo)
        // UnlockService.shared.notiReceived = true
        print("Noti received 4: \(UnlockService.shared.notiReceived)")
        
        completionHandler([.badge, .list, .sound, .banner])
    }
    
    // 푸시메세지를 받았을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("didReceive: userInfo: ", userInfo.keys)
        
        let link: String = userInfo["link"] as? String ?? ""
        let realLink = link // getRealLink(title: userInfo["title"] as? String ?? "", link: link, messageBody: userInfo["body"] as? String) ?? ""
        UnlockService.shared.notiReceived = true
        
        let linkIdentifying = realLink.components(separatedBy: "/post/")
        
        if linkIdentifying.count >= 2 {
            UnlockService.shared.notiDestination = .post(id: linkIdentifying[1])
        } else {
            UnlockService.shared.notiDestination = .friend
        }
        
        completionHandler()
    }
}
