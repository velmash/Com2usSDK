//
//  NotificationServiceImpl.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UserNotifications
import Foundation

final class NotificationServiceImpl: NotificationService {
    private let repository: NotificationRepository
    private let scheduleNotificationUseCase: ScheduleNotificationUseCase
    private let cancelNotificationUseCase: CancelNotificationUseCase
    private let cancelAllNotificationsUseCase: CancelAllNotificationsUseCase
    
    init() {
        let repository = NotificationRepositoryImpl()
        self.repository = repository
        self.scheduleNotificationUseCase = ScheduleNotificationUseCase(repository: repository)
        self.cancelNotificationUseCase = CancelNotificationUseCase(repository: repository)
        self.cancelAllNotificationsUseCase = CancelAllNotificationsUseCase(repository: repository)
        
        // 알림 델리게이트 설정
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared
    }
    
    func scheduleNotification(id: String, title: String, body: String, triggerDate: Date) async throws {
        let notification = LocalNotification(id: id, title: title, body: body, triggerDate: triggerDate)
        try await scheduleNotificationUseCase.execute(notification: notification)
    }
    
    func cancelNotification(id: String) async throws {
        try await cancelNotificationUseCase.execute(id: id)
    }
    
    func cancelAllNotifications() async throws {
        try await cancelAllNotificationsUseCase.execute()
    }
}
