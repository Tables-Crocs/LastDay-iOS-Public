//
//  SearchResultTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/10.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

  @IBOutlet weak var placeImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  
  
  @IBOutlet weak var lookTimeLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  @IBOutlet weak var totalTimeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    placeImage.layer.cornerRadius = 8
    placeImage.layer.borderWidth = 0.5
    placeImage.layer.borderColor = UIColor.lightGrayBorderColor.cgColor
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setInfo(data: RecommendData) {
    nameLabel.text = data.title
    addressLabel.text = "\(data.address)"
    totalTimeLabel.text = "\(data.travelTime)분"
    lookTimeLabel.text = "약 \(data.freeTime)분"
  }
  
  func setImage(image: UIImage) {
    placeImage.image = image
    placeImage.layer.borderWidth = 0

  }
  func setDefaultImg() {
    let img = UIImage(named: "profileLogo") ?? UIImage()
    placeImage.image = img
    placeImage.layer.borderWidth = 0.5
    
  }
  
}
