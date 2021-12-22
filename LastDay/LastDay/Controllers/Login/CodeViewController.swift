//
//  CodeViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class CodeViewController: UIViewController {
  
  @IBOutlet weak var codeTextField: UITextField!
  
  
  @IBOutlet weak var submitButton: UIButton!
  
  var email: String!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTextFields()
    setSubmitButton()
  }
  
  private func setTextFields() {
    codeTextField.layer.borderColor = UIColor.lightGray.cgColor
    codeTextField.layer.borderWidth = 1
    codeTextField.layer.cornerRadius = 8
    
    
    codeTextField.delegate = self

    
  }
  private func setSubmitButton() {

    
    submitButton.layer.cornerRadius = submitButton.layer.bounds.height / 2
    submitButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    submitButton.setTitleColor(UIColor.white, for: .normal)
    
    submitButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    submitButton.layer.shadowOpacity = 1.0
    submitButton.layer.shadowOffset = CGSize.zero
  }
  
  @IBAction func submit(_ sender: Any) {
    
    let code = codeTextField.text ?? ""
    let email = email ?? ""
    if code == "" {
      codeTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else if !email.isValidEmail() {
      return
    } else {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        LoginService.shared.verifyCode(email: email, code: code) { networkResult in
          switch networkResult {
          case .success(let data):
            if let data = data as? VerifyData {
              UserDefaults.standard.setValue(data.token, forKey: UserDefaultKeys.userToken)
              UserDefaults.standard.setValue(AuthCompany.email.rawValue, forKey: UserDefaultKeys.recentAuthType)
              UserDefaults.standard.synchronize()
              print(data.isNew)
              
              
              guard let window = self.view.window else { return }
              
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
              
              
            }
          case .requestErr(let message):
            if let message = message as? String {
              print("not a user")
              print(message)

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
    }
    
    
  }
  
}

extension CodeViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    codeTextField.resignFirstResponder()
    
    return false
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.mainTintColor.cgColor
  }
}
