//
//  AnnouncementTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class AnnouncementTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var titleLabel: UILabel!
  
  @IBOutlet weak var bodyLabel: UILabel!
  
  @IBOutlet weak var dateLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setInfo(data: AnnouncementData) {
    titleLabel.text = data.title
    bodyLabel.text = data.text
    dateLabel.text = data.date
    
  }
  
}
