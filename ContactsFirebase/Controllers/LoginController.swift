//
//  LoginSignUpController.swift
//  ContactsFirebase
//
//  Created by Jun Dang on 2019-01-04.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SkyFloatingLabelTextField

protocol handleButtonAndTextFieldDelegate: class{
    func displaySignUpCell()
    func displayLoginCell()
    func handleLogin()
    func handleSignUp()
    func recoverPassword()
 
}

class LoginController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, handleButtonAndTextFieldDelegate, UITextFieldDelegate {
    
    let signUpCellId = "signUpCellId"
    let loginCellId = "loginCellId"
    let cellId = "cellId"
    var loginButtonSelected: Bool = true
    var firstNameTextField: UITextField?
    var lastNameTextField: UITextField?
    var emailTextField: UITextField?
    var passwordTextField: UITextField?
    var retypePasswordTextField: UITextField?
    var loginEmailTextField: UITextField?
    var loginPasswordTextField: UITextField?
    var activeTextField: SkyFloatingLabelTextField?
    var isFirstNameValid: Bool = false
    var isLastNameValid: Bool = false
    var isEmailValid: Bool = false
    var isPasswordValid: Bool = false
    var isPasswordConfirmed: Bool = false
    var isLoginEmailValid: Bool = false
    var notEmptyPassword: Bool = false
    var isEmailRegisterd: Bool = false

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
        
        view.addSubview(collectionView)
     
        setUpCollectionView()
        collectionView.backgroundColor = .azure
        registerCells()
    }
    
    func setUpCollectionView() {
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    func registerCells() {
        collectionView.register(SignUpCell.self, forCellWithReuseIdentifier:signUpCellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -100 : -50
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func displaySignUpCell() {
        loginButtonSelected = false
        collectionView.reloadData()
    }
    
    func displayLoginCell() {
        loginButtonSelected = true
        collectionView.reloadData()
    }
    func handleLogin() {
        view.endEditing(true)
        
        if isLoginEmailValid && notEmptyPassword {
            guard let email = loginEmailTextField!.text, let password = loginPasswordTextField!.text else {
                disPlayError("pelase check email and password fields")
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                
                if let error = error {
                    self.disPlayError("\(error)")
                    return
                }
                
                 self.navigationController?.pushViewController(ContactsTableViewController(), animated: true)
                
            })
        } else {
            if !isLoginEmailValid {
                disPlayError("Please enter valid email address")
            }
            if !notEmptyPassword {
                disPlayError("password field cannot be empty")
            }
        }
    }
    
    func handleSignUp() {
        
        view.endEditing(true)
      
        if isFirstNameValid && isLastNameValid && isEmailValid && isPasswordValid && isPasswordConfirmed {
            signUpUsers()
        } else {
            if !isFirstNameValid {
                disPlayError("First name can not be empty and should only contains letters")
            }
            if !isLastNameValid {
                disPlayError("Last name can not be empty and should only contains letters")
            }
            if !isEmailValid {
                disPlayError("Please enter valid email address")
            }
            if !isPasswordConfirmed {
                disPlayError("the passwords entered are not the same")
            }
            if !isPasswordValid {
                disPlayError("password should be at least 6 characters")
            }
        }
    }
    
    func signUpUsers() {
        guard let firstName = self.firstNameTextField!.text, let lastName = self.lastNameTextField!.text, let email = self.emailTextField!.text, let password = self.passwordTextField!.text else {
            return
        }
        
        let ref = Database.database().reference()
        
        let values = ["first name": firstName, "last name": lastName, "email": email]
    
        Auth.auth().fetchProviders(forEmail: email, completion: {
            (providers, error) in
            
            if let error = error {
                self.disPlayError("\(error.localizedDescription)")
                 self.isEmailRegisterd = true
            } else if let providers = providers {
                self.isEmailRegisterd = true
                print(providers)
                self.disPlayError("email address has been registerd")
            }
        })
        
        if !isEmailRegisterd {
            Auth.auth().createUser(withEmail: email, password: password, completion: { (res, error) in
                
                if let error = error {
                    print(error)
                    return
                }
                
                guard let uid = res?.user.uid else {
                    return
                }
                
                let contactsReference = ref.child("users").child(uid)
                
                contactsReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    self.navigationController?.pushViewController(ContactsTableViewController(), animated: true)
                })
            })
            
        }
    }
    
    func recoverPassword() {
        //will implement later
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if loginButtonSelected {
            let loginCell: LoginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
           
            self.loginEmailTextField = loginCell.emailTextField as UITextField
            self.loginEmailTextField?.tag = 5
            self.loginEmailTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.loginEmailTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
            
            self.loginPasswordTextField = loginCell.loginPasswordTextField as UITextField
            self.loginPasswordTextField?.tag = 6
            self.loginPasswordTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.loginPasswordTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
            
            return loginCell
        } else {
            let signUpCell: SignUpCell = collectionView.dequeueReusableCell(withReuseIdentifier: signUpCellId, for: indexPath) as! SignUpCell
            signUpCell.delegate = self
            
            self.firstNameTextField = signUpCell.firstNameTextField as UITextField
            self.firstNameTextField?.tag = 0
            self.firstNameTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.firstNameTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
          
            self.lastNameTextField = signUpCell.lastNameTextField as UITextField
            self.lastNameTextField?.tag = 1
            self.lastNameTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.lastNameTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
            
            self.emailTextField = signUpCell.emailTextField as UITextField
            self.emailTextField?.tag = 2
            self.emailTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.emailTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
            
            self.passwordTextField = signUpCell.passwordTextField as UITextField
            self.passwordTextField?.tag = 3
            self.passwordTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.passwordTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
            
            self.retypePasswordTextField = signUpCell.retypePasswordTextField as UITextField
            self.retypePasswordTextField?.tag = 4
            self.retypePasswordTextField?.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            self.retypePasswordTextField?.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEndOnExit)
            
            return signUpCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    @objc func textFieldEditingChanged(_ textfield: UITextField) {
        
        if textfield.tag == 0 {
            if let text = textfield.text{
                activeTextField = self.firstNameTextField as? SkyFloatingLabelTextField
                if !text.isValidName() {
                    activeTextField?.errorMessage = "Invalid first Name"
                    isFirstNameValid = false
                }
                else {
                    activeTextField?.errorMessage = ""
                    isFirstNameValid = true
                }
            }
        } else if textfield.tag == 1 {
            if let text = textfield.text{
                activeTextField = self.lastNameTextField as? SkyFloatingLabelTextField
                if !text.isValidName() {
                    activeTextField?.errorMessage = "Invalid last Name"
                    isLastNameValid = false
                } else {
                    activeTextField?.errorMessage = ""
                    isLastNameValid = true
                }
            }
            
        } else if textfield.tag == 2 {
            if let text = textfield.text{
                activeTextField = self.emailTextField as? SkyFloatingLabelTextField
                if !text.isValidEmail() {
                     activeTextField?.errorMessage = "Invalid email"
                     isEmailValid = false
                } else {
                    activeTextField?.errorMessage = ""
                    isEmailValid = true
                }
             }
        } else if textfield.tag == 3 {
            if let text = textfield.text{
                activeTextField = self.passwordTextField as? SkyFloatingLabelTextField
                if !text.isValidPassword(){
                    activeTextField?.errorMessage = "Please include at least 6 characters."
                    isPasswordValid = false
                }
                else {
                    activeTextField?.errorMessage = ""
                    isPasswordValid = true
                }
                
                if let retypPassword = self.retypePasswordTextField!.text {
                    if !text.elementsEqual(retypPassword){
                        isPasswordConfirmed = false
                    } else {
                        isPasswordConfirmed = true
                    }
                 }
            }
        } else if textfield.tag == 4 {
            if let text = textfield.text{
                activeTextField = self.retypePasswordTextField as? SkyFloatingLabelTextField
                if let passWordText = self.passwordTextField!.text {
                    if !text.elementsEqual(passWordText){
                       activeTextField?.errorMessage = "Input should be the same as the password."
                       isPasswordConfirmed = false
                    }
                    else {
                       activeTextField?.errorMessage = ""
                       isPasswordConfirmed = true
                    }
               }
            }
        } else if textfield.tag == 5 {
            if let text = textfield.text{
                activeTextField = self.loginEmailTextField as? SkyFloatingLabelTextField
                if !text.isValidEmail() {
                    activeTextField?.errorMessage = "Invalid email"
                    isLoginEmailValid = false
                } else {
                    activeTextField?.errorMessage = ""
                    isLoginEmailValid = true
                }
            }
        }else if textfield.tag == 6 {
            if let text = textfield.text{
                activeTextField = self.loginPasswordTextField as? SkyFloatingLabelTextField
                if text.count == 0 {
                    activeTextField?.errorMessage = "Please input password"
                    notEmptyPassword = false
                }
                else {
                    activeTextField?.errorMessage = ""
                    notEmptyPassword = true
                }
            }
        }
   }
    
   @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            activeTextField = self.firstNameTextField as? SkyFloatingLabelTextField
        } else if textField.tag == 1 {
            activeTextField = self.lastNameTextField as? SkyFloatingLabelTextField
        } else if textField.tag == 2 {
            activeTextField = self.emailTextField as? SkyFloatingLabelTextField
        } else if textField.tag == 3 {
            activeTextField = self.passwordTextField as? SkyFloatingLabelTextField
        } else if textField.tag == 4 {
            activeTextField = self.retypePasswordTextField as? SkyFloatingLabelTextField
        } else if textField.tag == 5 {
            activeTextField = self.loginEmailTextField as? SkyFloatingLabelTextField
        } else if textField.tag == 6 {
            activeTextField = self.loginPasswordTextField as? SkyFloatingLabelTextField
        }
        activeTextField?.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}

