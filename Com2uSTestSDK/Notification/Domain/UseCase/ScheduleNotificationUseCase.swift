//
//  ScheduleNotificationUseCase.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

final class ScheduleNotificationUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func execute(notification: LocalNotification) async throws {
        try await repository.scheduleNotification(notification)
    }
}
