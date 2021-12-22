//
//  LoginService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/01.
//

import Foundation
import Alamofire

struct LoginService {
  static let shared = LoginService()
  
  func snsLogin(email: String, password: String, name: String, authCompany: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.loginURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body : Parameters = [
      "usertype" : authCompany,
      "username": email,
      "password": password,
      "name": name
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
        guard let data = response.value else {
          return
        }
        
//        if authCompany == AuthCompany.apple.rawValue {
//          UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.appleEmail)
//          UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.applePassword)
//        } else if authCompany == AuthCompany.kakao.rawValue {
//          UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.kakaoEmail)
//          UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.kakaoPassword)
//        }
        
        completion(judgeSNSLogInData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  private func judgeSNSLogInData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(GenericResponse<LoginData>.self, from : data) else {
      return .pathErr
    }
    print(decodedData)
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
  
  
  func emailLogin(email: String, password: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.emailLoginURL
    let header : HTTPHeaders = [
      "Content-Type":"application/json"
    ]
    let body : Parameters = [
      "username" : email,
      "password": password
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
        guard let data = response.value else {
          return
        }
        
        
        completion(judgeEmailLogInData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  private func judgeEmailLogInData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(GenericResponse<EmailLoginData>.self, from : data) else {
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
  
  func register(email: String, password: String, name: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    
    let url = APIConstants.loginURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body : Parameters = [
      "usertype" : AuthCompany.email.rawValue,
      "username": email,
      "password": password,
      "name": name
    ]
    
    print(body)
    
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
  
  
  func verifyCode(email: String, code: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    let url = APIConstants.verifyURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body : Parameters = [
      "username": email,
      "token": code
    ]
        
    let dataRequest = AF.request(url,
                                 method: .post,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        print(String(decoding: response.data!, as: UTF8.self))
        guard let statusCode = response.response?.statusCode else {
          return
        }
        guard let data = response.value else {
          return
        }
        
        completion(judgeVerifyData(status: statusCode, data: data))
        
      case .failure(let error):
        _ = error
        completion(.networkFail)
      }
    }
  }
  
  
  private func judgeVerifyData(status : Int, data : Data) -> NetworkResult<Any> {
    let decoder = JSONDecoder()
    guard let decodedData = try? decoder.decode(GenericResponse<VerifyData>.self, from : data) else {
      return .pathErr
    }
    print(decodedData)
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
  
  func deleteAccount(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    let url = APIConstants.deleteAccountURL + "/" + email
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]

        
    let dataRequest = AF.request(url,
                                 method: .delete,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        print(String(decoding: response.data!, as: UTF8.self))
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
  
  
  func generateNewPwd(email: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    let url = APIConstants.newPasswordURL
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
    ]
    let body : Parameters = [
      "username": email,
    ]
        
    let dataRequest = AF.request(url,
                                 method: .post,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        print(String(decoding: response.data!, as: UTF8.self))
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
  
  
  func changePassword(oldPassword: String, newPassword: String, completion: @escaping (NetworkResult<Any>) -> (Void)) {
    let url = APIConstants.changePasswordURL
    let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none"
    let header : HTTPHeaders = [
      "Content-Type":"application/json",
      "Authorization" : "Bearer " + token
    ]
    let body : Parameters = [
      "oldPassword": oldPassword,
      "newPassword": newPassword
    ]
        
    let dataRequest = AF.request(url,
                                 method: .patch,
                                 parameters: body,
                                 encoding: JSONEncoding.default,
                                 headers: header)
    dataRequest.responseData { response in
      switch response.result {
      case .success:
        print(String(decoding: response.data!, as: UTF8.self))
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
