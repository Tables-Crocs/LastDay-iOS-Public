//
//  TimePickerData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/06.
//

import Foundation

import Foundation

struct TimePickerData {
  static let shared = TimePickerData()
  
  let timeConverter = TimeConverter()
  var times: [String] = []
//  var sleepTimes: [String] = []
  
  let ampm = ["오전", "오후"]
  let hour = ["1", "2", "3", "4", "5", "6", "7", "8",
              "9", "10", "11", "12"]
  var min: [String] = []
  
  init() {
    for i in 0...719 {
      let timeStr =  "오전 " + timeConverter.intToTimeString(int: i)
      times.append(timeStr)
    }
    for i in 0...719 {
      let timeStr =  "오후 " + timeConverter.intToTimeString(int: i)
      times.append(timeStr)
    }
    
    for i in 0...59 {
      min.append(String(format: "%02d", Int(i)))
    }
    
//    for i in 0...30 {
//      let str = "\(i)분"
//      sleepTimes.append(str)
//    }
  }
}
