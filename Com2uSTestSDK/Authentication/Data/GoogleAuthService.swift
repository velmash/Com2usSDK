//
//  GoogleAuthService.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit
import GoogleSignIn

final class GoogleAuthService {
    static let shared = GoogleAuthService()
    
    private var configuration: GIDConfiguration?
    private var currentUser: GIDGoogleUser?
    
    private init() {}
    
    func configure(with clientID: String) {
        configuration = GIDConfiguration(clientID: clientID)
    }
    
    func signIn(presentingViewController: UIViewController) async throws -> GIDGoogleUser {
        guard let configuration = configuration else {
            throw AuthError.invalidClientID
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
                if let error = error {
                    continuation.resume(throwing: AuthError.signInFailed(error.localizedDescription))
                    return
                }
                
                guard let user = signInResult?.user else {
                    continuation.resume(throwing: AuthError.signInFailed("Unknown error"))
                    return
                }
                
                self.currentUser = user
                continuation.resume(returning: user)
            }
        }
    }
    
    func signOut() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.signOut()
            self.currentUser = nil
            continuation.resume(returning: ())
        }
    }
    
    func restorePreviousSignIn() async throws -> GIDGoogleUser? {
        return try await withCheckedThrowingContinuation { continuation in
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if let error = error {
                    continuation.resume(throwing: AuthError.signInFailed(error.localizedDescription))
                    return
                }
                
                self.currentUser = user
                continuation.resume(returning: user)
            }
        }
    }
}
