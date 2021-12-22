//
//  PostDetailData.swift
//  LastDay
//
//  Created by Sieun Lee on 2021/10/11.
//

import Foundation

struct PostDetailData: Codable {
  let postId: String
  let userId: String
  let mine: Bool
  let admin: Bool
  let title: String
  let content: String
  let likesCount: Int
  let scrapsCount: Int
  let commentsCount: Int
  let like: Bool
  let scrap: Bool
  let comments: [CommentsData]
  let createdTime: String

  
  enum CodingKeys: String, CodingKey {
    case postId
    case userId
    case mine
    case admin
    case title
    case content
    case likesCount
    case scrapsCount
    case commentsCount
    case like
    case scrap
    case comments
    case createdTime
    }
  
  struct CommentsData: Codable {
    let id: String
    let userId: String
    let mine: Bool
    let admin: Bool
    let postOwner: Bool
    let content: String
    let createdTime: String
    
    enum CodingKeys: String, CodingKey {
      case id = "_id"
      case userId
      case mine
      case admin
      case postOwner
      case content
      case createdTime
      
    }
  }
}

