//
//  AuthRepository.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

protocol AuthRepository {
    var currentUser: User? { get }
    func signIn(clientID: String) async throws -> User
    func signOut() async throws
}
