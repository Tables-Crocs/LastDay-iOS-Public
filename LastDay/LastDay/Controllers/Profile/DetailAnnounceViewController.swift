//
//  DetailAnnounceViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class DetailAnnounceViewController: UIViewController {

  var data: AnnouncementData!
  
  @IBOutlet weak var detailTextView: UITextView!
  override func viewDidLoad() {
    super.viewDidLoad()
    setTextView()
  }
  
  private func setTextView() {
    detailTextView.text = data.text
  }
}
