//
//  SplashViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/08/26.
//

import UIKit


class SplashViewController: UIViewController {
  
  @IBOutlet weak var iconImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    iconImageView.alpha = 0.0
    animateLogo() {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        if !UserDefaults.standard.bool(forKey: UserDefaultKeys.seenOnboarding) {
          print("onboarding")
          
          let storyBoard = UIStoryboard(name: "Login", bundle: nil)
          let vc = storyBoard.instantiateViewController(identifier: "OnboardingViewController")
          
          self?.transitionWindow(VC: vc)

        } else {
          if let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) {
            print("toooooken")
            if token == "guest" {
              let storyBoard = UIStoryboard(name: "Login", bundle: nil)
              let vc = storyBoard.instantiateViewController(identifier: "LoginViewController")
              
              
              self?.transitionWindow(VC: vc)
              
            } else {
              
              guard let recentLogin = UserDefaults.standard.string(forKey: UserDefaultKeys.recentAuthType) else { return }
              if recentLogin == AuthCompany.kakao.rawValue {
                guard let email = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoEmail) else { return }
                guard let password = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoPassword) else { return }
                guard let name = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoUserName) else { return }
                
                self?.login(email: email, password: password, userName: name, authCompany: recentLogin)
                
                
              } else if recentLogin == AuthCompany.apple.rawValue {
                guard let email = UserDefaults.standard.string(forKey: UserDefaultKeys.appleEmail) else { return }
                guard let password = UserDefaults.standard.string(forKey: UserDefaultKeys.applePassword) else { return }
                guard let name = UserDefaults.standard.string(forKey: UserDefaultKeys.appleUserName) else { return }
                
                self?.login(email: email, password: password, userName: name, authCompany: recentLogin)
              } else if recentLogin == AuthCompany.email.rawValue {
                guard let email = UserDefaults.standard.string(forKey: UserDefaultKeys.email) else { return }
                guard let password = UserDefaults.standard.string(forKey: UserDefaultKeys.password) else { return }
                self?.emailLogin(email: email, password: password)
                
              }
              
            }
          } else {
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier: "LoginViewController")
            
            self?.transitionWindow(VC: vc)
          }

        }
        
        
      }
    }
  }
  
  
  // splash animation
  private func animateLogo(completion: @escaping ()-> Void) {
    
    UIView.animate(withDuration: 0.7, animations: {
      self.iconImageView.alpha = 1.0
      self.view.layoutIfNeeded()
    }, completion: { done in
      completion()
    })
  }
  
  private func login(email: String, password: String, userName: String, authCompany: String) {
    LoginService.shared.snsLogin(email: email, password: password, name: userName, authCompany: AuthCompany.apple.rawValue) { [weak self] networkResult in
      switch networkResult {
      case .success(let data) :
        print("sucess")
        guard let loginData = data as? LoginData else { return }
        UserDefaults.standard.setValue(loginData.token, forKey: UserDefaultKeys.userToken)
        
        print("token exists")
        let storyBoard = UIStoryboard.init(name: "TabBar", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "MainNavigationViewController")
        
        self?.transitionWindow(VC: vc)
        
      case .requestErr(let message):
        _ = message
        print("reqERR")
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)

      case .pathErr:
        print("pathERR")
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)
      case .serverErr:
        print("serverERR")
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)
      case .networkFail:
        print("network")
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)

      }
    }

  }
  
  private func emailLogin(email: String, password: String) {
    LoginService.shared.emailLogin(email: email, password: password) { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? EmailLoginData else { return }
        
        UserDefaults.standard.setValue(data.token, forKey: UserDefaultKeys.userToken)
        UserDefaults.standard.setValue(email, forKey: UserDefaultKeys.email)
        UserDefaults.standard.setValue(password, forKey: UserDefaultKeys.password)
        
        let storyBoard = UIStoryboard.init(name: "TabBar", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "MainNavigationViewController")
        
        self?.transitionWindow(VC: vc)
      
      case .requestErr(let message):
        
        if let message = message as? String {
          print("not a user")
          print(message)
        }
        
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)
        
      case .pathErr :
        print("pathErr")
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)
      case .serverErr :
        print("serverErr")
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)
      case .networkFail:
        let vc = self?.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self?.transitionWindow(VC: vc)
        print("networkFail")
        print("networkFail")
      }
    }
  }
  private func transitionWindow(VC: UIViewController) {
    guard let window = self.view.window else { return }
    
    window.rootViewController = VC
    
    let options: UIView.AnimationOptions = .transitionCrossDissolve
    let duration: TimeInterval = 0.15
    
    UIView.transition(
      with: window,
      duration: duration,
      options: options,
      animations: {},
      completion: { completed in
      }
    )
  }
}
