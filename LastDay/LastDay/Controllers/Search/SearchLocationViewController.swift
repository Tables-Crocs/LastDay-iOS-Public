//
//  SearchLocationViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/15.
//

import UIKit

class SearchLocationViewController: UIViewController {
  
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var resultTableView: UITableView!
  
  var delegate: CanRecieveStation?
  var stationData: [StationData] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setDelegates()
    searchTextField.becomeFirstResponder()
  }
  
  private func setDelegates() {
    searchTextField.delegate = self
    resultTableView.delegate = self
    resultTableView.dataSource = self
  }
  
  private func searchStation(keyword: String) {
    StationService.shared.getStation(keyword: keyword) { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [StationData] else { return }
        self?.stationData = data
        self?.resultTableView.reloadData()
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

extension SearchLocationViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let text = searchTextField.text
    guard let text = text, text != "" else {
      print("nothing")
      searchTextField.resignFirstResponder()
      return true
    }
    searchTextField.resignFirstResponder()
    searchStation(keyword: text)
    
    return true
  }
}

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return stationData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LocationTableViewCell", for: indexPath) as! LocationTableViewCell
    let data = stationData[indexPath.item]
    cell.setInfo(data: data)
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = stationData[indexPath.item]
    delegate?.passStationDataBack(stationData: data)
    self.navigationController?.popViewController(animated: true)
  }
  
}
