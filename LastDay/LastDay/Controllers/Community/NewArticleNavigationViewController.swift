//
//  NewArticleNavigationViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/26.
//

import UIKit

class NewArticleNavigationViewController: UINavigationController {
  var communityId: String?
  var postId: String?
  var articleTitle: String?
  var articleText: String?
  var isNew: Bool?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.barTintColor = UIColor.white
    navigationBar.tintColor = UIColor.mainTintColor
    navigationBar.clipsToBounds = true
    
    pushRootVC()
    
  }
  
  private func pushRootVC() {
    let vc = storyboard?.instantiateViewController(identifier: "NewArticleViewController") as! NewArticleViewController
    guard let communityId = communityId else {
      print("createPost ERROR: No Community ID!!")
      return
    }
    vc.communityId = communityId
    vc.postId = postId
    vc.isNew = isNew
    
    if let articleText = articleText, let articleTitle = articleTitle {
      vc.articleText = articleText
      vc.articleTitle = articleTitle
    }
    
    pushViewController(vc, animated: true)
  }
  
}
