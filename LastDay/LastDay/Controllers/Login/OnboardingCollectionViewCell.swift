//
//  OnboardingCollectionViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
  
  @IBOutlet weak var imgView: UIImageView!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    

  }
  
  func setInformation(image: UIImage) {
    imgView.image = image
  }
}
