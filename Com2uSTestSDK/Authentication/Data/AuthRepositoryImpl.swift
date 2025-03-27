//
//  AuthRepositoryImpl.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit

final class AuthRepositoryImpl: AuthRepository {
    private let googleAuthService = GoogleAuthService.shared
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "com.mygamesdk.currentUser"
    
    private(set) var currentUser: User?
    
    init() {
        // 저장된 사용자 불러오기
        if let userData = userDefaults.data(forKey: userDefaultsKey),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            self.currentUser = user
        }
    }
    
    func signIn(clientID: String) async throws -> User {
        // Configure Google Sign-In
        googleAuthService.configure(with: clientID)
        
        // Find the topmost view controller to present the sign-in UI
        guard let topViewController = UIApplication.shared.windows.first?.rootViewController else {
            throw AuthError.signInFailed("Cannot find view controller to present sign-in UI")
        }
        
        // Perform sign-in
        let googleUser = try await googleAuthService.signIn(presentingViewController: topViewController)
        
        // Extract user info
        guard let profile = googleUser.profile else {
            throw AuthError.signInFailed("Could not get user profile")
        }
        
        let user = User(
            email: profile.email,
            name: profile.name,
            profileImageURL: profile.imageURL(withDimension: 200)
        )
        
        // Save user
        self.currentUser = user
        let userData = try JSONEncoder().encode(user)
        userDefaults.set(userData, forKey: userDefaultsKey)
        
        return user
    }
    
    func signOut() async throws {
        try await googleAuthService.signOut()
        currentUser = nil
        userDefaults.removeObject(forKey: userDefaultsKey)
    }
}
