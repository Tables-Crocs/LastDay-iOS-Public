//
//  RecommendData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import Foundation

struct RecommendData: Codable {
  let title: String
  let address: String
  let locations: [String:String]
  let travelTime: Int
  let freeTime: Int
  let id: String
  let image: String?
  
  enum CodingKeys: String, CodingKey {
    case title
    case address = "location_string"
    case locations = "location"
    case travelTime = "travel_time"
    case freeTime = "free_time"
    case id = "contentId"
    case image = "thumbnail"
  }
}
