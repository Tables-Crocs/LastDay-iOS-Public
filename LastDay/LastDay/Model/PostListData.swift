//
//  PostListData.swift
//  LastDay
//
//  Created by Sieun Lee on 2021/10/10.
//

import Foundation

struct BoardData: Codable {
  let isFavorite: Bool
  let posts: [PostListData]

    
  enum CodingKeys: String, CodingKey {
    case isFavorite
    case posts
  }

}

struct PostListData: Codable {
  let id: String
  let userId: String
  let mine: Bool
  let admin: Bool
  let title: String
  let commentsCount: Int
  let likesCount: Int
  let scrapsCount: Int
  let createdTime: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case userId
    case mine
    case admin
    case title
    case commentsCount
    case likesCount
    case scrapsCount
    case createdTime
  }
}

