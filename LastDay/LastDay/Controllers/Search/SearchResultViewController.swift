//
//  SearchResultViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/06.
//

import UIKit

class SearchResultViewController: UIViewController {
  
  
  @IBOutlet weak var startTextField: UITextField!
  
  @IBOutlet weak var firstTabBtn: UIButton!
  @IBOutlet weak var secondTabBtn: UIButton!
  @IBOutlet weak var thirdTabBtn: UIButton!
  @IBOutlet weak var fourthTabBtn: UIButton!
  
  @IBOutlet weak var noResultLabel: UILabel!
  
  
  @IBOutlet weak var destinationTextField: UITextField!
  @IBOutlet weak var resultTableView: UITableView!
  
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var session: URLSession = URLSession.shared

  
  let tableViewHeightConstant: CGFloat = 90

  var startStationData: StationData?
  var startAddressData: AddressData?
  var endStationData: StationData?
  var selectedTime: TimestampData?
  
  var frontData: [RecommendData] = []
  var firstData: [RecommendData] = []
  var secondData: [RecommendData] = []
  var thirdData: [RecommendData] = []
  var fourthData: [RecommendData] = []

  

  
  
  var selectedCategory: Int = 0 {
    didSet {
      if selectedCategory == 0 {
        firstTabBtn.setTitleColor(UIColor.mainTintColor, for: .normal)
        secondTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        thirdTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        fourthTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        
        frontData = firstData
        resultTableView.reloadData()
        
        if frontData.count == 0 {
          noResultLabel.isHidden = false
        } else {
          noResultLabel.isHidden = true
        }
        
        if frontData.count > 0 {
          resultTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
        
      } else if selectedCategory == 1 {
        firstTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        secondTabBtn.setTitleColor(UIColor.mainTintColor, for: .normal)
        thirdTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        fourthTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        
        frontData = secondData
        resultTableView.reloadData()
        
        if frontData.count == 0 {
          noResultLabel.isHidden = false
        } else {
          noResultLabel.isHidden = true
        }
        
        if frontData.count > 0 {
          resultTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
      } else if selectedCategory == 2 {
        firstTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        secondTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        thirdTabBtn.setTitleColor(UIColor.mainTintColor, for: .normal)
        fourthTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        
        frontData = thirdData
        resultTableView.reloadData()
        
        if frontData.count == 0 {
          noResultLabel.isHidden = false
        } else {
          noResultLabel.isHidden = true
        }
        
        if frontData.count > 0 {
          resultTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
      } else {
        firstTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        secondTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        thirdTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
        fourthTabBtn.setTitleColor(UIColor.mainTintColor, for: .normal)
        
        frontData = fourthData
        resultTableView.reloadData()
        
        if frontData.count == 0 {
          noResultLabel.isHidden = false
        } else {
          noResultLabel.isHidden = true
        }
        
        if frontData.count > 0 {
          resultTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
      }
    }
  }
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator.startAnimating()
    setTextFields()
    setTabBtns()
    setDelegates()
    
    getRecommendations()
    
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.clipsToBounds = true
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
    navigationController?.navigationBar.barStyle = .black

  }
  
  

  private func setTextFields() {
    startTextField.layer.cornerRadius = 8
    destinationTextField.layer.cornerRadius = 8
    
    startTextField.text = "반포대로1길"
    destinationTextField.text = "서울역"
    
    if let startStationData = startStationData, let endStationData = endStationData, let selectedTime = selectedTime {
      startTextField.text = startStationData.station
      destinationTextField.text =  selectedTime.timestamp + ", " + endStationData.station
    } else if let startAddressData = startAddressData, let endStationData = endStationData, let selectedTime = selectedTime {
      startTextField.text = startAddressData.address
      destinationTextField.text =  selectedTime.timestamp + ", " + endStationData.station
    }
  }
  
  private func setTabBtns() {
    firstTabBtn.setTitleColor(UIColor.mainTintColor, for: .normal)
    secondTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
    thirdTabBtn.setTitleColor(UIColor.darkGray, for: .normal)
    fourthTabBtn.setTitleColor(UIColor.darkGray, for: .normal)

  }
  
  private func setDelegates() {
    resultTableView.delegate = self
    resultTableView.dataSource = self
  }
  
  
  private func getRecommendations() {
//    guard let startStationData = startStationData, let selectedTime = selectedTime else {
//      return
//    }

    if let startStationData = startStationData, let selectedTime = selectedTime {
      for i in 0...3 {
        getStationRecommend(category: i, candidates: 15, station: startStationData, timestamp: selectedTime)
      }
    } else if let startAddressData = startAddressData, let endStationData = endStationData, let selectedTime = selectedTime {
      for i in 0...3 {
        getAddressRecommend(category: i, candidates: 15, address: startAddressData, station: endStationData, timestamp: selectedTime)
      }
    }
  
  }
  
  private func getStationRecommend(category: Int, candidates: Int, station: StationData, timestamp: TimestampData) {
    var contentType = 12
    switch category {
    case 1:
      contentType = 14
    case 2:
      contentType = 38
    case 3:
      contentType = 39
    default:
      break
    }
    
    RecommendationService.shared.getStationRecommend(contentType: contentType, candidates: candidates, station: station, timestamp: timestamp) { [weak self] (networkResult, contentType) in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [RecommendData] else { return }
        
        switch contentType {
        case 12:
          self?.firstData = data
          self?.frontData = data
          self?.activityIndicator.stopAnimating()
          self?.activityIndicator.isHidden = true
          self?.resultTableView.reloadData()
          if self?.frontData.count == 0 {
            self?.noResultLabel.isHidden = false
          } else {
            self?.noResultLabel.isHidden = true
          }
        case 14:
          self?.secondData = data
        case 38:
          self?.thirdData = data
        case 39:
          self?.fourthData = data
        default:
          break
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
        self?.showNewtorkError()
        print("networkFail")
      }
    }
  }
  
  
  private func getAddressRecommend(category: Int, candidates: Int, address: AddressData, station: StationData, timestamp: TimestampData) {
    var contentType = 12
    switch category {
    case 1:
      contentType = 14
    case 2:
      contentType = 38
    case 3:
      contentType = 39
    default:
      break
    }
    
    RecommendationService.shared.getAddressRecommend(contentType: contentType, candidates: candidates, address: address, station: station, timestamp: timestamp) { [weak self] (networkResult, contentType) in
      switch networkResult {
      case .success(let data):
        guard let data = data as? [RecommendData] else { return }
        
        switch contentType {
        case 12:
          self?.firstData = data
          self?.frontData = data
          self?.activityIndicator.stopAnimating()
          self?.activityIndicator.isHidden = true
          self?.resultTableView.reloadData()
          if self?.frontData.count == 0 {
            self?.noResultLabel.isHidden = false
          } else {
            self?.noResultLabel.isHidden = true
          }
        case 14:
          self?.secondData = data
        case 38:
          self?.thirdData = data
        case 39:
          self?.fourthData = data
        default:
          break
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
        self?.showNewtorkError()
        print("networkFail")
      }
    }
  }
  
  @IBAction func handleCloseButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func handleFirstTabBtn(_ sender: Any) {
    selectedCategory = 0
  }
  
  @IBAction func handleSecondTabBtn(_ sender: Any) {
    selectedCategory = 1
  }
  
  @IBAction func handleThirdTabBtn(_ sender: Any) {
    selectedCategory = 2
  }
  
  @IBAction func handleFourthTabBtn(_ sender: Any) {
    selectedCategory = 3
  }
  
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
}

extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return frontData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as! SearchResultTableViewCell
    let data = frontData[indexPath.item]
    
    cell.setInfo(data: data)
    if let imageURL = data.image {
      let url = URL(string: imageURL)!
      session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
        if let imgData = try? Data(contentsOf: url){
          
          /// 이미지가 성공적으로 다운 > imageView에 넣기 위해 main thread로 전환 (주의: background가 아닌 main thread)
          DispatchQueue.main.async {
            /// 해당 셀이 보여지게 될때 imageView에 할당하고 cache에 저장
            /// 이미지를 업데이트하기전에 화면에 셀이 표시되는지 확인 (확인하지 않을경우, 스크롤하는 동안 이미지가 각 셀에서 불필요하게 재사용)
            let img = UIImage(data: imgData) ?? UIImage()
            cell.setImage(image: img)
          }
        }
      }).resume()
    } else {
      
      cell.setDefaultImg()
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let recommendData = frontData[indexPath.item]
    let vc = storyboard?.instantiateViewController(identifier: "SearchDetailViewController") as! SearchDetailViewController
    
    vc.recommendData = recommendData
    
    var contentType = 12
    switch selectedCategory {
    case 1:
      contentType = 14
    case 2:
      contentType = 38
    case 3:
      contentType = 39
    default:
      break
    }
    
    vc.contentType = contentType
    
    if let startStationData = startStationData, let endStationData = endStationData {
      vc.startStation = startStationData
      vc.endStation = endStationData

    } else if let startAddressData = startAddressData, let endStationData = endStationData {
      vc.startAddress = startAddressData
      vc.endStation = endStationData

    }
    vc.isHistory = false
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
