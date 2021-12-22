//
//  TimeSampData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/21.
//

import Foundation

struct TimestampData {
  let timestamp: String
  let hour: Int
  let min: Int
  
  init(hour: String, min: String, ampm: String) {
    
    let hourInt = Int(hour) ?? 0
    
    if ampm == "오후" {
      if hourInt == 12 {
        self.hour = 0
      } else {
        self.hour = hourInt + 12
      }
    } else {
      self.hour = hourInt
    }
    
    self.min = Int(min) ?? 0
    self.timestamp = ampm + " " + hour + ":" + min

  }
}
