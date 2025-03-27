//
//  AuthError.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

public enum AuthError: Error {
    case notSignedIn
    case signInFailed(String)
    case signOutFailed(String)
    case invalidClientID
}
