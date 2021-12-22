//
//  RegisterViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class RegisterViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!
  
  
  @IBOutlet weak var verificationTextField: UITextField!
  
  @IBOutlet weak var registerButton: UIButton!
  

  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTextFields()
    setRegisterbutton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  
  private func setTextFields() {
    emailTextField.layer.borderColor = UIColor.lightGray.cgColor
    emailTextField.layer.borderWidth = 1
    emailTextField.layer.cornerRadius = 8
    
    passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
    passwordTextField.layer.borderWidth = 1
    passwordTextField.layer.cornerRadius = 8
    
    nameTextField.layer.borderColor = UIColor.lightGray.cgColor
    nameTextField.layer.borderWidth = 1
    nameTextField.layer.cornerRadius = 8
    
    verificationTextField.layer.borderColor = UIColor.lightGray.cgColor
    verificationTextField.layer.borderWidth = 1
    verificationTextField.layer.cornerRadius = 8
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
    nameTextField.delegate = self
    verificationTextField.delegate = self

    
  }
  
  private func setRegisterbutton() {

    
    registerButton.layer.cornerRadius = 8
    registerButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    registerButton.setTitleColor(UIColor.white, for: .normal)
    
    registerButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    registerButton.layer.shadowOpacity = 1.0
    registerButton.layer.shadowOffset = CGSize.zero
  }
  
  
  private func register(email: String, password: String, name: String, completion: @escaping () -> ()) {
    LoginService.shared.register(email: email, password: password, name: name) { networkResult in
      switch networkResult {
      case .success(_):
          completion()
      case .requestErr(let message):
        if let message = message as? String {
          print("not a user")
          print(message)
        }
        self.showNewtorkError()
      case .pathErr :
        print("pathErr")
        self.showNewtorkError()

      case .serverErr :
        print("serverErr")
        self.showNewtorkError()

      case .networkFail:
        self.showNewtorkError()

        print("networkFail")
        print("networkFail")
      }
    }
    
  }
  
  
  @IBAction func register(_ sender: Any) {
    for textField in self.view.subviews where textField is UITextField {
        textField.resignFirstResponder()
    }
    
    let email = emailTextField.text ?? ""
    let name = nameTextField.text ?? ""
    let password = passwordTextField.text ?? ""
    let verification = verificationTextField.text ?? ""
    
    if !email.isValidEmail() {
      emailTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else if name == "" {
      nameTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else if password == "" || password != verification {
      passwordTextField.layer.borderColor = UIColor.red.cgColor
      verificationTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.register(email: email, password: password, name: name) { [weak self] in
          
          UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.email)
          UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.password)
          UserDefaults.standard.setValue(name, forKey: UserDefaultKeys.userName)


          let vc = self?.storyboard?.instantiateViewController(withIdentifier: "RegisterNavigationViewController") as! RegisterNavigationViewController
          vc.nextVC = "code"
          vc.email = email
          vc.modalPresentationStyle = .fullScreen
          self?.present(vc, animated: true, completion: nil)
        }
      }
      
    }
 
  }
  
  
  @objc func dismissVC() {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "생성할 수 없는 이메일입니다.", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
}

extension RegisterViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == emailTextField {
      nameTextField.becomeFirstResponder()
    } else if textField == nameTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      verificationTextField.becomeFirstResponder()
    }else if textField == verificationTextField {
      verificationTextField.resignFirstResponder()
    }
    
    return false
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.mainTintColor.cgColor
  }
}
