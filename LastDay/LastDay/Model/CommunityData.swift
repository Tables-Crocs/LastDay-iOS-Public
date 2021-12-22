//
//  CommunityData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/28.
//

import Foundation

struct CommunityData: Codable {
  let id: String
  let province: String
  let provAbb: String
  let city: String
  let abb: String
  let imageURL: String
  let locations: [String:Double]
  let firstArticle: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case province
    case provAbb = "prov_abb"
    case city
    case abb
    case imageURL = "image"
    case locations
    case firstArticle = "first_article"
  }
}
