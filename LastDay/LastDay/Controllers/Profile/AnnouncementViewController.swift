//
//  AnnouncementViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class AnnouncementViewController: UIViewController {
  
  @IBOutlet weak var announcementTableView: UITableView!
  
  let tableViewHeightConstant: CGFloat = 106
  var NVCTitle: String!
  
  let announcements:[AnnouncementData] = [AnnouncementData(title: "커뮤니티 이용규칙", text: "LastDay는 누구나 기분좋게 이용할 수 있는 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. 회원분들께서는 커뮤니티 이용 전 이용규칙을 반드시 숙지하시길 부탁드립니다.\n\nLastDay의 커뮤니티 이용자는 방송통신심의위원회의 정보통신에 관한 심의규정, 현행 법률, 서비스 이용 약관 및 커뮤니티 이용규칙을 위반하거나 타 이용자에게 악영향을 끼치는 경우, 게시물 삭제 조치가 이뤄질 수 있습니다.\n\n또한 커뮤니티 내에서 다른 서비스 및 상품을 홍보하는 행위, 영리적 이익을 추구하는 행위, 타 이용자를 기망하여 손해를 끼치는 행위 등은 엄격하게 단속하여, 최소 게시글 삭제에서 회원 자격 정지까지의 조치가 이뤄질 수 있습니다.", date: "10/25 09:01")]

  
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

  }
  
  private func setDelegates() {
    announcementTableView.delegate = self
    announcementTableView.dataSource = self
  }
  
  
  
  
}

extension AnnouncementViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return announcements.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
    
    cell.setInfo(data: announcements[indexPath.item])
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = announcements[indexPath.row]
    let vc = storyboard?.instantiateViewController(withIdentifier: "DetailAnnounceViewController") as! DetailAnnounceViewController
    vc.data = data
    self.navigationController?.pushViewController(vc, animated: true)
  }
}
