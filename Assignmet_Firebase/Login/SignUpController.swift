//
//  ViewController.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 3/16/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UINavigationControllerDelegate {
    
    private lazy var mobileTextField: UITextField = {
        let tf = UITextField()
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.keyboardType = .emailAddress
        tf.placeholder = Const.mobilePlaceholder
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Const.userNamePlaceholder
        tf.autocorrectionType = .no
        tf.autocapitalizationType = .none
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var codeTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = Const.codePlaceholder
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Const.signUP, for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: Const.alreadyHaveAnAccount, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: Const.signIn, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.mainBlue
            ]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    private var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnView)))
        codeTextField.isHidden = true
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, height: 50)
        setupInputFields()
    }
    
    private func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [mobileTextField, usernameTextField, codeTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingRight: 40)
    }
    
    private func resetInputFields() {
        
        mobileTextField.isUserInteractionEnabled = true
        usernameTextField.isUserInteractionEnabled = true
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
    @objc private func handleTapOnView(_ sender: UITextField) {
        usernameTextField.resignFirstResponder()
        mobileTextField.resignFirstResponder()
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
            if (mobileTextField.text?.count ?? 0) == 10 && !(usernameTextField.text?.isEmpty ?? false){
                isFormValid = true
            }else {
                isFormValid = false
            }
        }
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.mainBlue
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
    }
    
    @objc private func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleSignUp() {
        guard let phoneNumber = mobileTextField.text else { return }
        guard let userName = usernameTextField.text else { return }
        
        signUpButton.isEnabled = false
        signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        
        
        AuthManager.shared.checkIfUserExist(phoneNumber: phoneNumber) { documentSnapshot, error in
            if let error = error {
                print("Error fetching user:", error.localizedDescription)
            } else if let documentSnapshot = documentSnapshot {
                print("User Exists Pleaase login")
                showAlert(title: Err.userNotExistPleaaseLogin, message: "", viewController: self)
            } else {
                self.signUp(phoneNumber: phoneNumber)
            }
        }
    }
    
    func signUp(phoneNumber: String) {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        PhoneAuthProvider.provider().verifyPhoneNumber("+91\(phoneNumber)", uiDelegate: nil) { [self] verificationID, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            Utils.authVerificationID = verificationID
            mobileTextField.isHidden = true
            usernameTextField.isHidden = true
            codeTextField.isHidden = false
            signUpButton.setTitle(Const.verify, for: .normal)
            signUpButton.setTitle(Const.verify, for: .selected)
            if !codeTextField.isHidden {
                verifyCode(userName: usernameTextField.text ?? "", mobile: phoneNumber)
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
                    print("Failed To Create user: \(error)")
                    showAlert(title: Err.failedToCreateUser, message: "", viewController: self)
                } else {
                    print("Login Succesfully")
                    AuthManager.shared.uploadUser(withUID: user.uid, username: userName, mobile: mobile) {status in
                        if status {
                            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                            mainTabBarController.setupViewControllers()
                            mainTabBarController.selectedIndex = 0
                            self.dismiss(animated: true, completion: nil)
                        }else {
                            print("Failed To Create User In colelction")
                        }
                    }
                }
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
