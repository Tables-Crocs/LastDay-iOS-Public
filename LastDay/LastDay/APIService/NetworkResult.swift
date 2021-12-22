//
//  NetworkResult.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/01.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr(T)
    case pathErr
    case serverErr
    case networkFail
}
