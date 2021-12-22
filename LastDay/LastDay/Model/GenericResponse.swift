//
//  GenericResponse.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/01.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    var statusCode: Int
    var message: String
    var data: T?
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "statusCode"
        case message = "message"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = (try? values.decode(Int.self, forKey: .statusCode)) ?? -1
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
