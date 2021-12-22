//
//  SearchPathViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/06.
//

import UIKit

class SearchPathViewController: UIViewController {

  @IBOutlet weak var pathTextField: UITextField!
  @IBOutlet weak var searchPathBtn: ButtonWithImage!
  
  @IBOutlet weak var stationTextField: UITextField!
  @IBOutlet weak var searchStationBtn: ButtonWithImage!
  
  
  @IBOutlet weak var timePickerView: UIPickerView!
  
  @IBOutlet weak var nextButton: UIButton!
  let timeConverter = TimeConverter()
  let ampm = TimePickerData.shared.ampm
  let hour = TimePickerData.shared.hour
  let min = TimePickerData.shared.min
  
  var selectedAddress: AddressData?
  var selectedStation: StationData?
  var selectedTime: TimestampData?
  
  
  var startSelected: Int = 0 {
    didSet {
      judgeNextButton()
    }
  }
  
  var stationSelected: Int = 0 {
    didSet {
      judgeNextButton()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDelegates()
    setSearchPathBtn()
    setSearchStationBtn()
    setTimePicker()
    setNextButton()
    selectedTime = getTimestamp()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.barStyle = .default
    navigationController?.navigationBar.isHidden = false
    navigationController?.navigationBar.tintColor = UIColor.mainTintColor
  }
  
  private func setSearchPathBtn() {
    searchPathBtn.layer.borderColor = UIColor.mainTintColor.cgColor
    searchPathBtn.layer.borderWidth = 1.5
    searchPathBtn.layer.cornerRadius = 8
    

    searchPathBtn.tintColor = UIColor.lightGray
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 24)
    let image = UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig)

    searchPathBtn.setImage(image, for: .normal)

    searchPathBtn.adjustsImageWhenHighlighted = false
  }
  
  private func setSearchStationBtn() {
    searchStationBtn.layer.borderColor = UIColor.mainTintColor.cgColor
    searchStationBtn.layer.borderWidth = 1.5
    searchStationBtn.layer.cornerRadius = 8
    

    searchStationBtn.tintColor = UIColor.lightGray
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 24)
    let image = UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig)

    searchStationBtn.setImage(image, for: .normal)

    searchStationBtn.adjustsImageWhenHighlighted = false
    
  }
  
  private func setTimePicker() {
    timePickerView.layer.borderColor = UIColor.mainTintColor.cgColor
    timePickerView.layer.borderWidth = 1.5
    timePickerView.layer.cornerRadius = 8
    
    
    let recentTime = timeConverter.getTimeStr(date: Date())
    print(Date())
    print(recentTime)
    let timeComponents = recentTime.components(separatedBy: " ")
    
    
    if let index = ampm.firstIndex(of: timeComponents[0]) {
      timePickerView.selectRow(index, inComponent: 0, animated: false)
    }
    if let index = hour.firstIndex(of: timeComponents[1]) {
      timePickerView.selectRow(index, inComponent: 1, animated: false)
    }
    if let index = min.firstIndex(of: timeComponents[2]) {
      timePickerView.selectRow(index, inComponent: 3, animated: false)
    }
  }
  
  private func setNextButton() {
    nextButton.backgroundColor = UIColor.mainTintColor
    nextButton.tintColor = UIColor.white
    nextButton.layer.cornerRadius = 8
    nextButton.isHidden = true
  }
  
  private func setDelegates() {
    timePickerView.delegate = self
    timePickerView.dataSource = self
  }
  
  private func getTimestamp() -> TimestampData{
    let ampm = ampm[timePickerView.selectedRow(inComponent: 0)]
    let hour = hour[timePickerView.selectedRow(inComponent: 1)]
    let min = min[timePickerView.selectedRow(inComponent: 3)]
    
    let timestampData = TimestampData(hour: hour, min: min, ampm: ampm)
    return timestampData

  }
  
  func judgeNextButton() {
    if startSelected == 1 && stationSelected == 1 {
      nextButton.isHidden = false
    } else {
      nextButton.isHidden = true
    }
  }
  
  
  @IBAction func searchStart(_ sender: Any) {
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "SearchAddressViewController") as! SearchAddressViewController
    vc.delegate = self
    navigationController?.pushViewController(vc, animated: true)
    
  }
  
  @IBAction func searchStation(_ sender: Any) {
    let vc = storyboard?.instantiateViewController(withIdentifier: "SearchLocationViewController") as! SearchLocationViewController
    vc.delegate = self
    navigationController?.pushViewController(vc, animated: true)
  }
  

  
}


extension SearchPathViewController: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

    if component == 0 {
      pickerView.subviews.forEach {
        $0.backgroundColor = .clear
      }
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width*0.5, height: 20))
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width*0.5, height: 20))
      
      label.text = ampm[row]
      label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
      label.textColor = UIColor.gray
      label.textAlignment = .center
      view.addSubview(label)
      label.snp.makeConstraints { make in
        make.centerX.centerY.equalToSuperview()
      }
      
      return view
    } else if component == 1 {
      pickerView.subviews.forEach {
        $0.backgroundColor = .clear
      }
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width*0.25, height: 20))
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width*0.25, height: 20))
      
      label.text = hour[row]
      label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
      label.textColor = UIColor.gray
      label.textAlignment = .center
      view.addSubview(label)
      label.snp.makeConstraints { make in
        make.centerX.centerY.equalToSuperview()
      }
      
      return view
    }
    else if component == 2 {
      pickerView.subviews.forEach {
        $0.backgroundColor = .clear
      }
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width, height: 20))
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width, height: 20))
      
      label.text = ":"
      label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
      label.textColor = UIColor.gray
      label.textAlignment = .center
      view.addSubview(label)
      label.snp.makeConstraints { make in
        make.centerX.centerY.equalToSuperview()
      }
      
      return view
    }
    else {
      pickerView.subviews.forEach {
        $0.backgroundColor = .clear
      }
      
      let view = UIView(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width*0.25, height: 20))
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: timePickerView.bounds.width*0.25, height: 20))
      
      label.text = min[row]
      label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
      label.textColor = UIColor.gray
      label.textAlignment = .center
      view.addSubview(label)
      label.snp.makeConstraints { make in
        make.centerX.centerY.equalToSuperview()
      }
      
      return view
    }
    
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return 24
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    if component == 0 {
      return timePickerView.bounds.width*0.33
    } else if component == 2 {
      return timePickerView.bounds.width*0.01
    }
    else {
      return timePickerView.bounds.width*0.33
    }
  }
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
    selectedTime = getTimestamp()
    
  }
}

extension SearchPathViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 4
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
    if component == 0 {
      return ampm.count
      
    } else if component == 1 {
      return hour.count
    } else if component == 2 {
      return 1
    } else {
      return min.count
    }
  }
}

extension SearchPathViewController: CanRecieveAddress {
  func passAddressDataBack(addressData: AddressData) {
    pathTextField.text = addressData.address
    selectedAddress = addressData
    startSelected = 1
    
  }
  
  
}


extension SearchPathViewController: CanRecieveStation {
  func passStationDataBack(stationData: StationData) {
    stationTextField.text = stationData.station
    selectedStation = stationData
    stationSelected = 1
  }
}
