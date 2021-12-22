//
//  LocationTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/15.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
  
  
  @IBOutlet weak var locationLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setInfo(data: StationData) {
    locationLabel.text = data.station
  }
}
