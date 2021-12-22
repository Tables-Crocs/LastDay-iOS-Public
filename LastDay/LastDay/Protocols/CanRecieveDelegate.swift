//
//  CanRecieveDelegate.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/15.
//

import Foundation

protocol CanRecieveStation {
  func passStationDataBack(stationData: StationData)
}


protocol CanRecieveAddress {
  func passAddressDataBack(addressData: AddressData)
}
