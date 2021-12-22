//
//  CustomTabBarDelegate.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import Foundation

@objc
protocol CustomTabBarDelegate: AnyObject {
    @objc func customTabBar(_ sender: CustomTabBar, didSelectItemAt index: Int)
}
