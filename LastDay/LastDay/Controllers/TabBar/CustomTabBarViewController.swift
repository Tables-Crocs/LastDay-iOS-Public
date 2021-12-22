//
//  CustomTabBarViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class CustomTabBarViewController: CustomTabBarController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.clipsToBounds = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  override func viewDidLoad() {
    configureViewControllers()
    setup()
    getDeviceType()
    super.viewDidLoad()
  }
  
  private func configureViewControllers() {
    guard let search = UIStoryboard.init(name: "Search", bundle: nil)
            .instantiateViewController(identifier: "SearchViewController")
            as? SearchViewController else {
      print("----------- no search")
      return
    }
    guard let history = UIStoryboard.init(name: "History", bundle: nil)
            .instantiateViewController(identifier: "HistoryViewController")
            as? HistoryViewController else {
      print("----------- no history")
      return
    }
    guard let community =  UIStoryboard.init(name: "Community", bundle: nil)
            .instantiateViewController(identifier: "CommunityViewController")
            as? CommunityViewController else {
      print("----------- no community")
      return
    }
    guard let profile =  UIStoryboard.init(name: "Profile", bundle: nil)
            .instantiateViewController(identifier: "ProfileViewController")
            as? ProfileViewController else {
      print("----------- no profile")
      return
    }
    
    
    search.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tbb_search_deselect"), selectedImage: UIImage(named: "tbb_search_select"))
    history.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tbb_history_deselect"), selectedImage: UIImage(named: "tbb_history_select"))
    community.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tbb_community_deselect"), selectedImage: UIImage(named: "tbb_community_select"))
    profile.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tbb_profile_deselect"), selectedImage: UIImage(named: "tbb_profile_select"))
    
    self.viewControllers = [search, history, community, profile]
  }
  
  private func setup() {
    self.tintColor = UIColor.mainTintColor
  }
  
  private func getDeviceType() {
    if view.bounds.height > 810.0 {
      DeviceType.type = 0
    } else {
      DeviceType.type = 1
    }
  }
}
