//
//  NewPwdViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class NewPwdViewController: UIViewController {
  
  @IBOutlet weak var generateButton: UIButton!
  @IBOutlet weak var emailTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTextFields()
    setGenerateButton()
    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = false
  }
  
  private func setTextFields() {
    emailTextField.layer.borderColor = UIColor.lightGray.cgColor
    emailTextField.layer.borderWidth = 1
    emailTextField.layer.cornerRadius = 8
    

    
    emailTextField.delegate = self
    
  }
  
  private func setGenerateButton() {

    
    generateButton.layer.cornerRadius = 8
    generateButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    generateButton.setTitleColor(UIColor.white, for: .normal)
    
    generateButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    generateButton.layer.shadowOpacity = 1.0
    generateButton.layer.shadowOffset = CGSize.zero
  }
  
  @IBAction func generate(_ sender: Any) {
    
    let email = emailTextField.text ?? ""
    if !email.isValidEmail() {
      emailTextField.layer.borderColor = UIColor.red.cgColor
      return
    }
    
    LoginService.shared.generateNewPwd(email: email) { [weak self] networkResult in
      let alertViewController = UIAlertController(title: "새 비밀번호 생성", message: "새로운 비밀번호가 이메일로 전송 되었습니다.", preferredStyle: .alert)
      
      let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: { (action) in
        self?.navigationController?.popViewController(animated: true)
      })
      alertViewController.addAction(cancelAction)
      self?.present(alertViewController, animated: true, completion: nil)
    }
    
    
    
  }
}

extension NewPwdViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    emailTextField.resignFirstResponder()
    return false
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.mainTintColor.cgColor
  }
}

