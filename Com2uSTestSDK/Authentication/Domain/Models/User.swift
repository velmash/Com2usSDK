//
//  User.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

public struct User: Codable {
    public let email: String
    public let name: String
    public let profileImageURL: URL?
}
