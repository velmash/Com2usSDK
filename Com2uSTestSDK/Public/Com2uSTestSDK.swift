//
//  Com2uSTestSDK.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit

public final class Com2uSTestSDK {
    // 싱글톤 인스턴스
    public static let shared = Com2uSTestSDK()
    
    // 서비스
    public private(set) lazy var auth: AuthService = AuthServiceImpl()
    public private(set) lazy var notification: NotificationService = NotificationServiceImpl()
    
    // 초기화 설정
    public func configure() {
        // SDK 초기화 로직
        NotificationManager.shared.setupNotifications()
    }
    
    private init() {}
}
