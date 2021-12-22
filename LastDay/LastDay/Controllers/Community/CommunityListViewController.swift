//
//  CommunityListViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/23.
//

import UIKit

class CommunityListViewController: UIViewController {
  
  
  @IBOutlet weak var communityTableView: UITableView!
  @IBOutlet weak var newButton: UIButton!
  
  
  var communityTitle: String = ""
  var communityId: String = ""
  var postList: [PostListData] = []
  var isFavorite: Bool = false {
    didSet {
      setFavoriteButton()
    }
  }


  private func setFavoriteButton() {
    let favoriteButton: UIBarButtonItem = {
      let button = UIBarButtonItem(image: UIImage(systemName: isFavorite ?  "star.fill" : "star"), style: .plain, target: self, action: #selector(clickFavoriteButton))
      button.tintColor = UIColor.mainTintColor
      return button
    } ()
    self.navigationItem.rightBarButtonItem = favoriteButton

  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setNewButton()
    setDelegates()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightBlackColor]
    self.title = communityTitle
    getPostList()

    
//    self.navigationItem.rightBarButtonItem = self.favoriteButton

  }
  
  @objc private func clickFavoriteButton() {
    if isFavorite == false {
      isFavorite = true
      CommunityService.shared.addFSL(id: communityId, type: "favorite") {
        [weak self] networkResult in
          switch networkResult {
          case .success:
            print("favorite success")
          case .requestErr(let message):
            self?.isFavorite = false
            self?.showNewtorkError()

            if let message = message as? String {
              print(message)
            }
            self?.showNewtorkError()

          case .pathErr :
            self?.isFavorite = false
            self?.showNewtorkError()

            print("pathErr")
          case .serverErr :
            self?.isFavorite = false
            self?.showNewtorkError()

            print("serverErr")
          case .networkFail:
            self?.isFavorite = false
            self?.showNewtorkError()

            print("networkFail")
          }
        
      }
    } else {
      isFavorite = false

      CommunityService.shared.deleteFSL(id: communityId, type: "favorite") {
        [weak self] networkResult in
          switch networkResult {
          case .success:
            print("favorite success")
          case .requestErr(let message):
            self?.isFavorite = true

            if let message = message as? String {
              print(message)
            }
            self?.showNewtorkError()

          case .pathErr :
            self?.isFavorite = true
            self?.showNewtorkError()

            print("pathErr")
          case .serverErr :
            self?.isFavorite = true
            self?.showNewtorkError()

            print("serverErr")
          case .networkFail:
            self?.isFavorite = true
            self?.showNewtorkError()

            print("networkFail")
          }
        
      }
    }

  }
  
  func setDelegates() {
    communityTableView.delegate = self
    communityTableView.dataSource = self
  }
  
  func setNewButton() {
    newButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    newButton.layer.shadowOpacity = 1.0
    newButton.layer.shadowOffset = CGSize.zero
  }
  private func getPostList() {
    DispatchQueue.main.async {
      CommunityService.shared.postList(boardId: self.communityId, pageNum: 1) {
        [weak self] networkResult in
          switch networkResult {
          case .success(let data):
            guard let data = data as? BoardData else { return }
            self?.postList = data.posts
            self?.isFavorite = data.isFavorite
            self?.communityTableView.reloadData()
          case .requestErr(let message):
            if let message = message as? String {
              print(message)
            }
          case .pathErr :
            print("pathErr")
            self?.showNewtorkError()
          case .serverErr :
            self?.showNewtorkError()
            print("serverErr")
          case .networkFail:
            self?.showNewtorkError()
            print("networkFail")
          }
        
      }
    }
  }
  
  func goToArticleDetail(postId: String) {
    //TODO: 게시글 자세히보기 호출
    let vc = storyboard?.instantiateViewController(identifier: "DetailArticleViewController") as! DetailArticleViewController
    vc.communityId = self.communityId
    vc.postId = postId
    print("go to article Detail...", postId)
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  @IBAction func goToNewArticle(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(identifier: "NewArticleNavigationViewController") as! NewArticleNavigationViewController
    
    vc.modalPresentationStyle = .fullScreen
    vc.communityId = self.communityId
    vc.isNew = true
    present(vc, animated: true, completion: nil)
  }
  
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
}

extension CommunityListViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = communityTableView.dequeueReusableCell(withIdentifier: "CommunityTableViewCell", for: indexPath) as! CommunityTableViewCell
    let data = postList[indexPath.item]

    if data.admin {
      cell.setInfo(userName: "운영자", title: data.title, commentsCount: data.commentsCount, likesCount: data.likesCount, scrapsCount: data.scrapsCount, time: data.createdTime)

    } else if data.mine {
      cell.setInfo(userName: "나", title: data.title, commentsCount: data.commentsCount, likesCount: data.likesCount, scrapsCount: data.scrapsCount, time: data.createdTime)

    } else {
      cell.setInfo(userName: "익명", title: data.title, commentsCount: data.commentsCount, likesCount: data.likesCount, scrapsCount: data.scrapsCount, time: data.createdTime)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = postList[indexPath.item]
    goToArticleDetail(postId: data.id)
  }
  
}
