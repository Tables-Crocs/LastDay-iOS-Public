//
//  PolicyAgreeViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class PolicyAgreeViewController: UIViewController {
  
  
  @IBOutlet weak var policyTextView: UITextView!
  @IBOutlet weak var infoTextField: UITextView!
  
  @IBOutlet weak var agreeButton: UIButton!
  
 
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTextField()
    setAgreeButton()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.isHidden = true
  }
  
  
  private func setTextField() {
    policyTextView.layer.borderColor = UIColor.mainTintColor.cgColor
    policyTextView.layer.borderWidth = 1
    policyTextView.layer.cornerRadius = 8
    
    infoTextField.layer.borderColor = UIColor.mainTintColor.cgColor
    infoTextField.layer.borderWidth = 1
    infoTextField.layer.cornerRadius = 8
  }
  
  private func setAgreeButton() {

    
    agreeButton.layer.cornerRadius = agreeButton.layer.bounds.height / 2
    agreeButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    agreeButton.setTitleColor(UIColor.white, for: .normal)
    
    agreeButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    agreeButton.layer.shadowOpacity = 1.0
    agreeButton.layer.shadowOffset = CGSize.zero
  }
  
  
  @IBAction func agree(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func dismissNVC(_ sender: Any) {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
}
