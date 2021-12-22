//
//  BarButton.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class BarButton: UIButton {
  
  var defaultImage: UIImage?
  var selectedImage: UIImage?
  
  // FIXME: 색깔 나오면 수정할 부분
  var selectedColor: UIColor! = .white {
    didSet {
      reloadAppearance()
    }
  }
  
  // FIXME: 색깔 나오면 수정할 부분
  var unselectedColor: UIColor! = .white {
    didSet {
      reloadAppearance()
    }
  }
  
  override var isSelected: Bool {
    didSet {
      if isSelected {
        setImage(selectedImage, for: .normal)
      } else {
        setImage(defaultImage, for: .normal)
      }
      reloadAppearance()
    }
  }
  
  func reloadAppearance() {
    tintColor = isSelected ? selectedColor : unselectedColor
  }
  
  init(forItem item: UITabBarItem) {
    super.init(frame: .zero)
    setImage(item.image, for: .normal)
  }
  
  init(image: UIImage, selected: UIImage) {
    super.init(frame: .zero)
    defaultImage = image
    selectedImage = selected
    setTitleColor(self.tintColor, for: .highlighted)
    setImage(image, for: .normal)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
