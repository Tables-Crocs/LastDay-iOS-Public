//
//  ContentService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/23.
//

import Foundation
import Alamofire

struct ContentService {
  static let shared = ContentService()
  
  func getContent(recommendData: RecommendData, contentType: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.contentURL + "/" + recommendData.id + "/\(contentType)"
    print(url)
    
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]


    let dataRequest = AF.request(url,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      print(String(decoding: response.data!, as: UTF8.self))
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }

        completion(judgeContentData(status: statusCode, data: data))

      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }

  
  
  private func judgeContentData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
//    print(data)
    guard let decodedData = try? decoder.decode(GenericResponse<ContentData>.self, from : data) else {
      return .pathErr
    }
    switch status {
    case 200..<300:
    
      return .success(decodedData.data!)
    case 400..<500 :
      return .requestErr(decodedData.message)
    case 500 :
      return .serverErr
    default :
      return .networkFail
    }
  }
  
  
}
