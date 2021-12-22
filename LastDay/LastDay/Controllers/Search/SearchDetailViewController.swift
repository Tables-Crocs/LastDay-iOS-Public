//
//  SearchDetailViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/10.
//

import UIKit
import SnapKit
import KakaoSDKCommon
import MapKit

class SearchDetailViewController: UIViewController {
  
  
  @IBOutlet weak var endCircle: UIView!
  @IBOutlet weak var middleCircle: UIView!
  @IBOutlet weak var startCircle: UIView!
  
  @IBOutlet weak var startLabel: UILabel!
  @IBOutlet weak var midLabel: UILabel!
  @IBOutlet weak var endLabel: UILabel!
  
  @IBOutlet weak var locationImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailTextView: UITextView!

  
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var kakaoMapBtn: UIButton!
  @IBOutlet weak var saveBtn: UIButton!
  
  @IBOutlet weak var saveBtnWidth: NSLayoutConstraint!
  @IBOutlet weak var noImageLabel: UILabel!
  
  @IBOutlet weak var textViewHeight: NSLayoutConstraint!
  
  
  
  var startAddress: AddressData?
  var startStation: StationData?
  var endStation: StationData?
  var recommendData: RecommendData?
  var contentType: Int!
  var isHistory: Bool!
  var historyId: String?
  var loc_x: Double?
  var loc_y: Double?

  
  lazy var loadingView: LoadingView = {
    let view = LoadingView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  var isLoaded: Int = 0 {
    didSet {
      if isLoaded == 1 {
        loadingView.doneLoading()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setPath()
    setSaveButton()
    setLoadingView()

    getContent()
    
    


    
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
//    navigationController?.navigationBar.barTintColor = UIColor.white
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor

    navigationController?.navigationBar.barStyle = .default

  }
  
  private func setLoadingView() {
    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
    loadingView.isLoading()
    view.bringSubviewToFront(loadingView)
  }
  
  private func setPath() {
    
    startCircle.layer.borderColor = UIColor.mainTintColor.cgColor
    startCircle.layer.borderWidth = 3
    startCircle.layer.cornerRadius = startCircle.bounds.width/2
    
    middleCircle.layer.borderColor = UIColor.mainTintColor.cgColor
    middleCircle.layer.borderWidth = 3
    middleCircle.layer.cornerRadius = middleCircle.bounds.width/2
    
    endCircle.layer.borderColor = UIColor.mainTintColor.cgColor
    endCircle.layer.borderWidth = 3
    endCircle.layer.cornerRadius = endCircle.bounds.width/2
  }
  
  
  private func setSaveButton() {
    if isHistory {
      saveBtn.layer.borderWidth = 1
      saveBtn.layer.borderColor = UIColor.mainTintColor.cgColor
      saveBtn.tintColor = UIColor.mainTintColor
      saveBtn.layer.cornerRadius = 6
      saveBtn.setTitle("저장 취소", for: .normal)
      saveBtnWidth.constant = 80
      saveBtn.addTarget(self, action: #selector(removeHistoryAlert), for: .touchUpInside)
    } else {
      saveBtn.layer.borderWidth = 1
      saveBtn.layer.borderColor = UIColor.mainTintColor.cgColor
      saveBtn.tintColor = UIColor.mainTintColor
      saveBtn.layer.cornerRadius = 6
      saveBtn.addTarget(self, action: #selector(addHistoryAlert), for: .touchUpInside)
    }
    
    kakaoMapBtn.layer.borderWidth = 1
    kakaoMapBtn.layer.borderColor = UIColor.mainTintColor.cgColor
    kakaoMapBtn.tintColor = UIColor.mainTintColor
    kakaoMapBtn.layer.cornerRadius = 6
//    saveBtn.addTarget(self, action: #selector(addHistoryAlert), for: .touchUpInside)
    
  }
  
  private func setArticleTextHeight() {
    let size = CGSize(width: detailTextView.frame.width, height: .infinity)
    let estismatedSize = detailTextView.sizeThatFits(size)
    textViewHeight.constant = estismatedSize.height
  }
  
  private func setContent(data: ContentData, completion: () -> ()) {
    titleLabel.text = data.title
    detailTextView.text = data.overview
    
    guard let recommendData = recommendData else {
      return
    }
    
    timeLabel.text = "이동시간: 총 \(recommendData.travelTime)분"
    
    
    if let startStation = startStation {
      startLabel.text = startStation.station
    } else if let startAddress = startAddress {
      startLabel.text = startAddress.title
    }
    
    midLabel.text = data.title
    
    guard let endStation = endStation else {
      print("No end station")
      return
    }

    endLabel.text = endStation.station
    
    if let imageUrl = data.imageUrl {
      do {
        let url = URL(string: imageUrl)
        let data = try Data(contentsOf: url!)
        locationImageView.image = UIImage(data: data)
        completion()
      } catch {
        print(error)
      }
    } else {
      noImageLabel.isHidden = false
      locationImageView.image = nil
      completion()
    }
    


  }
  
  
  private func getContent() {
    
    
    guard let recommendData = recommendData else {
      return
    }

    ContentService.shared.getContent(recommendData: recommendData, contentType: contentType) { [weak self] networkResult in
      switch networkResult {
      case .success(let data):
        guard let data = data as? ContentData else { return }
        self?.setContent(data: data) { [weak self] in
          self?.setArticleTextHeight()
          self?.isLoaded = 1
          self?.loc_x = data.location["x"]
          self?.loc_y = data.location["y"]
          
          print("location")
          print(self?.loc_x)


          
        }
        print("got content")
        
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
  
  private func disableSaveBtn() {
    saveBtn.layer.borderColor = UIColor.lightGray.cgColor
    saveBtn.tintColor = UIColor.lightGray
    saveBtn.setTitleColor(UIColor.lightGray, for: .normal)
    saveBtn.isUserInteractionEnabled = false
    
  }
  
  private func enableSaveBtn() {
    saveBtn.layer.borderColor = UIColor.mainTintColor.cgColor
    saveBtn.tintColor = UIColor.mainTintColor
    saveBtn.setTitleColor(UIColor.mainTintColor, for: .normal)
    saveBtn.isUserInteractionEnabled = true
  }
  
  
  @objc func addHistoryAlert() {
    let alertViewController = UIAlertController(title: "저장 하시겠습니까?", message: "", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      self?.addToHistory()
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  
  private func addToHistory() {
    disableSaveBtn()

    if let startStation = startStation, let endStation = endStation, let recommendData = recommendData {
      HistoryService.shared.postHistory(sourceTitle: startStation.station, destTitle: endStation.station, contentId: recommendData.id, contentTitle: recommendData.title, contentType: contentType, timeTaken: recommendData.travelTime) { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("success")
          
        case .requestErr(let message):
          self?.enableSaveBtn()

          if let message = message as? String {
            print(message)
          }
          self?.showNewtorkError()
        case .pathErr :
          self?.enableSaveBtn()

          print("pathErr")
        case .serverErr :
          self?.enableSaveBtn()
          self?.showNewtorkError()
          print("serverErr")
        case .networkFail:
          self?.enableSaveBtn()
          self?.showNewtorkError()
          print("networkFail")
        }
        
      }
    } else if let startAddress = startAddress, let endStation = endStation, let recommendData = recommendData {
      HistoryService.shared.postHistory(sourceTitle: startAddress.title, destTitle: endStation.station, contentId: recommendData.id, contentTitle: recommendData.title, contentType: contentType, timeTaken: recommendData.travelTime) { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("success")
          
        case .requestErr(let message):
          self?.enableSaveBtn()

          if let message = message as? String {
            print(message)
          }
          self?.showNewtorkError()
        case .pathErr :
          self?.enableSaveBtn()

          print("pathErr")
        case .serverErr :
          self?.enableSaveBtn()
          self?.showNewtorkError()
          print("serverErr")
        case .networkFail:
          self?.enableSaveBtn()
          self?.showNewtorkError()
          print("networkFail")
        }
        
      }
    }
  }
  
  @objc func removeHistoryAlert() {
    let alertViewController = UIAlertController(title: "삭제 하시겠습니까?", message: "", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      self?.removeFromHistory()
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  private func removeFromHistory() {
    disableSaveBtn()
    guard let historyId = historyId else {
      return
    }

    HistoryService.shared.deleteHistory(id: historyId) { [weak self] networkResult in
      switch networkResult {
      case .success:
        print("delete")
        self?.navigationController?.popViewController(animated: true)
      case .requestErr(let message):

        if let message = message as? String {
          print(message)
        }
        self?.showNewtorkError()
      case .pathErr :
        self?.enableSaveBtn()
        self?.showNewtorkError()
        print("pathErr")
      case .serverErr :
        self?.enableSaveBtn()
        self?.showNewtorkError()
        print("serverErr")
      case .networkFail:
        self?.enableSaveBtn()
        self?.showNewtorkError()
        print("networkFail")
      }
    }
  }
  
  private func goToKakapMap() {
    let place = recommendData?.title
    guard let place = place else { return }
    let kakaoMap = "kakaomap://search?q=" + place
    let encoded = kakaoMap.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let kakaoURL = NSURL(string: encoded)
    if (UIApplication.shared.canOpenURL(kakaoURL! as URL)) {
      
      //open(_:options:completionHandler:) 메소드를 호출해서 카카오톡 앱 열기
      UIApplication.shared.open(kakaoURL! as URL)
    }
    //사용 불가능한 URLScheme일 때(카카오톡이 설치되지 않았을 경우)
    else {
      let appStore = "https://apps.apple.com/kr/app/%EC%B9%B4%EC%B9%B4%EC%98%A4%EB%A7%B5-%EB%8C%80%ED%95%9C%EB%AF%BC%EA%B5%AD-no-1-%EC%A7%80%EB%8F%84%EC%95%B1/id304608425"
      let encoded = appStore.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
      let appStoreUrl = NSURL(string: encoded)
      UIApplication.shared.open(appStoreUrl! as URL)

    }
  }
  
  private func goToAppleMap() {
    let lat = self.loc_y ?? 37.557188058432835
    let long = self.loc_x ?? 126.94364165337521
    
    
    let coordinate = CLLocationCoordinate2DMake(lat, long)
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
    let name = recommendData?.title ?? "서울"
    mapItem.name = name
    mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    
    
  }
  
  
  @IBAction func presentMapAlert(_ sender: Any) {
    let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let appleAction = UIAlertAction(title: "지도 앱에서 보기", style: .default, handler: { [weak self] (action) in
      self?.goToAppleMap()
    })
    alertViewController.addAction(appleAction)
    
    let kakaoAction = UIAlertAction(title: "카카오맵에서 보기", style: .default, handler: { [weak self] (action) in
      self?.goToKakapMap()
    })
    alertViewController.addAction(kakaoAction)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
}
