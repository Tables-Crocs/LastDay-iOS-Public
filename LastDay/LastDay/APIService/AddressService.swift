//
//  AddressService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import Foundation
import Alamofire

struct AddressService {
  static let shared = AddressService()
  
  func getAddress(keyword: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.addressSearchURL + "/" + keyword
    let urlEncoded = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    
    
    let dataRequest = AF.request(urlEncoded,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
//      print(String(decoding: response.data!, as: UTF8.self))
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }
        
        completion(judgeAddressData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  private func judgeAddressData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
//    print(data)
    guard let decodedData = try? decoder.decode(GenericResponse<[AddressData]>.self, from : data) else {
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

