//
//  ChangePwdViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class ChangePwdViewController: UIViewController {
  
  var NVCTitle: String!
  
  @IBOutlet weak var currentTextField: UITextField!
  @IBOutlet weak var newTextField: UITextField!
  @IBOutlet weak var verifyTextField: UITextField!
  
  
  @IBOutlet weak var changeButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTextFields()
    setChangeButton()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightBlackColor]
    self.title = NVCTitle
    navigationController?.navigationBar.barStyle = .default
  }
    


  
  private func setTextFields() {
    currentTextField.layer.borderColor = UIColor.lightGray.cgColor
    currentTextField.layer.borderWidth = 1
    currentTextField.layer.cornerRadius = 8
    
    newTextField.layer.borderColor = UIColor.lightGray.cgColor
    newTextField.layer.borderWidth = 1
    newTextField.layer.cornerRadius = 8
    
    verifyTextField.layer.borderColor = UIColor.lightGray.cgColor
    verifyTextField.layer.borderWidth = 1
    verifyTextField.layer.cornerRadius = 8
    
    currentTextField.delegate = self
    newTextField.delegate = self
    verifyTextField.delegate = self

  }
  
  private func setChangeButton() {

    changeButton.layer.cornerRadius = changeButton.layer.bounds.height / 2
    changeButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    changeButton.setTitleColor(UIColor.white, for: .normal)
    
    changeButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    changeButton.layer.shadowOpacity = 1.0
    changeButton.layer.shadowOffset = CGSize.zero
  }
  
  
  @IBAction func changeTapped(_ sender: Any) {
    let oldPassword = currentTextField.text ?? ""
    let newPassword = newTextField.text ?? ""
    let verify = verifyTextField.text ?? ""
    let dbPassword = UserDefaults.standard.string(forKey: UserDefaultKeys.password)
    
    guard let dbPassword = dbPassword else {
      return
    }

    if oldPassword != dbPassword {
      currentTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else if newPassword == "" || newPassword != verify {
      verifyTextField.layer.borderColor = UIColor.red.cgColor
      return
    } else {
      LoginService.shared.changePassword(oldPassword: oldPassword, newPassword: newPassword) { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          UserDefaults.standard.setValue(newPassword, forKey: UserDefaultKeys.password)
          self?.showChangedAlert()
          
        case .requestErr(let message):
          if let message = message as? String {
            print(message)
          }
          self?.showNewtorkError()
        case .pathErr :
          print("pathErr")
          self?.showNewtorkError()
        case .serverErr :
          print("serverErr")
          self?.showNewtorkError()
        case .networkFail:
          self?.showNewtorkError()
          print("networkFail")
        }
      }
    }
    
  }
  
  
  private func showChangedAlert() {
    let alertViewController = UIAlertController(title: "비밀번호 변경 완료", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: { (action) in
      self.navigationController?.popViewController(animated: true)
    })
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
  

}


extension ChangePwdViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    if textField == currentTextField {
      newTextField.becomeFirstResponder()
    } else if textField == newTextField {
      verifyTextField.becomeFirstResponder()
    } else if textField == verifyTextField {
      verifyTextField.resignFirstResponder()
    }
    
    return false
    
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.layer.borderColor = UIColor.mainTintColor.cgColor
  }
}
