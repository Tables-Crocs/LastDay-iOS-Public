//
//  NewArticleViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/26.
//

import UIKit

class NewArticleViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var articleTextView: UITextView!
  
  var communityId: String?
  var postId: String?
  var articleTitle: String?
  var articleText: String?
  var isNew: Bool?
  
  
  lazy var dismissButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissVC))
    return button
    
  }()
  
  lazy var writeButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "글쓰기", style: .plain, target: self, action: #selector(write))
    button.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular"
                                                                        , size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.mainTintColor], for: UIControl.State.normal)
    button.tintColor = UIColor.mainTintColor
    
    return button
    
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setNavigationBarItems()
    setDelegates()
    setTextField()
    setModifyData()
  }
  
  private func setDelegates() {
    titleTextField.delegate = self
    articleTextView.delegate = self
  }
  
  
  private func setNavigationBarItems() {
    self.navigationItem.leftBarButtonItem = dismissButton
    self.navigationItem.rightBarButtonItem = writeButton
  }
  
  private func setTextField() {
    articleTextView.text = "내용을 입력하세요."
    articleTextView.textColor = UIColor.lightGray
    
    
  }
  
  private func setModifyData() {
    if let articleTitle = articleTitle, let articleText = articleText {
      titleTextField.text = articleTitle
      articleTextView.text = articleText
      articleTextView.textColor = UIColor.lightBlackColor
      
      let button = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(write))
      button.setTitleTextAttributes([ NSAttributedString.Key.font: UIFont(name: "AppleSDGothicNeo-Regular"
                                                                          , size: 16)!, NSAttributedString.Key.foregroundColor : UIColor.mainTintColor], for: UIControl.State.normal)
      button.tintColor = UIColor.mainTintColor
      self.navigationItem.rightBarButtonItem = button
    }
  }
  
  @objc func dismissVC() {
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  @objc func write() {
    guard let isNew = isNew else {
      print("createPost ERROR: No isNew !!")
      return
    }
    if isNew {
      guard let communityId = communityId else { print("createPost ERROR: no communityID!"); return}
      DispatchQueue.main.async {
        //TODO: 제목, 내용 없으면 글 못 쓰게 수정하기
        CommunityService.shared.createPost(boardId: communityId, title: self.titleTextField.text ??  "title", content: self.articleTextView.text ??  "content" ) {
          [weak self] networkResult in
          switch networkResult {
          case .success(_):
            self?.navigationController?.dismiss(animated: true, completion: nil)
          case .requestErr(let message):
            if let message = message as? String {
              print(message)
            }
            self?.showNewtorkError()
          case .pathErr :
            print("pathErr")
            self?.showNewtorkError()
            
          case .serverErr :
            self?.showNewtorkError()
            print("serverErr")
          case .networkFail:
            print("networkFail")
            self?.showNewtorkError()
          }
        }
      }
    }
    else {
      guard let postId = postId else { print("editPost ERROR: no communityID!"); return}
      DispatchQueue.main.async {
        //TODO: 제목, 내용 없으면 글 못 쓰게 수정하기
        CommunityService.shared.editPost(postId: postId, title: self.titleTextField.text ??  "title", content: self.articleTextView.text ??  "content" ) {
          [weak self] networkResult in
          switch networkResult {
          case .success(_):
            self?.navigationController?.dismiss(animated: true, completion: nil)
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
            print("networkFail")
            self?.showNewtorkError()
          }
        }
      }
    }
    
  }
//
//  @objc func modify() {
//    print("TODO: modify")
//  }
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
}


extension NewArticleViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    titleTextField.resignFirstResponder()
    articleTextView.becomeFirstResponder()
    
    return false
    
  }
}

extension NewArticleViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    if textView.textColor == UIColor.lightGray {
      if textView.text == "내용을 입력하세요." {
        textView.text = nil
      }
      textView.textColor = UIColor.lightBlackColor
    }
    
    
  }
  
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "내용을 입력하세요."
      textView.textColor = UIColor.lightGray
    }
    
  }
  
  
}
