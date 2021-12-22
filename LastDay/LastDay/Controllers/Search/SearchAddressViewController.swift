//
//  SearchAddressViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import UIKit

class SearchAddressViewController: UIViewController {
  
  @IBOutlet weak var searchTextField: UITextField!
  @IBOutlet weak var resultTableView: UITableView!
  
  let tableViewHeightConstant: CGFloat = 80

  
  var delegate: CanRecieveAddress?
  var addressData: [AddressData] = []
  
  
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
  
  
  private func searchAddress(keyword: String) {
    AddressService.shared.getAddress(keyword: keyword) { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [AddressData] else { return }
        self?.addressData = data
        self?.resultTableView.reloadData()
      case .requestErr(let message):
        if let message = message as? String {
          print(message)
        }
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


extension SearchAddressViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let text = searchTextField.text
    guard let text = text, text != "" else {
      print("nothing")
      searchTextField.resignFirstResponder()
      return true
    }
    searchTextField.resignFirstResponder()
    searchAddress(keyword: text)
    
    return true
  }
}

extension SearchAddressViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return addressData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
    let data = addressData[indexPath.item]
    cell.setInfo(data: data)
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = addressData[indexPath.item]
    delegate?.passAddressDataBack(addressData: data)
    self.navigationController?.popViewController(animated: true)
  }
  
}
