//
//  HistoryData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/23.
//

import Foundation

struct HistoryData: Codable {
  let id: String
  let sourceTitle: String
  let destTitle: String
  let contentId: String
  let contentTitle: String
  let contentType: String
  let timeTaken: Int
  let fmtDate: String
  let fmtTime: String
  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case sourceTitle
    case destTitle
    case contentId
    case contentTitle
    case contentType = "content_type"
    case timeTaken = "time_taken"
    case fmtDate
    case fmtTime
  }
}
