//
//  AnnouncementData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import Foundation

struct AnnouncementData: Codable {
  let title: String
  let text: String
  let date: String
  
  enum CodingKeys: String, CodingKey {
    case title
    case text
    case date
  }
}
