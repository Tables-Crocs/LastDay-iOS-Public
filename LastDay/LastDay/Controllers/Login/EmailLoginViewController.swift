//
//  EmailLoginViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit
import KakaoSDKCommon

class EmailLoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  
  @IBOutlet weak var passwordTextField: UITextField!

  @IBOutlet weak var loginBtn: UIButton!
  
  @IBOutlet weak var errorLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTextFields()
    setLoginbutton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true

  }
  
  private func setTextFields() {
    emailTextField.layer.borderColor = UIColor.lightGray.cgColor
    emailTextField.layer.borderWidth = 1
    emailTextField.layer.cornerRadius = 8
    
    passwordTextField.layer.borderColor = UIColor.lightGray.cgColor
    passwordTextField.layer.borderWidth = 1
    passwordTextField.layer.cornerRadius = 8
    
    emailTextField.delegate = self
    passwordTextField.delegate = self
    
  }
  
  private func setLoginbutton() {
    errorLabel.textColor = UIColor.red

    
    loginBtn.layer.cornerRadius = 8
    loginBtn.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    loginBtn.setTitleColor(UIColor.white, for: .normal)
    
    loginBtn.layer.shadowColor = UIColor.mainTintColor.cgColor
    loginBtn.layer.shadowOpacity = 1.0
    loginBtn.layer.shadowOffset = CGSize.zero
  }
  
  private func emailLogin(email: String, password: String, completion: @escaping (EmailLoginData) -> Void) {
    LoginService.shared.emailLogin(email: email, password: password) { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? EmailLoginData else { return }
        
//        UserDefaults.standard.setValue(data.token, forKey: UserDefaultKeys.userToken)
        UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.email)
        UserDefaults.standard.setValue(data.name, forKey: UserDefaultKeys.userName)
        UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.password)
        
        completion(data)
      case .requestErr(let message):
        if let message = message as? String {
          print("not a user")
          print(message)
          self?.errorLabel.isHidden = false
        }
      case .pathErr :
        print("pathErr")
      case .serverErr :
        print("serverErr")
      case .networkFail:
        print("networkFail")
        print("networkFail")
      }
    }
  }
  
  @IBAction func login(_ sender: Any) {
    
    for textField in self.view.subviews where textField is UITextField {
        textField.resignFirstResponder()
    }
    
    let email = emailTextField.text ?? ""
    let password = passwordTextField.text ?? ""
    
    if !email.isValidEmail() {
      emailTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else if password == "" {
      passwordTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        self.emailLogin(email: email, password: password) { [weak self] loginData in
          if loginData.isVerified {
            UserDefaults.standard.setValue(loginData.token, forKey: UserDefaultKeys.userToken)

            UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.email)
            UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.password)
            UserDefaults.standard.setValue(loginData.name, forKey: UserDefaultKeys.userName)
            UserDefaults.standard.setValue(AuthCompany.email.rawValue, forKey: UserDefaultKeys.recentAuthType)
            guard let window = self?.view.window else { return }
            
            let sb = UIStoryboard.init(name: "TabBar", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "MainNavigationViewController")
            
            window.rootViewController = vc
            
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            
            UIView.transition(
              with: window,
              duration: duration,
              options: options,
              animations: {},
              completion: { completed in
              }
            )
          } else {
            print("not verified")
            UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.email)
            UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.password)
            UserDefaults.standard.setValue(loginData.name, forKey: UserDefaultKeys.userName)
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "CodeViewController") as! CodeViewController
            vc.email = email
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true, completion: nil)
          }
        }
      }
    }
    
  }
  
  @IBAction func dismissBtnTapped(_ sender: Any) {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func findPassword(_ sender: Any) {
    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPwdViewController") as! NewPwdViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}

extension EmailLoginViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == emailTextField {
      passwordTextField.becomeFirstResponder()
    } else if textField == passwordTextField {
      passwordTextField.resignFirstResponder()
    }
    
    return false
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.mainTintColor.cgColor
  }
}

