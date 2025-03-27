//
//  ProfileViewController.swift
//  Com2uSTestSDK
//
//  Created by 윤형찬 on 3/27/25.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    private let user: User?
    private let authService: AuthService
    
    private let containerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let signOutButton = UIButton(type: .system)
    
    init(user: User?, authService: AuthService) {
        self.user = user
        self.authService = authService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        if let user = user {
            configureWithUser(user)
        } else {
            showErrorView()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "사용자 프로필"
        
        // 컨테이너 뷰 설정
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
            make.height.greaterThanOrEqualTo(300)
        }
        
        // 프로필 이미지 뷰 설정
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 50
        containerView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        // 이름 레이블 설정
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
        }
        
        // 이메일 레이블 설정
        emailLabel.font = .systemFont(ofSize: 16)
        emailLabel.textAlignment = .center
        emailLabel.textColor = .secondaryLabel
        containerView.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        // 로그아웃 버튼 설정
        signOutButton.setTitle("로그아웃", for: .normal)
        signOutButton.backgroundColor = .systemRed
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.layer.cornerRadius = 8
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        containerView.addSubview(signOutButton)
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func configureWithUser(_ user: User) {
        nameLabel.text = user.name
        emailLabel.text = user.email
        
        if let profileImageURL = user.profileImageURL {
            // 실제 구현에서는 이미지 로딩 라이브러리 사용 권장
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: profileImageURL),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
        } else {
            // 기본 이미지 설정
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
    private func showErrorView() {
        // 에러 뷰 구성
        let errorLabel = UILabel()
        errorLabel.text = "로그인이 필요합니다"
        errorLabel.font = .systemFont(ofSize: 20, weight: .medium)
        errorLabel.textAlignment = .center
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("로그인", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        containerView.addSubview(errorLabel)
        containerView.addSubview(loginButton)
        
        errorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(44)
        }
    }
    
    @objc private func signOutTapped() {
        Task {
            do {
                try await authService.signOut()
                dismiss(animated: true)
            } catch {
                // 에러 처리
                let alert = UIAlertController(
                    title: "로그아웃 실패",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                present(alert, animated: true)
            }
        }
    }
    
    @objc private func loginTapped() {
        dismiss(animated: true)
    }
}
