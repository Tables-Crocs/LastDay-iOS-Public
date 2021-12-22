//
//  CommunityViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit
import SnapKit

class CommunityViewController: UIViewController {
  
  var session: URLSession = URLSession.shared
  
  var favoriteCommunity:[CommunityData] = []
  var nearbyCommunity:[CommunityData] = []
  
  
  let tableViewHeightConstant: CGFloat = 30
  
  lazy var loadingView: LoadingView = {
    let view = LoadingView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  
  @IBOutlet weak var moreButton: UIButton!
  @IBOutlet weak var favoritesTableView: UITableView!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  @IBOutlet weak var nearbyCollectionView: UICollectionView!
  @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var scrollContentView: UIView!
  
  
  
  var isLoaded: Int = 0 {
    didSet {
      if isLoaded == 1 {
        loadingView.doneLoading()
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setFavoritesTableView()
    setLoadingView()
    getNearbyCommunity()
    setDelegates()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barStyle = .default
    getFavoriteCommunityList()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    relayoutTableView()
    
  }
  
  
  
  private func setLoadingView() {
    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
    loadingView.isLoading()
    view.bringSubviewToFront(loadingView)
  }
  
  
  private func setFavoritesTableView() {
    moreButton.setTitleColor(UIColor.mainTintColor, for: .normal)
    
    favoritesTableView.backgroundColor = .clear
    favoritesTableView.separatorStyle = .none
    
    
  }
  
  
  private func relayoutTableView() {
    tableViewHeight.constant = CGFloat(favoriteCommunity.count)*tableViewHeightConstant
    
    
    let height: CGFloat = UIScreen.main.bounds.width - 48
    collectionViewHeight.constant = height
    view.layoutIfNeeded()
    
    
    if scrollContentView.bounds.height <= scrollView.bounds.height {
      scrollView.isScrollEnabled = false
    } else {
      scrollView.isScrollEnabled = true
    }
  }
  
  private func setDelegates() {
    favoritesTableView.delegate = self
    favoritesTableView.dataSource = self
    
    nearbyCollectionView.delegate = self
    nearbyCollectionView.dataSource = self
  }
  
  
  private func getFavoriteCommunityList() {
    DispatchQueue.main.async {
      CommunityService.shared.favoriteCommunityList { [weak self] networkResult in
        switch networkResult {
        case .success(let data):
          guard let data = data as? [CommunityData] else { return }
          self?.favoriteCommunity = data
          self?.favoritesTableView.reloadData()
          self?.relayoutTableView()
          self?.isLoaded = 1
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
  }
  
  private func getNearbyCommunity() {
    DispatchQueue.main.async {
      CommunityService.shared.nearbyCommunity { [weak self] networkResult in
        switch networkResult {
        case .success(let data):
          guard let data = data as? [CommunityData] else { return }
          print(data)
          self?.nearbyCommunity = data
          self?.nearbyCollectionView.reloadData()


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
  }
  
  
  
  @IBAction func handleMoreButton(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(identifier: "TotalCommunityViewController") as! TotalCommunityViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  @IBAction func refreshNearby(_ sender: Any) {

    getNearbyCommunity()
  }
  
  
  
  private func showNewtorkError() {
    let alertViewController = UIAlertController(title: "서버 오류", message: "", preferredStyle: .alert)
    
    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    present(alertViewController, animated: true, completion: nil)
  }
  
}

extension CommunityViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favoriteCommunity.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
    let data = favoriteCommunity[indexPath.item]
    if data.provAbb == "" {
      cell.setInfo(community: data.abb, title: data.firstArticle)
    } else {
      cell.setInfo(community: data.provAbb + " " + data.abb, title: data.firstArticle)
      
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = storyboard?.instantiateViewController(identifier: "CommunityListViewController") as! CommunityListViewController
    let data = favoriteCommunity[indexPath.item]
    if data.provAbb == "" {
      vc.communityTitle = data.abb
    } else {
      vc.communityTitle = data.provAbb + " " + data.abb
    }
    vc.communityId = data.id
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
}

extension CommunityViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = (UIScreen.main.bounds.width - 64) / 2
    let height: CGFloat = width
    return CGSize(width: width, height: height)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 16
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return nearbyCommunity.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearbyCollectionViewCell", for: indexPath) as! NearbyCollectionViewCell
    let data = nearbyCommunity[indexPath.item]
    
    //    do {
    //      let url = URL(string: data.imageURL)
    //      let imgData = try Data(contentsOf: url!)
    //      let img = UIImage(data: imgData) ?? UIImage()
    //      cell.setInfo(image: img, name: data.abb)
    //    } catch {
    //      print(error)
    //    }
    let url = URL(string: data.imageURL)!
    session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
      if let imgData = try? Data(contentsOf: url){
        
        /// 이미지가 성공적으로 다운 > imageView에 넣기 위해 main thread로 전환 (주의: background가 아닌 main thread)
        DispatchQueue.main.async {
          /// 해당 셀이 보여지게 될때 imageView에 할당하고 cache에 저장
          /// 이미지를 업데이트하기전에 화면에 셀이 표시되는지 확인 (확인하지 않을경우, 스크롤하는 동안 이미지가 각 셀에서 불필요하게 재사용)
          let img = UIImage(data: imgData) ?? UIImage()
          cell.setInfo(image: img, name: data.abb)
        }
      }
    }).resume()
    
    
    //    cell.setInfo(image: data.image, name: data.abb)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let vc = storyboard?.instantiateViewController(identifier: "CommunityListViewController") as! CommunityListViewController
    let data = nearbyCommunity[indexPath.item]
    if data.provAbb == "" {
      vc.communityTitle = data.abb
    } else {
      vc.communityTitle = data.provAbb + " " + data.abb
    }
    vc.communityId = data.id
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
