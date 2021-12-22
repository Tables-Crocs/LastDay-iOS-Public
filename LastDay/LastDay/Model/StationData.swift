//
//  StationData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/15.
//

import Foundation

struct StationData: Codable {
  let id: String
  let station: String
  let stationInfo: String
  let locations: [String:String]

  
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case station
    case stationInfo = "station_info"
    case locations
  }
}
