//
//  SignInUseCase.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import Foundation

final class SignInUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(clientID: String) async throws -> User {
        return try await repository.signIn(clientID: clientID)
    }
}
