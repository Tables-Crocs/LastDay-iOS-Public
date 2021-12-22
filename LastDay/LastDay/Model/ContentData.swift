//
//  ContentData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/23.
//

import Foundation

struct ContentData: Codable {
  let id: String
  let contentType: String
  let title: String
  let overview: String
  let imageUrl: String?
  let thumbnailUrl: String?
  let images: [[String:String]]
  let location: [String:Double]
  
  enum CodingKeys: String, CodingKey {
    case id = "contentId"
    case contentType = "content_type"
    case title
    case overview
    case imageUrl = "image"
    case thumbnailUrl = "thumbnail"
    case images
    case location
  }
}
