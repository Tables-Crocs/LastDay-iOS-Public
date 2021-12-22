//
//  ReplyTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/26.
//

import UIKit

class ReplyTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var replyLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var commentButton: UIButton!
  
  weak var delegate: ReplyCellDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func setInfo(userName: String, content: String, time: String, mine: Bool) {
    nameLabel.text = userName
    replyLabel.text = content
    timeLabel.text = time
    if mine {
      commentButton.setTitle("삭제", for: .normal)
    } else {
      commentButton.setTitle("신고", for: .normal)
    }
    
    
  }
  
  @IBAction func buttonTapped(_ sender: Any) {
    delegate?.btnCTapped(cell: self)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
