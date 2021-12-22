//
//  SearchViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {
  
  @IBOutlet weak var pathBtnImg: UIImageView!
  @IBOutlet weak var stationBtnImg: UIImageView!
  
  @IBOutlet weak var pathSearchButton: UIButton!
  @IBOutlet weak var stationSearchButton: UIButton!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var greetingLabel: UILabel!
  
  var locationManager: CLLocationManager?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    print("kakao email: \(UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoEmail) ?? "none")")
    print("kakao password: \(UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoPassword) ?? "password")")
    print("kakao username: \(UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoUserName) ?? "none")")

    print("apple email: \(UserDefaults.standard.string(forKey: UserDefaultKeys.appleEmail) ?? "none")")
    print("apple password: \(UserDefaults.standard.string(forKey: UserDefaultKeys.applePassword) ?? "none")")
    print("apple username: \(UserDefaults.standard.string(forKey: UserDefaultKeys.appleUserName) ?? "none")")
    
    print("email: \(UserDefaults.standard.string(forKey: UserDefaultKeys.email) ?? "none")")
    print("password: \(UserDefaults.standard.string(forKey: UserDefaultKeys.password) ?? "none")")
    print("username: \(UserDefaults.standard.string(forKey: UserDefaultKeys.userName) ?? "none")")
    
    print("recent: \(UserDefaults.standard.string(forKey: UserDefaultKeys.recentAuthType) ?? "none")")
    
    setNameLabel()
    setLocationManager()


    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barStyle = .black
  }
  
  private func setLocationManager() {
    locationManager = CLLocationManager()
    locationManager?.requestWhenInUseAuthorization()
    locationManager?.delegate = self
    locationManager?.requestLocation()
  }
  
  private func setNameLabel() {
    
    let loginType = UserDefaults.standard.string(forKey: UserDefaultKeys.recentAuthType) ?? "none"
    
    switch loginType {
    case AuthCompany.kakao.rawValue:
      let name = UserDefaults.standard.string(forKey: UserDefaultKeys.kakaoUserName) ?? "none"
      if name == "none" {
        nameLabel.text = "안녕하세요"
      } else {
        nameLabel.text = "\(name)님,"
      }
      
    case AuthCompany.apple.rawValue:
      let name = UserDefaults.standard.string(forKey: UserDefaultKeys.appleUserName) ?? "none"
      if name == "none" {
        nameLabel.text = "안녕하세요"
      } else {
        nameLabel.text = "\(name)님,"
      }
      
    case AuthCompany.email.rawValue:
      let name = UserDefaults.standard.string(forKey: UserDefaultKeys.userName) ?? "none"
      if name == "none" {
        nameLabel.text = "안녕하세요"
      } else {
        nameLabel.text = "\(name)님,"
      }
      
    default:
      nameLabel.text = "안녕하세요"
    }
    
    
  }
  
  @IBAction func handlePathSearchBtn(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(identifier: "SearchPathViewController") as! SearchPathViewController
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func handleStationSearchBtn(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(identifier: "SearchStationViewController") as! SearchStationViewController
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func unwindToSearchHome(_ unwindSegue: UIStoryboardSegue) {
    let sourceViewController = unwindSegue.source
    
    let vcType = type(of: sourceViewController)
    switch vcType {
    case is SearchStationViewController.Type:
      let sourceVC = sourceViewController as! SearchStationViewController
      let stationData = sourceVC.selectedStation
      let selectedTime = sourceVC.selectedTime
      guard let stationData = stationData, let selectedTime = selectedTime else {
        return
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let vc = self?.storyboard?.instantiateViewController(identifier: "SearchResultNavigationController") as! SearchResultNavigationController
        vc.startStationData = stationData
        vc.endStationData = stationData
        vc.selectedTime = selectedTime
        vc.modalPresentationStyle = .fullScreen
        self?.present(vc, animated: true, completion: nil)
        
      }
    case is SearchPathViewController.Type:
      print("path")
      let sourceVC = sourceViewController as! SearchPathViewController
      let stationData = sourceVC.selectedStation
      let addressData = sourceVC.selectedAddress
      let selectedTime = sourceVC.selectedTime
      guard let stationData = stationData, let addressData = addressData, let selectedTime = selectedTime else {
        print("missing data")
        return
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let vc = self?.storyboard?.instantiateViewController(identifier: "SearchResultNavigationController") as! SearchResultNavigationController
        vc.startAddressData = addressData
        vc.endStationData = stationData
        vc.selectedTime = selectedTime
        vc.modalPresentationStyle = .fullScreen
        self?.present(vc, animated: true, completion: nil)
        
      }
      
    default:
      print("default")
    }
    
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
////      let vc = self?.storyboard?.instantiateViewController(identifier: "SearchResultViewController") as! SearchResultViewController
////      vc.modalPresentationStyle = .fullScreen
////      self?.present(vc, animated: true, completion: nil)
//
//
//      let vc = self?.storyboard?.instantiateViewController(identifier: "SearchResultNavigationController") as! SearchResultNavigationController
//
//      
//      vc.modalPresentationStyle = .fullScreen
//      self?.present(vc, animated: true, completion: nil)
//    }
//    let vc = storyboard?.instantiateViewController(identifier: "SearchResultViewController") as! SearchResultViewController
//    vc.modalPresentationStyle = .fullScreen
//    present(vc, animated: true, completion: nil)
  }
}


extension SearchViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.first {
      let x = location.coordinate.longitude
      let y = location.coordinate.latitude
      
      UserDefaults.standard.set(x, forKey: UserDefaultKeys.locationX)
      UserDefaults.standard.set(y, forKey: UserDefaultKeys.locationY)
      
      print(x)
      print(y)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}
