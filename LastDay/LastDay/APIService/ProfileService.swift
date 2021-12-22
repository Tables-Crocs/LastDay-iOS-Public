//
//  ProfileService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import Foundation
import Alamofire

struct ProfileService {
  static let shared = ProfileService()
  
  func getMyPost(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.getMyPostURL
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
        
        completion(judgePostData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func getMyComments(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.getMyCommentURL
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
        
        completion(judgePostData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func getMyScraps(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.getMyScrapsURL
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
        
        completion(judgePostData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  
  private func judgePostData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
//    print(data)
    guard let decodedData = try? decoder.decode(GenericResponse<[PersonalPostData]>.self, from : data) else {
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

