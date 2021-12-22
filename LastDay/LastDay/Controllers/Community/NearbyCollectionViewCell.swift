//
//  NearbyCollectionViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/22.
//

import UIKit

class NearbyCollectionViewCell: UICollectionViewCell {
  
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  @IBOutlet weak var grayView: UIView!
  override func awakeFromNib() {
    super.awakeFromNib()
    
    layer.cornerRadius = 8
    clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
  }
  
  
  func setInfo(image: UIImage, name: String) {
    grayView.isHidden = false
    imageView.image = image
    nameLabel.text = name
    
  }
}
