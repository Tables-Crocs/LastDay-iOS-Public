//
//  TotalCommunityViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/28.
//

import UIKit

class TotalCommunityViewController: UIViewController {

  @IBOutlet weak var totalCommunityTableView: UITableView!
  
  let tableViewHeightConstant: CGFloat = 68

  
  var totalCommunity:[CommunityData] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDelegates()
    getCommunityList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor
    self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.lightBlackColor]
    self.title = "더보기"
  }
  
  private func setDelegates() {
    totalCommunityTableView.delegate = self
    totalCommunityTableView.dataSource = self
  }
  
  private func getCommunityList() {
    DispatchQueue.main.async {
      CommunityService.shared.totalCommunityList { [weak self] networkResult in
        switch networkResult {
        case .success(let data):
          guard let data = data as? [CommunityData] else { return }
          self?.totalCommunity = data
          self?.totalCommunityTableView.reloadData()
        case .requestErr(let message):
          if let message = message as? String {
            print("not a user")
            print(message)
          }
        case .pathErr :
          print("pathErr")
        case .serverErr :
          print("serverErr")
        case .networkFail:
          print("networkFail")
          print("networkFail")
        }
      }
    }
  }

}

extension TotalCommunityViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = storyboard?.instantiateViewController(identifier: "CommunityListViewController") as! CommunityListViewController
    let data = self.totalCommunity[indexPath.item]
    vc.communityId = data.id
    if data.provAbb == "" {
      vc.communityTitle = data.abb
    } else {
      vc.communityTitle = data.provAbb + " " + data.abb
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return totalCommunity.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityListTableViewCell", for: indexPath) as! CommunityListTableViewCell
    
    let data = totalCommunity[indexPath.item]
    cell.setInfo(data: data)
    return cell
  }
  
  
}
