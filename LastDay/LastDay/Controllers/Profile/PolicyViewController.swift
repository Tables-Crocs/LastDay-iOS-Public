//
//  PolicyViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class PolicyViewController: UIViewController {
  
  var NVCTitle: String!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightBlackColor]
    self.title = NVCTitle
    navigationController?.navigationBar.barStyle = .default

  }
  
  

  
}
