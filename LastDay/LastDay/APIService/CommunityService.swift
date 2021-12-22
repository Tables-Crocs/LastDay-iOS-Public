//
//  CommunityService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/28.
//

import Foundation
import Alamofire

struct CommunityService {
  static let shared = CommunityService()
  
  
  
  
  func totalCommunityList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("total")
    
    let url = APIConstants.totalCommunityURL
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
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }
        
        completion(judgeCommunityListData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func favoriteCommunityList(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("favorite")
    
    let url = APIConstants.favoriteCommunityURL
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
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }
        completion(judgeCommunityListData(status: statusCode, data: data))
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func nearbyCommunity(completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("nearby")

    let locationX = UserDefaults.standard.string(forKey: UserDefaultKeys.locationX)
    let locationY = UserDefaults.standard.string(forKey: UserDefaultKeys.locationY)
    
    guard let locationX = locationX, let locationY = locationY else {
      return
    }

    
    
    let url = APIConstants.nearbyCommunityURL
    
    
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    
    
    let parameters : Parameters = [
      "x" : locationX,
      "y": locationY,
    ]
    
    
    let dataRequest = AF.request(url,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding(destination: .queryString),
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
        completion(judgeCommunityListData(status: statusCode, data: data))
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func postList(boardId: String, pageNum: Int, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("Calling get PostList")
    let url = APIConstants.communityPostListURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let parameters : Parameters = [
      "boardId": boardId,
      "pageNum": pageNum
    ]
    
    let dataRequest = AF.request(url,
                                 method: .get,
                                 parameters: parameters,
                                 encoding: URLEncoding(destination: .queryString),                                 headers: header)
    
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }
        completion(judgePostListData(status: statusCode, data: data))
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func createPost(boardId: String, title: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("createPost")
    
    let url = APIConstants.communityPostURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["boardId": boardId, "title": title, "content": content]
    let dataRequest = AF.request(url,
                                 method: .post,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        //TODO: 글 작성 완료 후 창 닫기 
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func editPost(postId: String, title: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("editPost")
    
    let url = APIConstants.communityPostURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["postId": postId, "title": title, "content": content]
    let dataRequest = AF.request(url,
                                 method: .patch,
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
  
  
  func detailPost(postId: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("detailPost")
    
    let url = APIConstants.communityPostURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let dataRequest = AF.request(url + "/" + postId,
                                 method: .get,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    
    
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }
        completion(judgePostDetailData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func createComment(postId: String, content: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    print("createComment")
    
    let url = APIConstants.communityCommentURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["postId": postId, "content": content]
    let dataRequest = AF.request(url,
                                 method: .post,
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
  
  func deleteComment(postId: String, commentId: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
    print("delete Comment")
    let url = APIConstants.communityCommentURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["postId": postId, "commentId": commentId]
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
        //TODO: 글 작성 완료 후 창 닫기
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  func reportComment(userId: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    let url = APIConstants.commentReportURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["reportId": userId]
    let dataRequest = AF.request(url,
                                 method: .get,
                                 parameters: body,
                                 encoding: URLEncoding(destination: .queryString),
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        //TODO: 글 작성 완료 후 창 닫기
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func reportPost(userId: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    let url = APIConstants.commentReportURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["reportId": userId]
    let dataRequest = AF.request(url,
                                 method: .get,
                                 parameters: body,
                                 encoding: URLEncoding(destination: .queryString),
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        //TODO: 글 작성 완료 후 창 닫기
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  
  func addFSL(id: String, type: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
    print("addFSL: ", type, id)
    let url = APIConstants.communityURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["id": id]
    
    let dataRequest = AF.request(url + "/" + type,
                                 method: .post,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        //TODO: 글 작성 완료 후 창 닫기
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func deleteFSL(id: String, type: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
    print("deleteFSL: ", type)
    let url = APIConstants.communityURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body = ["id": id]
    
    let dataRequest = AF.request(url + "/" + type,
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
        //TODO: 글 작성 완료 후 창 닫기
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  func deletePost(postId: String, completion: @escaping (NetworkResult<Any>) -> (Void)){
    print("delete Post")
    let url = APIConstants.communityPostURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    
    let dataRequest = AF.request(url + "/" + postId,
                                 method: .delete,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        guard let statusCode = response.response?.statusCode else {
          return
        }
        //TODO: 글 작성 완료 후 창 닫기
        completion(done(status: statusCode))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  
  private func judgeCommunityListData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
    //    print(String(decoding: data, as: UTF8.self))
    guard let decodedData = try? decoder.decode(GenericResponse<[CommunityData]>.self, from : data) else {
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
  
  
  private func judgePostListData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
    //    print(String(decoding: data, as: UTF8.self))
    guard let decodedData = try? decoder.decode(GenericResponse<BoardData>.self, from : data) else {
      return .pathErr
    }
    //    print(decodedData)
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
  
  private func judgePostDetailData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
    //    print(String(decoding: data, as: UTF8.self))
    guard let decodedData = try? decoder.decode(GenericResponse<PostDetailData>.self, from : data) else {
      return .pathErr
    }
    //    print("decoded Data: ", decodedData)
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
