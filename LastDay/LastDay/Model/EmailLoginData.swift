//
//  EmailLoginData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import Foundation

struct EmailLoginData: Codable {
  let expires: Int
  let expiresPrettyPrint: String
  let token: String
  let name: String
  let isVerified: Bool
}
