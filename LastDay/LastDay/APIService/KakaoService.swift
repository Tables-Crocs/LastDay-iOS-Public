//
//  KakaoService.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/01.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser

struct KakaoService {
  static let shared = KakaoService()
  
  
  func getUserInfo(completion: @escaping (String, String) -> (Void)) {
    if(UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
        if let error = error {
          print("Kakao login error: \(error)")
        } else {
          print("Kakao login success")
          
          // get user email
          UserApi.shared.me { (user, error) in
            if let error = error {
              print("User info error: \(error)")
            } else {
              guard let user = user else {
                print("No user")
                return
              }
              let userid = "\(user.id ?? 0)"
              let userName = user.kakaoAccount?.profile?.nickname ?? "User"
              
              print("got user")
              print(userid)
              completion(userid, userName)

            }
          }
        }
      }
    } else {
      UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
         if let error = error {
           print(error)
         }
         else {
          print("loginWithKakaoAccount() success.")
          
          //do something
           UserApi.shared.me { (user, error) in
             if let error = error {
               print("User info error: \(error)")
             } else {
               guard let user = user else {
                 print("No user")
                 return
               }
               let userid = "\(user.id ?? 0)"
               let userName = user.kakaoAccount?.profile?.nickname ?? "User"
               
               print("got user")
               print(userid)
               completion(userid, userName)
             }
           }
         }
      }
    }
  }
  
  func kakaoLogin(email:String, password: String, name: String, completion: @escaping (LoginData) -> Void) {
    LoginService.shared.snsLogin(email: email, password: password, name: name, authCompany: AuthCompany.kakao.rawValue) { networkResult in
      switch networkResult {
      case .success(let data):
        if let data = data as? LoginData {
          completion(data)
        }
      case .requestErr(let message):
        if let message = message as? String {
          print("not a user")
          print(message)
        }
      case .pathErr :
        print("pathErr")
      case .serverErr :
        print("serverErr")
      case .networkFail:
        print("networkFail")
        print("networkFail")
      }
    }
  }
  
}
