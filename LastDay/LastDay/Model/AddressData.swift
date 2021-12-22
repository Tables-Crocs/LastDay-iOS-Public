//
//  AddressData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import Foundation

struct AddressData: Codable {
  let title: String
  let address: String
  let locations: [String:String]

  
  enum CodingKeys: String, CodingKey {
    case title
    case address
    case locations = "location"
  }
}
