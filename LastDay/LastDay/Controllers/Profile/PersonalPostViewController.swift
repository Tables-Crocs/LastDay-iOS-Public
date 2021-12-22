//
//  PersonalPostViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/23.
//

import UIKit

class PersonalPostViewController: UIViewController {

  @IBOutlet weak var postTableView: UITableView!
  
  var postList: [PersonalPostData] = []
  var category: Int!
  var NVCTitle: String!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDelegates()
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightBlackColor]
    self.title = NVCTitle
    navigationController?.navigationBar.barStyle = .default
    getPosts()


  }
  

  private func setDelegates() {
    postTableView.delegate = self
    postTableView.dataSource = self
  }
  
  
  private func getPosts() {
    
    switch category {
    case 0:
      print(0)
      getMyPosts()
    case 1:
      print(1)
      getMyComments()
    case 2:
      print(2)
      getMyScraps()
    default:
      break
    }

  }
  
  private func getMyPosts() {
    ProfileService.shared.getMyPost { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [PersonalPostData] else { return }
        self?.postList = data
        self?.postTableView.reloadData()
 
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
  }
  
  private func getMyComments() {
    ProfileService.shared.getMyComments { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [PersonalPostData] else { return }
        self?.postList = data
        self?.postTableView.reloadData()
 
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
        print("networkFail")
      }
    }
  }
  
  private func getMyScraps() {
    ProfileService.shared.getMyScraps { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [PersonalPostData] else { return }
        self?.postList = data
        self?.postTableView.reloadData()
 
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
  }
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
}

extension PersonalPostViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return postList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PersonalPostTableViewCell", for: indexPath) as! PersonalPostTableViewCell
    let data = postList[indexPath.item]

    if data.mine == true {
      cell.setInfo(userName: "나", title: data.title, commentsCount: data.comments.count, likesCount: data.likes.count, scrapsCount: data.scraps.count, time: data.createdTime)
    } else {
      cell.setInfo(userName: "익명", title: data.title, commentsCount: data.comments.count, likesCount: data.likes.count, scrapsCount: data.scraps.count, time: data.createdTime)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 88
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = postList[indexPath.item]
    
    let sb = UIStoryboard(name: "Community", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "DetailArticleViewController") as! DetailArticleViewController
    vc.communityId = data.boardId
    vc.postId = data.id
    navigationController?.pushViewController(vc, animated: true)
    

  }
}
