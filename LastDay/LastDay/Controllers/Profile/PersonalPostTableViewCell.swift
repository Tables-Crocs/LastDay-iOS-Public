//
//  PersonalPostTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class PersonalPostTableViewCell: UITableViewCell {
  
  @IBOutlet weak var userLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var thumbLabel: UILabel!
  @IBOutlet weak var messageLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setInfo(userName: String, title: String, commentsCount: Int, likesCount: Int, scrapsCount: Int, time: String) {
    userLabel.text = userName
    titleLabel.text = title
    timeLabel.text = time
    thumbLabel.text = String(likesCount)
    messageLabel.text = String(commentsCount)
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
}
