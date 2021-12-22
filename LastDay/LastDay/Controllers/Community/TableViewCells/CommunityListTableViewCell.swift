//
//  CommunityListTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/28.
//

import UIKit

class CommunityListTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var firstArticleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setInfo(data: CommunityData) {
    if data.provAbb == "" {
      titleLabel.text = data.abb
      
    } else {
      titleLabel.text = data.provAbb + " " + data.abb
      
    }
    firstArticleLabel.text = data.firstArticle
  }
  
}
