//
//  PersonalPostData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import Foundation

struct PersonalPostData: Codable {
  let id: String
  let likes: [String]
  let scraps: [String]
  let content: String
  let boardId: String
  let title: String
  let userId: String
  let comments: [[String:String]]
  let createdTime: String
  let mine: Bool
  let admin: Bool

  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case likes
    case scraps
    case content
    case boardId
    case title
    case userId
    case comments
    case createdTime
    case mine
    case admin

  }
}
