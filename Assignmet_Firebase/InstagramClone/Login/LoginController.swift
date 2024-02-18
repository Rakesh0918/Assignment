//
//  LoginController.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 3/19/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    private let logoContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        logoImageView.contentMode = .scaleAspectFill
        container.addSubview(logoImageView)
        logoImageView.anchor(width: 200, height: 50)
        logoImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        return container
    }()
    
    private lazy var mobileTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.placeholder = "Mobile"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var codeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Code"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(LoginController.self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainBlue
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(LoginController.self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 130 + UIApplication.shared.statusBarFrame.height)
        codeTextField.isHidden = true
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 50)
        
        setupInputFields()
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [mobileTextField, codeTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingRight: 40, height: 140)
    }
    
    private func resetInputFields() {
        mobileTextField.text = ""
        codeTextField.text = ""
        mobileTextField.isUserInteractionEnabled = true
        codeTextField.isUserInteractionEnabled = true
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
    @objc private func handleLogin() {
        guard let phoneNumber = mobileTextField.text else { return }
        
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        
        AuthManager.shared.checkIfUserExist(phoneNumber: phoneNumber) { documentSnapshot, error in
            if let error = error {
                print("Error fetching user:", error.localizedDescription)
            } else if let documentSnapshot = documentSnapshot {
                self.login(userName: documentSnapshot.data()?["userName"] as? String ?? "", phoneNumber: phoneNumber)
            } else {
                print("User Not Exist Pleaase signUP")
                showAlert(title: "User Not Exist Pleaase signUP", message: "", viewController: self)
            }
        }
    }
    
    func login(userName: String , phoneNumber: String) {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber("+91\(phoneNumber)", uiDelegate: nil) { [self] verificationID, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            // Save verification ID for later use
            Utils.authVerificationID = verificationID
            // Present view controller to enter SMS code for verification
            // You can navigate to the SMS verification view controller here
            mobileTextField.isHidden = true
            codeTextField.isHidden = false
            loginButton.setTitle("Verify", for: .normal)
            loginButton.setTitle("Verify", for: .selected)
            if !codeTextField.isHidden {
                verifyCode(userName: userName, mobile: phoneNumber)
            }
        }
    }
    
    func verifyCode(userName: String, mobile: String) {
        guard let verificationID = Utils.authVerificationID else {
            print("Error: Verification ID not found")
            return
        }
        guard let code = codeTextField.text else {
            Utils.showToast(message: "Please enter valid code")
            return
        }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code) // replace "123456" with actual SMS code entered by the user
        Auth.auth().signIn(with: credential) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            // User signed in successfully
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = userName
            changeRequest.commitChanges { error in
                if let error = error {
                    print("Failed To login user: \(error)")
                    showAlert(title: "Failed To login user", message: "", viewController: self)
                } else {
                    print("Login Succesfully")
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    mainTabBarController.selectedIndex = 0
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @objc private func handleTapOnView() {
        mobileTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
    
    @objc private func handleTextInputChange() {
        var isFormValid = false
        if !codeTextField.isHidden {
            if (codeTextField.text?.count ?? 0) > 5 {
                isFormValid = true
            }else {
                isFormValid = false
            }
        }else {
            if (mobileTextField.text?.count ?? 0) == 10 {
                isFormValid = true
            }else {
                isFormValid = false
            }
        }
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.mainBlue
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc private func handleShowSignUp() {
        navigationController?.pushViewController(SignUpController(), animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
