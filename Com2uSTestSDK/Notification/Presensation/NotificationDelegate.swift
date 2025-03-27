//
//  NotificationDelegate.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit
import UserNotifications

public final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    public static let shared = NotificationDelegate()
    
    private override init() {
        super.init()
    }
    
    public func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // 알림의 userInfo에서 Foreground 전용 플래그 확인
        let userInfo = notification.request.content.userInfo
        let showInForegroundOnly = userInfo["showInForegroundOnly"] as? Bool ?? false
        
        // 앱이 Foreground에 있고, Foreground 전용 플래그가 설정된 경우에만 알림 표시
        if UIApplication.shared.applicationState == .active && showInForegroundOnly {
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .sound])
            } else {
                completionHandler([.alert, .sound])
            }
        } else {
            completionHandler([])
        }
    }
}
