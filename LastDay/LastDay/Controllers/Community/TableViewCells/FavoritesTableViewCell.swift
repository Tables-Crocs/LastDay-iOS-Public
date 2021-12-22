//
//  FavoritesTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/22.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

  @IBOutlet weak var communityNameLabel: UILabel!
  @IBOutlet weak var articleTitleLabel: UILabel!
  @IBOutlet weak var newImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setInfo(community: String, title: String) {
    communityNameLabel.text = community
    articleTitleLabel.text = title
  }
}
