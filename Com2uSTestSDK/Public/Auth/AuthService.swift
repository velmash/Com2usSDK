//
//  AuthService.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit

public protocol AuthService {
    /// 현재 로그인 상태
    var isSignedIn: Bool { get }
    
    /// Google 로그인 수행
    /// - Parameter clientID: Google Developer Console에서 발급받은 Client ID
    /// - Returns: 로그인된 사용자 정보
    func signIn(clientID: String) async throws -> User
    
    /// 기존 완료 핸들러 스타일의 로그인 메서드 (호환성 유지)
    func signIn(clientID: String, completion: @escaping (Result<User, Error>) -> Void)
    
    /// 로그아웃 수행
    func signOut() async throws
    
    /// 사용자 프로필 화면 표시
    /// - Parameter viewController: 프로필 화면을 표시할 부모 뷰 컨트롤러
    func showProfileView(from viewController: UIViewController)
}
