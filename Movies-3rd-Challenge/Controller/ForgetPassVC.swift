//
//  ForgetPassVC.swift
//  Movies-3rd-Challenge
//
//  Created by Евгений on 08.04.2025.
//

import Foundation
import UIKit
import FirebaseAuth

class ForgetPassVC: UIViewController {
    private let mainView: ForgetPass = .init()
    private var showAlert: Bool = false
    private var alertMessage: String = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = .systemBackground
        let titleLabel = UILabel()
        titleLabel.attributedText = NSAttributedString(
            string: "Forgot your password?",
            attributes: [
                .font: UIFont(name: "PlusJakartaSans-Bold", size: 26) ?? .systemFont(ofSize: 26)])
        self.navigationItem.titleView = titleLabel
        self.mainView.submit.addTarget(self, action: #selector(sendPasswordReset), for: .touchUpInside)
    }
    
    @objc func sendPasswordReset() {
        guard let email = mainView.emailTextField.text?.trimmingCharacters(in: .whitespaces).lowercased(),
              !email.isEmpty else {
            showAlert(title: "Ошибка", message: "Пожалуйста, введите email")
            return
        }
        guard email.contains("@"), email.contains(".") else {
            showAlert(title: "Ошибка", message: "Пожалуйста, введите корректный email")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    let errorMessage = self.handlePasswordResetError(error)
                    self.showAlert(title: "Ошибка", message: errorMessage)
                    return
                }
                self.showAlert(title: "Успешно",
                              message: "Письмо для сброса пароля отправлено на \(email)") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    private func handlePasswordResetError(_ error: Error) -> String {
        guard let authError = error as? AuthErrorCode else {
            return "Неизвестная ошибка"
        }
        
        switch authError.code {
        case .userNotFound:
            return "Пользователь с таким email не найден"
        case .invalidEmail:
            return "Некорректный формат email"
        case .tooManyRequests:
            return "Слишком много запросов. Попробуйте позже"
        default:
            return "Ошибка: \(error.localizedDescription)"
        }
    }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}
