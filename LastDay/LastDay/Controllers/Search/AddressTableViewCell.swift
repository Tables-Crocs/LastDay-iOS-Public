//
//  AddressTableViewCell.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var addressLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func setInfo(data: AddressData) {
    titleLabel.text = data.title
    addressLabel.text = data.address
  }
  
}
