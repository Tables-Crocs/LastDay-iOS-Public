//
//  ProfileViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet weak var profileLabel: UILabel!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var profileTableView: UITableView!
  @IBOutlet weak var profileImg: UIImageView!
  let tableViewHeightConstant: CGFloat = 60

  
  let profileCells = [ProfileCellVM(image: UIImage(named: "pencel") ?? UIImage(), name: "내가 쓴 글", category: 0), ProfileCellVM(image: UIImage(named: "comment") ?? UIImage(), name: "내 댓글", category: 1), ProfileCellVM(image: UIImage(named: "scrap") ?? UIImage(), name: "내 스크랩", category: 2), ProfileCellVM(image: UIImage(named: "announcement") ?? UIImage(), name: "공지사항", category: 3),
                      ProfileCellVM(image: UIImage(named: "policy") ?? UIImage(), name: "이용약관", category: 4), ProfileCellVM(image: UIImage(named: "lock") ?? UIImage(), name: "비밀번호 변경", category: 5), ProfileCellVM(image: UIImage(named: "delete") ?? UIImage(), name: "탈퇴", category: 6)]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDelegates()
    setProfile()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barStyle = .black

  }
  
  private func setProfile() {
    profileImg.layer.cornerRadius = profileImg.bounds.width/2
    
    
    let loginType = UserDefaults.standard.string(forKey: UserDefaultKeys.recentAuthType) ?? "none"
    
    switch loginType {
    case AuthCompany.kakao.rawValue:
      let name = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoUserName) ?? "none"
      if name == "none" {
        profileLabel.text = "프로필"
      } else {
        profileLabel.text = "\(name)님의 프로필"
      }
      
    case AuthCompany.apple.rawValue:
      let name = UserDefaults.standard.string(forKey: UserDefaultKeys.appleUserName) ?? "none"
      if name == "none" {
        profileLabel.text = "프로필"
      } else {
        profileLabel.text = "\(name)님의 프로필"
      }
      
    case AuthCompany.email.rawValue:
      let name = UserDefaults.standard.string(forKey: UserDefaultKeys.userName) ?? "none"
      if name == "none" {
        profileLabel.text = "프로필"
      } else {
        profileLabel.text = "\(name)님의 프로필"
      }
    default:
      profileLabel.text = "프로필"
    }
    
  }
  
  
  private func setDelegates() {
    profileTableView.delegate = self
    profileTableView.dataSource = self
  }
  
  
  @IBAction func handleLogout(_ sender: Any) {
    
    let alertViewController = UIAlertController(title: "로그아웃 하시겠습니까?", message: "", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      self?.logout()
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  private func deleteAccount() {
    
    let recentLogin = UserDefaults.standard.string(forKey: UserDefaultKeys.recentAuthType)
    guard let recentLogin = recentLogin else {
      return
    }

    switch recentLogin {
    case AuthCompany.kakao.rawValue:
      let email = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoEmail)
      guard let email = email else {
        return
      }
      LoginService.shared.deleteAccount(email: email) { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userToken)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.kakaoEmail)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.kakaoPassword)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.kakaoUserName)
          
          self?.goToLogin()
        case .requestErr(let message):
          if let message = message as? String {
            print(message)
          }
          self?.showNewtorkError()
        case .pathErr :
          print("pathErr")
          self?.showNewtorkError()
        case .serverErr :
          print("serverErr")
          self?.showNewtorkError()
        case .networkFail:
          self?.showNewtorkError()
          print("networkFail")
        }
      }
      
    case AuthCompany.apple.rawValue:
      let email = UserDefaults.standard.string(forKey: UserDefaultKeys.appleEmail)
      guard let email = email else {
        return
      }
      LoginService.shared.deleteAccount(email: email) { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userToken)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.appleEmail)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.applePassword)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.appleUserName)
          
          self?.goToLogin()
        case .requestErr(let message):
          if let message = message as? String {
            print(message)
          }
          self?.showNewtorkError()
        case .pathErr :
          print("pathErr")
          self?.showNewtorkError()
        case .serverErr :
          print("serverErr")
          self?.showNewtorkError()
        case .networkFail:
          self?.showNewtorkError()
          print("networkFail")
        }
      }

    case AuthCompany.email.rawValue:
      let email = UserDefaults.standard.string(forKey: UserDefaultKeys.email)
      guard let email = email else {
        return
      }
      LoginService.shared.deleteAccount(email: email) { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userToken)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.email)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.password)
          UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userName)
          
          self?.goToLogin()
        case .requestErr(let message):
          if let message = message as? String {
            print(message)
          }
          self?.showNewtorkError()
        case .pathErr :
          print("pathErr")
          self?.showNewtorkError()
        case .serverErr :
          print("serverErr")
          self?.showNewtorkError()
        case .networkFail:
          self?.showNewtorkError()
          print("networkFail")
        }
      }
    default:
      break
    }
    
    
  }
  
  private func goToLogin() {
    

    if let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) {
      print(token)
    } else {
      print("token removed")
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      
      guard let window = self.view.window else { return }
      
      let rootVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginViewController") as! LoginViewController
      window.rootViewController = rootVC
      
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
  }
  
  private func deleteAccountAlert() {
    let alertViewController = UIAlertController(title: "탈퇴 하시겠습니까?", message: "한번 탈퇴한 계정은 복구가 불가능합니다.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] (action) in
      self?.deleteAccount()
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  private func logout() {
    UserDefaults.standard.removeObject(forKey: UserDefaultKeys.userToken)
    if let token = UserDefaults.standard.string(forKey: UserDefaultKeys.userToken) {
      print(token)
    } else {
      print("token removed")
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      
      guard let window = self.view.window else { return }
      
      let rootVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(identifier: "LoginViewController") as! LoginViewController
      window.rootViewController = rootVC
      
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
  }
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return profileCells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
    
    cell.setInfo(data: profileCells[indexPath.item])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = profileCells[indexPath.row]
    
    if data.category == 0 {
      let vc = storyboard?.instantiateViewController(identifier: "PersonalPostViewController") as! PersonalPostViewController
      vc.category = data.category
      vc.NVCTitle = "내가 쓴 글"
      navigationController?.pushViewController(vc, animated: true)
      
    } else if data.category == 1 {
      let vc = storyboard?.instantiateViewController(identifier: "PersonalPostViewController") as! PersonalPostViewController
      vc.category = data.category
      vc.NVCTitle = "내 댓글"
      navigationController?.pushViewController(vc, animated: true)

    } else if data.category == 2 {
      let vc = storyboard?.instantiateViewController(identifier: "PersonalPostViewController") as! PersonalPostViewController
      vc.category = data.category
      vc.NVCTitle = "내 스크랩"
      navigationController?.pushViewController(vc, animated: true)

    } else if data.category == 3 {
      let vc = storyboard?.instantiateViewController(withIdentifier: "AnnouncementViewController") as! AnnouncementViewController
      vc.NVCTitle = "공지사항"
      navigationController?.pushViewController(vc, animated: true)


    } else if data.category == 4 {
      let vc = storyboard?.instantiateViewController(withIdentifier: "PolicyViewController") as! PolicyViewController
      vc.NVCTitle = "이용약관"
      navigationController?.pushViewController(vc, animated: true)


    } else if data.category == 5 {
      
      let authType = UserDefaults.standard.string(forKey: UserDefaultKeys.recentAuthType)
      guard let authType = authType else {
        return
      }
      
      if authType == AuthCompany.email.rawValue {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChangePwdViewController") as! ChangePwdViewController
        vc.NVCTitle = "비밀번호 변경"
        navigationController?.pushViewController(vc, animated: true)
      } else {
        let alertViewController = UIAlertController(title: "비밀번호 변경 불가", message: "SNS로 로그인한 계정은 비밀번호 변경이 불가합니다.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        alertViewController.addAction(cancelAction)
        present(alertViewController, animated: true, completion: nil)
      }

    }
    
    
    else {
      deleteAccountAlert()
    }
  }
  
}
