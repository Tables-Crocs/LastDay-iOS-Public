//
//  LoginViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/08/30.
//

import UIKit
import Alamofire
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import NaverThirdPartyLogin
import SnapKit

enum AuthCompany: String  {
  case kakao = "KAKAO"
  case email = "USER"
  case apple = "APPLE"
}


class LoginViewController: UIViewController {
  
  // MARK: - Views
  lazy var backgroundImgView: UIImageView = {
    let imgView = UIImageView()
    imgView.image = UIImage(named: "search_background")
    imgView.contentMode = .scaleAspectFill
    return imgView
  }()
  
  lazy var loginImgView: UIImageView = {
    let imgView = UIImageView()
    imgView.image = UIImage(named: "login_image")
    imgView.contentMode = .scaleAspectFit
    return imgView
  }()
  
  lazy var loginBGView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  
  lazy var cornerBGView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  lazy var selectLoginImageView: UIImageView = {
    let imgView = UIImageView()
    imgView.image = UIImage(named: "select_login")
    imgView.contentMode = .center
    return imgView
  }()
  
  lazy var loginStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 24
    
    return stackView
  }()
  
  lazy var appleButton: UIButton = {
    let button = UIButton()


    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "apple_login_circle")
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(appleGoMain), for: .touchUpInside)
    return button
  }()
  

  
  lazy var kakaoButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "kakao_login_circle")
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(kakaoGoMain), for: .touchUpInside)
    return button
  }()
  
//  lazy var naverButton: UIButton = {
//    let button = UIButton()
//    button.translatesAutoresizingMaskIntoConstraints = false
//    let image = UIImage(named: "naver_login_circle")
//    button.setBackgroundImage(image, for: .normal)
//    button.addTarget(self, action: #selector(naverGoMain), for: .touchUpInside)
//    return button
//  }()
  
  lazy var emailButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "email_login_circle")
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(emailGoMain), for: .touchUpInside)
    return button
  }()
  
  lazy var emailSignInButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    let image = UIImage(named: "email_signin")
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(register), for: .touchUpInside)
    return button
  }()
  
  let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  
  
  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    
    setBackground()
    setLoginBG()
    setSNSLoginButtons()
    
    print(UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) ?? "none")
    
   
  }
  
  // MARK: - Set Appearance
  private func setBackground() {
    
    view.addSubview(backgroundImgView)
    
    backgroundImgView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  
  private func setLoginBG() {
    
    view.addSubview(loginBGView)
    view.addSubview(cornerBGView)
    view.bringSubviewToFront(loginBGView)
    
    loginBGView.layer.cornerRadius = 25

    loginBGView.snp.makeConstraints { make in
      make.height.equalTo(280)
      make.bottom.leading.trailing.equalToSuperview()
    }
    
    cornerBGView.snp.makeConstraints { make in
      make.height.equalTo(100)
      make.bottom.leading.trailing.equalToSuperview()
    }
    
    view.addSubview(loginImgView)
    loginImgView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(60)
      make.bottom.equalTo(loginBGView.snp.top)
      make.leading.trailing.equalToSuperview().inset(80)
    }
    
    backgroundImgView.bringSubviewToFront(loginBGView)
  }
  
  private func setSNSLoginButtons() {
    
    loginBGView.addSubview(selectLoginImageView)
    selectLoginImageView.snp.makeConstraints { make in
      make.width.equalTo(160)
      make.height.equalTo(50)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(30)
    }
    
    loginBGView.addSubview(loginStackView)
    loginStackView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(selectLoginImageView.snp.bottom).offset(5)
      
    }
    
    loginStackView.addArrangedSubview(kakaoButton)
//    loginStackView.addArrangedSubview(naverButton)
    loginStackView.addArrangedSubview(appleButton)
    loginStackView.addArrangedSubview(emailButton)

    loginBGView.addSubview(emailSignInButton)
    emailSignInButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(loginStackView.snp.bottom).offset(40)
    }
  }
  
  
  // MARK: - Functions
  
  @objc func kakaoGoMain() {
    if let kakaoUserId = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoEmail), kakaoUserId != "0", let userName = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoUserName) {
      UserDefaults.standard.setValue(AuthCompany.kakao.rawValue, forKey: UserDefaultKeys.recentAuthType)
      snsGoMain(email: kakaoUserId, password: kakaoUserId, userName: userName, authCompany: AuthCompany.kakao.rawValue)
    } else {
      KakaoService.shared.getUserInfo { [weak self] (userid, userName) in
        UserDefaults.standard.setValue(userid, forKey: UserDefaultKeys.kakaoEmail)
        UserDefaults.standard.setValue(userid, forKey: UserDefaultKeys.kakaoPassword)
        UserDefaults.standard.setValue(userName, forKey: UserDefaultKeys.kakaoUserName)
        UserDefaults.standard.setValue(AuthCompany.kakao.rawValue, forKey: UserDefaultKeys.recentAuthType)


        
        self?.snsGoMain(email: userid, password: userid, userName: userName, authCompany: AuthCompany.kakao.rawValue)
      }
    }
  }
  

  
  @objc func appleGoMain() {
    if let email = UserDefaults.standard.string(forKey: UserDefaultKeys.appleEmail), let password = UserDefaults.standard.string(forKey: UserDefaultKeys.applePassword), let name = UserDefaults.standard.string(forKey: UserDefaultKeys.appleUserName) {
      UserDefaults.standard.setValue(AuthCompany.apple.rawValue, forKey: UserDefaultKeys.recentAuthType)
      snsGoMain(email: email, password: password, userName: name, authCompany: AuthCompany.apple.rawValue)
    } else {
      appleSignUp()
    }
  }
  
  private func appleSignUp() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  

  
  private func snsGoMain(email: String, password: String, userName: String, authCompany: String) {
        
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
      print("go to main")

      
      LoginService.shared.snsLogin(email: email, password: password, name: userName, authCompany: authCompany) { networkResult in
        switch networkResult {
        case .success(let data):
          if let data = data as? LoginData {
            UserDefaults.standard.setValue(data.token, forKey: UserDefaultKeys.userToken)
            
            switch authCompany {
            case AuthCompany.kakao.rawValue:
              UserDefaults.standard.setValue(data.name, forKey: UserDefaultKeys.kakaoUserName)
            case AuthCompany.apple.rawValue:
              UserDefaults.standard.setValue(data.name, forKey: UserDefaultKeys.appleUserName)
            default:
              break
            }
            
            UserDefaults.standard.synchronize()
            print(data.isNew)
            
            
            guard let window = self.view.window else { return }
            
            let sb = UIStoryboard.init(name: "TabBar", bundle: nil)
            let vc = sb.instantiateViewController(identifier: "MainNavigationViewController")
            
            window.rootViewController = vc
            
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            
            UIView.transition(
              with: window,
              duration: duration,
              options: options,
              animations: {},
              completion: { completed in
              }
            )
            
            
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
  
  
  @objc func emailGoMain() {
    let vc = storyboard?.instantiateViewController(withIdentifier: "LoginNavigationViewController") as! LoginNavigationViewController
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
  
  
  @objc func register() {
    let vc = storyboard?.instantiateViewController(withIdentifier: "RegisterNavigationViewController") as! RegisterNavigationViewController
    vc.nextVC = "register"
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
  
 
  
}

// MARK: - Extension


extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      // Create an account in your system.
      
      print(appleIDCredential.user)
      let password = appleIDCredential.user
      let name = appleIDCredential.fullName?.givenName ?? "none"

      UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.appleEmail)
      UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.applePassword)
      UserDefaults.standard.setValue(name, forKey: UserDefaultKeys.appleUserName)
      UserDefaults.standard.setValue(AuthCompany.apple.rawValue, forKey: UserDefaultKeys.recentAuthType)
      snsGoMain(email: password, password: password, userName: name, authCompany: AuthCompany.apple.rawValue)
      
    }
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    print("Apple authorization error: \(error)")
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}


