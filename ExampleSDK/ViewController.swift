//
//  ViewController.swift
//  ExampleSDK
//
//  Created by 윤형찬 on 3/29/25.
//

import UIKit
import Com2uSTestSDK

class ViewController: UIViewController {
    
    private let signInButton = UIButton(type: .system)
    private let profileButton = UIButton(type: .system)
    private let signOutButton = UIButton(type: .system)
    private let scheduleNotificationButton = UIButton(type: .system)
    private let cancelNotificationButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    
    private let sdk = ComtusSDK.shared
    private let googleClientID = "353672748855-llqakn9mfo5fqbtift4jrgi9nnkoqs1b.apps.googleusercontent.com" // Info.plist에서 가져오는 것이 더 좋습니다
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUIState()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // UI 컴포넌트 설정
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        
        signInButton.setTitle("Google 로그인", for: .normal)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        
        profileButton.setTitle("프로필 보기", for: .normal)
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        
        signOutButton.setTitle("로그아웃", for: .normal)
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        
        scheduleNotificationButton.setTitle("알림 예약 (5초 후)", for: .normal)
        scheduleNotificationButton.addTarget(self, action: #selector(scheduleNotificationTapped), for: .touchUpInside)
        
        cancelNotificationButton.setTitle("알림 취소", for: .normal)
        cancelNotificationButton.addTarget(self, action: #selector(cancelNotificationTapped), for: .touchUpInside)
        
        // 레이아웃 설정
        [statusLabel, signInButton, profileButton, signOutButton, scheduleNotificationButton, cancelNotificationButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 30),
            signInButton.widthAnchor.constraint(equalToConstant: 200),
            signInButton.heightAnchor.constraint(equalToConstant: 44),
            
            profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 20),
            profileButton.widthAnchor.constraint(equalToConstant: 200),
            profileButton.heightAnchor.constraint(equalToConstant: 44),
            
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: profileButton.bottomAnchor, constant: 20),
            signOutButton.widthAnchor.constraint(equalToConstant: 200),
            signOutButton.heightAnchor.constraint(equalToConstant: 44),
            
            scheduleNotificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scheduleNotificationButton.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 40),
            scheduleNotificationButton.widthAnchor.constraint(equalToConstant: 250),
            scheduleNotificationButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelNotificationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelNotificationButton.topAnchor.constraint(equalTo: scheduleNotificationButton.bottomAnchor, constant: 20),
            cancelNotificationButton.widthAnchor.constraint(equalToConstant: 250),
            cancelNotificationButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    private func updateUIState() {
        let isSignedIn = sdk.auth.isSignedIn
        statusLabel.text = isSignedIn ? "로그인 상태: 로그인됨" : "로그인 상태: 로그아웃됨"
        signInButton.isEnabled = !isSignedIn
        profileButton.isEnabled = isSignedIn
        signOutButton.isEnabled = isSignedIn
    }
    
    @objc private func signInTapped() {
        Task {
            do {
                let user = try await sdk.auth.signIn(clientID: googleClientID)
                DispatchQueue.main.async {
                    self.statusLabel.text = "로그인 성공: \(user.name)"
                    self.updateUIState()
                }
            } catch {
                DispatchQueue.main.async {
                    self.statusLabel.text = "로그인 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    @objc private func profileTapped() {
        sdk.auth.showProfileView(from: self)
    }
    
    @objc private func signOutTapped() {
        Task {
            do {
                try await sdk.auth.signOut()
                DispatchQueue.main.async {
                    self.statusLabel.text = "로그아웃 성공"
                    self.updateUIState()
                }
            } catch {
                DispatchQueue.main.async {
                    self.statusLabel.text = "로그아웃 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    @objc private func scheduleNotificationTapped() {
        let notificationID = "test-notification"
        let triggerDate = Date().addingTimeInterval(5)
        
        Task {
            do {
                try await sdk.notification.scheduleNotification(
                    id: notificationID,
                    title: "테스트 알림",
                    body: "SDK에서 생성된 알림입니다",
                    triggerDate: triggerDate
                )
                DispatchQueue.main.async {
                    self.statusLabel.text = "알림이 5초 후로 예약되었습니다"
                }
            } catch {
                DispatchQueue.main.async {
                    self.statusLabel.text = "알림 예약 실패: \(error.localizedDescription)"
                }
            }
        }
    }
    
    @objc private func cancelNotificationTapped() {
        Task {
            do {
                try await sdk.notification.cancelAllNotifications()
                DispatchQueue.main.async {
                    self.statusLabel.text = "모든 알림이 취소되었습니다"
                }
            } catch {
                DispatchQueue.main.async {
                    self.statusLabel.text = "알림 취소 실패: \(error.localizedDescription)"
                }
            }
        }
    }
}
