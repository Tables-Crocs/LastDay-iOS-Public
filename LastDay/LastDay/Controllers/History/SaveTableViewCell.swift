//
//  SaveTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/11.
//

import UIKit

class SaveTableViewCell: UITableViewCell {

  
  @IBOutlet weak var startLabel: UILabel!
  @IBOutlet weak var midLabel: UILabel!
  @IBOutlet weak var endLabel: UILabel!
  
  @IBOutlet weak var wrapperView: UIView!
  
  @IBOutlet weak var searchDateLabel: UILabel!
  
  @IBOutlet weak var searchTimeLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()

    
    wrapperView.layer.cornerRadius = 16
    wrapperView.layer.shadowColor = UIColor.lightGray.cgColor
    wrapperView.layer.shadowOpacity = 0.5
    wrapperView.layer.shadowOffset = CGSize.zero
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  
  func setInfo(data: HistoryData) {
    startLabel.text = data.sourceTitle
    midLabel.text = data.contentTitle
    endLabel.text = data.destTitle
    searchDateLabel.text = data.fmtDate
    searchTimeLabel.text = data.fmtTime
    timeLabel.text = "\(data.timeTaken)분"
//    timeLabel.text = data.
  }
  
}
