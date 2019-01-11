//
//  SignUpCell.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-04.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpCell: UICollectionViewCell {
    
    var lastNameTextFieldHeightAnchor: NSLayoutConstraint?
    var firstNameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var retypePasswordTextFieldHeightAnchor: NSLayoutConstraint?
   
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
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
  
        return button
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .babyBlue
        button.setTitle("Login", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        
        return button
    }()

    
    let lastNameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Last Name"
        textField.textColor = .white
        textField.lineColor = .babyBlue
        textField.titleColor = .babyBlue
        textField.selectedLineColor = .white
        textField.errorColor = .burgundy
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let firstNameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "First Name"
        textField.selectedLineColor = .white
        textField.textColor = .white
        textField.titleColor = .babyBlue
        textField.errorColor = .burgundy
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
   
    let passwordTextField: SkyFloatingLabelTextField = {
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
    
    let retypePasswordTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.placeholder = "Confirm Password"
        textField.selectedLineColor = .white
        textField.textColor = .white
        textField.titleColor = .babyBlue
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
        addSubview(firstNameTextField)
        addSubview(lastNameTextField)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(retypePasswordTextField)
        addSubview(signUpButton)
        addSubview(loginButton)
        addSubview(orLbl)
        
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
        
        firstNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: contactImageView.bottomAnchor, constant: 12).isActive = true
        firstNameTextFieldHeightAnchor = firstNameTextField.heightAnchor.constraint(equalToConstant: 50)
        firstNameTextFieldHeightAnchor?.isActive = true
        
        lastNameTextField.leftAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.topAnchor).isActive = true
        lastNameTextFieldHeightAnchor = lastNameTextField.heightAnchor.constraint(equalToConstant: 50)
        lastNameTextFieldHeightAnchor?.isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 12).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalToConstant: 50)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 5).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalToConstant: 50)
        passwordTextFieldHeightAnchor?.isActive = true
        
        retypePasswordTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        retypePasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 5).isActive = true
        retypePasswordTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        retypePasswordTextFieldHeightAnchor = retypePasswordTextField.heightAnchor.constraint(equalToConstant: 50)
        retypePasswordTextFieldHeightAnchor?.isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: retypePasswordTextField.bottomAnchor, constant: 20).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        orLbl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        orLbl.topAnchor.constraint(equalTo: signUpButton.bottomAnchor).isActive = true
        orLbl.widthAnchor.constraint(equalTo: contactImageView.widthAnchor).isActive = true
        orLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: orLbl.bottomAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
       
    }
  
    weak var delegate: handleButtonAndTextFieldDelegate?
    
    @objc func handleSignUp() {
         delegate?.handleSignUp()
    }
    
    @objc func goToLogin() {
         delegate?.displayLoginCell()
    }


}

