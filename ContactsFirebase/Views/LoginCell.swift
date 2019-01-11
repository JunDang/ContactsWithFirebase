//
//  LoginCell.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-04.
//  Copyright © 2019 Jun Dang. All rights reserved.
//


import UIKit
import SkyFloatingLabelTextField

class LoginCell: UICollectionViewCell {
    
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    let contactImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "contact")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .babyBlue
        button.setTitle("Sign Up", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(goToSignUp), for: .touchUpInside)
        
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .babyBlue
        button.setTitle("Login", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forgot Password?", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderWidth = 0
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        return button
    }()

    let emailTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Email"
        textField.selectedLineColor = .white
        textField.textColor = .white
        textField.titleColor = .babyBlue
        textField.errorColor = .burgundy
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let loginPasswordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Password"
        textField.textColor = .white
        textField.titleColor = .babyBlue
        textField.selectedLineColor = .white
        textField.errorColor = .burgundy
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let orLbl: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(contactImageView)
        addSubview(emailTextField)
        addSubview(loginPasswordTextField)
        addSubview(signUpButton)
        addSubview(loginButton)
        addSubview(orLbl)
        addSubview(forgotPasswordButton)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        contactImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        contactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60).isActive = true
        contactImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        contactImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalToConstant: 50)
        emailTextFieldHeightAnchor?.isActive = true
        
        loginPasswordTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        loginPasswordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        loginPasswordTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        passwordTextFieldHeightAnchor = loginPasswordTextField.heightAnchor.constraint(equalToConstant: 50)
        passwordTextFieldHeightAnchor?.isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: loginPasswordTextField.bottomAnchor, constant: 20).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        orLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        orLbl.topAnchor.constraint(equalTo: loginButton.bottomAnchor).isActive = true
        orLbl.widthAnchor.constraint(equalTo: contactImageView.widthAnchor).isActive = true
        orLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: orLbl.bottomAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        forgotPasswordButton.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 50).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
    }
    weak var delegate: handleButtonAndTextFieldDelegate?
    
   
    @objc func goToSignUp() {
        delegate?.displaySignUpCell()
    }
    
    @objc func handleLogin() {
        delegate?.handleLogin()
    }
    
    @objc func handleForgotPassword() {
       delegate?.recoverPassword()
    }
}
