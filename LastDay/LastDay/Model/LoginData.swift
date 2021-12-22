//
//  LoginData.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/01.
//

import Foundation

struct LoginData: Codable {
  let expires: Int
  let expiresPrettyPrint: String
  let token: String
  let name: String
  let isNew: Bool
}
