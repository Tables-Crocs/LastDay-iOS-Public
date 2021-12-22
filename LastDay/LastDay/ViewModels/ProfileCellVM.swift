//
//  ProfileCellVM.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/11.
//

import UIKit

class ProfileCellVM {
  let image: UIImage
  let name: String
  let category: Int
  
  init(image: UIImage, name: String, category: Int) {
    self.image = image
    self.name = name
    self.category = category
  }
}
