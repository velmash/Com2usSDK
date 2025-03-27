//
//  NotificationError.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

public enum NotificationError: Error {
    case permissionDenied
    case invalidTriggerDate
    case schedulingFailed(String)
}
