//
//  NotificationRepositoryImpl.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

final class NotificationRepositoryImpl: NotificationRepository {
    private let notificationManager = NotificationManager.shared
    
    func scheduleNotification(_ notification: LocalNotification) async throws {
        try await notificationManager.schedule(notification: notification)
    }
    
    func cancelNotification(withId id: String) async throws {
        await notificationManager.cancelNotification(withId: id)
    }
    
    func cancelAllNotifications() async throws {
        await notificationManager.cancelAllNotifications()
    }
}
