//
//  SearchResultNavigationController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/06.
//

import UIKit

class SearchResultNavigationController: UINavigationController {

  var startStationData: StationData?
  var startAddressData: AddressData?
  var endStationData: StationData?
  var selectedTime: TimestampData?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    pushRootVC()
  }
      
  private func pushRootVC() {
    let vc = storyboard?.instantiateViewController(identifier: "SearchResultViewController") as! SearchResultViewController

    
    if let startStationData = startStationData {
      vc.startStationData = startStationData
      vc.endStationData = endStationData
      vc.selectedTime = selectedTime
      pushViewController(vc, animated: true)
    } else if let startAddressData = startAddressData {
      vc.startAddressData = startAddressData
      vc.endStationData = endStationData
      vc.selectedTime = selectedTime
      pushViewController(vc, animated: true)
    } else {
      print("No selected Station")
      return
    }
    
  }

}
