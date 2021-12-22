//
//  LoadingView.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/15.
//

import UIKit

class LoadingView: UIView {

  override func awakeFromNib() {
    backgroundColor = UIColor.white
  }
  
  func isLoading() {
    isHidden = false
  }
  
  func doneLoading() {
    isHidden = true
  }

}
