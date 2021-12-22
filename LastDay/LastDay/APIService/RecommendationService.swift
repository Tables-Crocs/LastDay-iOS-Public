//
//  RecommendationService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import Foundation
import Alamofire

struct RecommendationService {
  static let shared = RecommendationService()
  
  func getStationRecommend(contentType: Int, candidates: Int, station: StationData, timestamp: TimestampData, completion: @escaping (NetworkResult<Any>, Int) -> (Void)) {
    
    let queryItems = [URLQueryItem(name: "source_x", value: station.locations["x"]), URLQueryItem(name: "source_y", value: station.locations["y"]),
                      URLQueryItem(name: "radius", value: "10000"), URLQueryItem(name: "hour", value: "\(timestamp.hour)"),
                      URLQueryItem(name: "minute", value: "\(timestamp.min)")]
    var urlComps = URLComponents(string: APIConstants.stationRecommendURL + "/\(contentType)/\(candidates)")!
    
    urlComps.queryItems = queryItems
    let url = urlComps.url!
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

        completion(judgeRecommendData(status: statusCode, data: data), contentType)

      case .failure(let error):
        _ = error
        completion(.networkFail, -1)
      }
    }
  }
  
  func getAddressRecommend(contentType: Int, candidates: Int, address: AddressData, station: StationData, timestamp: TimestampData, completion: @escaping (NetworkResult<Any>, Int) -> (Void)) {
    
    let queryItems = [URLQueryItem(name: "source_x", value: address.locations["x"]), URLQueryItem(name: "source_y", value: address.locations["y"]),
                      URLQueryItem(name: "dest_x", value: station.locations["x"]), URLQueryItem(name: "dest_y", value: station.locations["y"]),
                      URLQueryItem(name: "hour", value: "\(timestamp.hour)"), URLQueryItem(name: "minute", value: "\(timestamp.min)")]
    var urlComps = URLComponents(string: APIConstants.addressRecommendURL + "/\(contentType)/\(candidates)")!
    
    urlComps.queryItems = queryItems
    let url = urlComps.url!
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

        completion(judgeRecommendData(status: statusCode, data: data), contentType)

      case .failure(let error):
        _ = error
        completion(.networkFail, -1)
      }
    }
  }
  
  
  private func judgeRecommendData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
//    print(data)
    guard let decodedData = try? decoder.decode(GenericResponse<[RecommendData]>.self, from : data) else {
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

