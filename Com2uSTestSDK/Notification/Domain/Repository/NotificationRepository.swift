//
//  NotificationRepository.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

protocol NotificationRepository {
    func scheduleNotification(_ notification: LocalNotification) async throws
    func cancelNotification(withId id: String) async throws
    func cancelAllNotifications() async throws
}
