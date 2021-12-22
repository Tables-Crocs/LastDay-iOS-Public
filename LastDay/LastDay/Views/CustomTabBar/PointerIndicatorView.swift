//
//  PointerIndicatorView.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class PointIndicatorView: UIView {
  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.bounds.width / 2
  }
  
  override func tintColorDidChange() {
    super.tintColorDidChange()
    self.backgroundColor = tintColor
  }
}
