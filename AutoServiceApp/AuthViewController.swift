//
//  AuthViewController.swift
//  AutoServiceApp
//
//  Created by Фаддей Гусаров on 4/6/23.
//

import SnapKit
import UIKit

class AuthViewController: UIViewController {
    
    //UI
    private var mainLogoImageView = UIImageView()
    private var phoneNumberTextField = UITextField()
    private var passwordTextField = UITextField()
    private var logInButton = UIButton()
    
    //Properties
    private var isValidate = false
    
    // View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.phoneNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        
        self.mainLogoImageView.alpha = 0
        self.phoneNumberTextField.alpha = 0
        self.passwordTextField.alpha = 0
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.mainLogoImageView.alpha = 1
            self.phoneNumberTextField.alpha = 1
            self.passwordTextField.alpha = 1
        }
    }
    
    // SnapKit methods
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.addSubview(self.mainLogoImageView)
        
        self.mainLogoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(self.view.frame.height / 4)
        }
        
        self.view.addSubview(self.phoneNumberTextField)
        
        self.phoneNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(self.view.frame.width / 1.3)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.mainLogoImageView.snp.bottom).offset(30)
        }
        
        self.view.addSubview(self.passwordTextField)
        
        self.passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(self.view.frame.width / 1.3)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.phoneNumberTextField.snp.bottom).offset(30)
        }
        
        self.view.addSubview(self.logInButton)
        
        self.logInButton.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width / 2)
            make.height.equalTo(40)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.mainLogoImageView.image = UIImage(named: "mainLogo")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    //private functions
    private func setupUI() {
        
        self.setupTextFields(textField: self.phoneNumberTextField, placeHolder: "Номер телефона")
    
        self.phoneNumberTextField.keyboardType = .phonePad
        self.phoneNumberTextField.addTarget(self, action: #selector(numberEditingBegan), for: .editingDidBegin)
        self.phoneNumberTextField.addTarget(self, action: #selector(numberEditingChanged), for: .editingChanged)
        
        self.setupTextFields(textField: self.passwordTextField, placeHolder: "Пароль")
        self.passwordTextField.addTarget(self, action: #selector(passwordIsValidate), for: .editingChanged)
        self.passwordTextField.isSecureTextEntry = true
        
        self.logInButton.setTitle("Войти", for: .normal)
        self.logInButton.backgroundColor = UIColor(red: 251 / 255, green: 185 / 255, blue: 0, alpha: 1)
        self.logInButton.layer.cornerRadius = 10
        self.logInButton.layer.borderWidth = 1
        self.logInButton.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        self.logInButton.setTitleColor(.black, for: .normal)
        self.logInButton.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
    }
    
    private func setupTextFields(textField: UITextField, placeHolder: String) {
        
        textField.tintColor = .black
        textField.placeholder = placeHolder
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(red: 251 / 255, green: 185 / 255, blue: 0, alpha: 1)
        textField.textAlignment = .center
        textField.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        textField.layer.borderWidth = 1
    }
    
    private func setupAlertController(title: String, message: String, backButtonTitile: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: backButtonTitile, style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // OBJ-C methods for targets
    @objc private func numberEditingBegan(_ textField: UITextField) {
        
        if textField.text == "" {
            textField.text = "+7"
        }
    }
    
    @objc private func numberEditingChanged(_ textField: UITextField) {
        
        if textField.text?.count ?? 0 < 2 {
            textField.text = "+7"
        }
    }
    
    @objc private func passwordIsValidate(_ textField: UITextField){
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$")

        if passwordPredicate.evaluate(with: textField.text ?? "") {
            self.isValidate = true
        } else {
            self.isValidate = false
        }
    }
    
    @objc private func logInButtonPressed() {
        switch self.isValidate {
        case true:
            if self.phoneNumberTextField.text?.count != 12 {
        
                self.setupAlertController(title: "Неверный номер телефона", message: "Введите корректный номер телефона", backButtonTitile: "Назад")
            }
        case false:
            if self.phoneNumberTextField.text != "" && self.passwordTextField.text != "" {
                
                self.setupAlertController(title: "Ошибка создания пароля", message: "Пароль должен содержать хотя бы одну заглавную букву и хотя бы одно число!", backButtonTitile: "Назад")
            } else {
                
                self.setupAlertController(title: "Заполните все поля", message: "Введите свой номер телефона и придумайте пароль!", backButtonTitile: "Назад")
            }
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.phoneNumberTextField {
            
            let maxLength = 12
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            
            return newString.count <= maxLength
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
