//
//  CancelNotificationUseCase.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

final class CancelNotificationUseCase {
    private let repository: NotificationRepository
    
    init(repository: NotificationRepository) {
        self.repository = repository
    }
    
    func execute(id: String) async throws {
        try await repository.cancelNotification(withId: id)
    }
}
