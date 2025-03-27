//
//  AuthServiceImpl.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit

final class AuthServiceImpl: AuthService {
    private let repository: AuthRepository
    private let signInUseCase: SignInUseCase
    private let signOutUseCase: SignOutUseCase
    
    init() {
        let repository = AuthRepositoryImpl()
        self.repository = repository
        self.signInUseCase = SignInUseCase(repository: repository)
        self.signOutUseCase = SignOutUseCase(repository: repository)
    }
    
    var isSignedIn: Bool {
        return repository.currentUser != nil
    }
    
    func signIn(clientID: String) async throws -> User {
        return try await signInUseCase.execute(clientID: clientID)
    }
    
    func signIn(clientID: String, completion: @escaping (Result<User, Error>) -> Void) {
        Task {
            do {
                let user = try await signIn(clientID: clientID)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func signOut() async throws {
        try await signOutUseCase.execute()
    }
    
    func showProfileView(from viewController: UIViewController) {
        let user = repository.currentUser
        let profileVC = ProfileViewController(user: user, authService: self)
        let navController = UINavigationController(rootViewController: profileVC)
        viewController.present(navController, animated: true)
    }
}
