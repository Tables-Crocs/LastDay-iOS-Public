//
//  HistoryViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class HistoryViewController: UIViewController {

  var histories: [HistoryData] = []
  
  @IBOutlet weak var saveTableView: UITableView!
  
  @IBOutlet weak var noResultLabel: UILabel!
  
  let tableViewHeightConstant: CGFloat = 110

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    setTableView()
    setDelegates()
    print("history")
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barStyle = .black
    getHistories()

  }
  
  private func setDelegates() {
    saveTableView.delegate = self
    saveTableView.dataSource = self
  }
  
  private func setTableView() {
    saveTableView.separatorStyle = .none

  }
  
  private func getHistories() {
    HistoryService.shared.getHistory { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [HistoryData] else { return }
        self?.histories = data
        self?.saveTableView.reloadData()
        if self?.histories.count == 0 {
          self?.noResultLabel.isHidden = false
        } else {
          self?.noResultLabel.isHidden = true
        }
        
        
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
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return histories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SaveTableViewCell", for: indexPath) as! SaveTableViewCell
    let data = histories[indexPath.row]
    cell.setInfo(data: data)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let data = histories[indexPath.row]
    
    let tempStartStation = StationData(id: "temp", station: data.sourceTitle, stationInfo: "temp", locations: [:])
    let tempRecommend = RecommendData(title: data.contentTitle, address: "temp", locations: [:], travelTime: data.timeTaken, freeTime: 0, id: data.contentId, image: nil)
    let tempEndStation = StationData(id: "temp", station: data.destTitle, stationInfo: "temp", locations: [:])
    
    
    let sb = UIStoryboard(name: "Search", bundle: nil)
    let vc = sb.instantiateViewController(identifier: "SearchDetailViewController") as! SearchDetailViewController
    vc.startStation = tempStartStation
    vc.endStation = tempEndStation
    vc.recommendData = tempRecommend
    vc.contentType = Int(data.contentType)!
    vc.isHistory = true
    vc.historyId = data.id
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
