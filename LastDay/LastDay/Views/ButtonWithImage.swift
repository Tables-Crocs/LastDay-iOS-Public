//
//  ButtonWithImage.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/22.
//

import UIKit

class ButtonWithImage: UIButton {
  
  override func layoutSubviews() {
    super.layoutSubviews()
    if imageView != nil {
      imageEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: (bounds.width - 50))
      titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
    }
  }
}
