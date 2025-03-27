//
//  NotificationManager.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private var isAuthorized = false
    
    private init() {}
    
    func setupNotifications() {
        checkAuthorizationStatus()
    }
    
    private func checkAuthorizationStatus() {
        notificationCenter.getNotificationSettings { settings in
            self.isAuthorized = settings.authorizationStatus == .authorized
        }
    }
    
    func requestAuthorization() async throws -> Bool {
        do {
            let granted = try await notificationCenter.requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
            return granted
        } catch {
            throw NotificationError.permissionDenied
        }
    }
    
    func schedule(notification: LocalNotification) async throws {
        // 권한 확인
        if !isAuthorized {
            _ = try await requestAuthorization()
        }
        
        // 현재 시간이 트리거 시간보다 이후인지 확인
        if notification.triggerDate <= Date() {
            throw NotificationError.invalidTriggerDate
        }
        
        // 알림 콘텐츠 생성
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = .default
        
        // 알림은 앱이 Foreground에 있을 때만 표시되도록 설정
        content.userInfo = ["showInForegroundOnly": true]
        
        // 트리거 생성
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notification.triggerDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // 요청 생성
        let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
        
        // 알림 스케줄링
        try await notificationCenter.add(request)
    }
    
    func cancelNotification(withId id: String) async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func cancelAllNotifications() async {
        notificationCenter.removeAllPendingNotificationRequests()
    }
}
