//
//  TimeConverter.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/06.
//

import Foundation

class TimeConverter {
  
  let dateFormatter = DateFormatter()
  
  func intToTimeString(int: Int) -> String {
    var h = int / 60
    let m = int  % 60
    
    if h == 0 {
      h = 12
    }
    if m < 10 {
      let timeStr = "\(h):0\(m)"
      return timeStr
    } else  {
      let timeStr = "\(h):\(m)"
      return timeStr
    }
  }
  
  func getTimeStr(date: Date) -> String {
    dateFormatter.dateFormat = "h mm a"
    let str = dateFormatter.string(from: date)
    let timeComponents = str.components(separatedBy: " ")
    
    var a = "오전"
    if timeComponents[2] == "PM" {
      a = "오후"
    }
    let min = String(format: "%02d", Int(timeComponents[1])!)
    let convertStr = a + " " + timeComponents[0] + " " + min
    
    return  convertStr
  }
  
  
}
