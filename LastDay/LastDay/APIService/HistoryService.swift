//
//  HistoryService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/23.
//

import Foundation
import Alamofire

struct HistoryService {
  static let shared = HistoryService()
  
  func getHistory(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.getHistoryURL
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
        
        completion(judgeHistoryData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func postHistory(sourceTitle: String, destTitle: String, contentId: String, contentTitle: String, contentType: Int, timeTaken: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.addHistoryURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body : Parameters = [
      "sourceTitle" : sourceTitle,
      "destTitle": destTitle,
      "time_taken": timeTaken,
      "contentId": contentId,
      "contentTitle": contentTitle,
      "content_type": "\(contentType)"
    ]
    
    print(body)
    
    
    let dataRequest = AF.request(url,
                                 method: .post,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      print(String(decoding: response.data!, as: UTF8.self))
      
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }

        
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }

  func deleteHistory(id: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.deleteHistoryURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body : Parameters = [
      "id" : id
    ]
    
    
    let dataRequest = AF.request(url,
                                 method: .delete,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }

        
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  private func judgeHistoryData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
//    print(data)
    guard let decodedData = try? decoder.decode(GenericResponse<[HistoryData]>.self, from : data) else {
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
  
  private func done(status : Int) -> NetworkResult<Any> {
    switch status {
    case 200..<300:
      return .success(status)
    case 400..<500 :
      return .requestErr(status)
    case 500 :
      return .serverErr
    default :
      return .networkFail
    }
  }
  
  
}

