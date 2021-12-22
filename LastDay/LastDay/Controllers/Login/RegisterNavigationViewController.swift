//
//  RegisterNavigationViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class RegisterNavigationViewController: UINavigationController {
  
  
  var nextVC: String!
  var email: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBar.barTintColor = UIColor.white
    navigationBar.tintColor = UIColor.mainTintColor
    navigationBar.clipsToBounds = true
    
    pushRootVC()
  }
  
  
  private func pushRootVC() {
    
    if nextVC == "code" {
      let vc = storyboard?.instantiateViewController(withIdentifier: "CodeViewController") as! CodeViewController
      guard let email = email else {
        print("no email")
        return
      }
      vc.email = email
      pushViewController(vc, animated: true)
    } else {
      let vc = storyboard?.instantiateViewController(withIdentifier: "PolicyAgreeViewController") as! PolicyAgreeViewController
      pushViewController(vc, animated: true)
    }
 
  }
  
}
