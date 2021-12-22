//
//  CustomTabBarController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class CustomTabBarController: UITabBarController {
  
  @IBInspectable public var tintColor: UIColor? {
    didSet {
      customTabBar.tintColor = tintColor
      customTabBar.reloadApperance()
    }
  }
  
  @IBInspectable public var tabBarBackgroundColor: UIColor? {
    didSet {
      customTabBar.backgroundColor = tabBarBackgroundColor
      customTabBar.reloadApperance()
    }
  }
  
  let customTabBar: CustomTabBar = {
    return CustomTabBar()
  }()
  
  lazy var smallBottomView: UIView = {
    let anotherSmallView = UIView()
    anotherSmallView.backgroundColor = .clear
    anotherSmallView.translatesAutoresizingMaskIntoConstraints = false
    
    return anotherSmallView
  }()
  
  fileprivate var bottomSpacing: CGFloat = 4
  fileprivate var tabBarHeight: CGFloat = 0
  fileprivate var horizontleSpacing: CGFloat = 0
  
  
  override open var selectedIndex: Int {
    didSet {
      //            customTabBar.select(at: selectedIndex, notifyDelegate: false)
    }
  }
  
  override open var selectedViewController: UIViewController? {
    didSet {
      //            customTabBar.select(at: selectedIndex, notifyDelegate: false)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // FIXME: TabBar size 구하기
    tabBarHeight = DeviceType.type == 1 ? self.tabBar.frame.size.height - 10 : self.tabBar.frame.size.height - 10
    tabBar.isHidden = true
    
    addAnotherSmallView()
    setupTabBar()
    
    customTabBar.items = tabBar.items!
    customTabBar.select(at: selectedIndex)

  }
  
  fileprivate func addAnotherSmallView(){
    self.view.addSubview(smallBottomView)
    bottomSpacing = DeviceType.type == 1 ? 8 : 4
    smallBottomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -bottomSpacing).isActive = true
    
    
    let cr: NSLayoutConstraint
    
    // iOS 11 이후와 이전 구분
    if #available(iOS 11.0, *) {
      cr = smallBottomView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight)
    } else {
      cr = smallBottomView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: tabBarHeight)
    }
    
    cr.priority = .defaultHigh
    cr.isActive = true
    
    smallBottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    smallBottomView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
  }
  
  fileprivate func setupTabBar(){
    customTabBar.delegate = self
    self.view.addSubview(customTabBar)
    
    customTabBar.bottomAnchor.constraint(equalTo: smallBottomView.topAnchor, constant: 0).isActive = true
    customTabBar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    customTabBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: horizontleSpacing).isActive = true
    customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
    self.view.bringSubviewToFront(customTabBar)
    self.view.bringSubviewToFront(smallBottomView)
    
    customTabBar.tintColor = tintColor
  }
}

extension CustomTabBarController: CustomTabBarDelegate {
  func customTabBar(_ sender: CustomTabBar, didSelectItemAt index: Int) {
    self.selectedIndex = index
  }
}
