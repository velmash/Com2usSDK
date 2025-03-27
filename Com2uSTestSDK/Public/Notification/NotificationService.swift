//
//  NotificationService.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

public protocol NotificationService {
    /// 로컬 알림 스케줄링
    /// - Parameters:
    ///   - id: 알림 고유 ID (취소 시 사용)
    ///   - title: 알림 제목
    ///   - body: 알림 내용
    ///   - triggerDate: 알림이 표시될 시간
    func scheduleNotification(id: String, title: String, body: String, triggerDate: Date) async throws
    
    /// 특정 ID의 알림 취소
    /// - Parameter id: 취소할 알림 ID
    func cancelNotification(id: String) async throws
    
    /// 모든 알림 취소
    func cancelAllNotifications() async throws
}
