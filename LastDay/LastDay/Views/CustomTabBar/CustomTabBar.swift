//
//  CustomTabBar.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/12.
//

import UIKit

class CustomTabBar: UIView {
  
  weak var delegate: CustomTabBarDelegate?
  
  // tintColor가 바뀔때 호출
  override open func tintColorDidChange() {
    super.tintColorDidChange()
    reloadApperance()
  }
  
  // Button과 indicator의 tintColor 수정
  func reloadApperance(){
    buttons().forEach { button in
      button.selectedColor = tintColor
    }
    indicatorView.tintColor = tintColor
  }
  
  private var indicatorViewYConstraint: NSLayoutConstraint!
  private var indicatorViewXConstraint: NSLayoutConstraint!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  deinit {
    stackView.arrangedSubviews.forEach {
      if let button = $0 as? UIControl {
        button.removeTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
      }
    }
  }
  
  func select(at index: Int, notifyDelegate: Bool = true){
    for (bIndex, view) in stackView.arrangedSubviews.enumerated() {
      if let button = view as? UIButton {
        button.tintColor =  bIndex == index ? tintColor : UIColor.red
      }
    }
    
  }
  
  override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let position = touches.first?.location(in: self) else {
      super.touchesEnded(touches, with: event)
      return
    }
    
    let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? BarButton }.filter { !$0.isHidden }
    let distances = buttons.map { $0.center.distance(to: position) }
    
    let buttonsDistances = zip(buttons, distances)
    
    if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
      buttonTapped(sender: closestButton.0)
    }
  }
  
  var items: [UITabBarItem] = [] {
    didSet {
      reloadViews()
    }
  }
  
  lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.alignment = .center
//    stackView.spacing =
    

    
    return stackView
  }()
  
  lazy var indicatorView: PointIndicatorView = {
    let view = PointIndicatorView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.constraint(width: 4)
    view.backgroundColor = tintColor
    view.makeWidthEqualHeight()
    
    return view
  }()
  // tabBar items button들 반환
  private func buttons() -> [BarButton] {
    return stackView.arrangedSubviews.compactMap { $0 as? BarButton }
  }
  
  // stackView와 indicatorView 작업
  private func setup() {
    translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stackView)
    addSubview(indicatorView)
    
    // FIXME: TabBar 배경색
    self.backgroundColor = .clear
    
    indicatorViewYConstraint?.isActive = false
    indicatorViewYConstraint =
      indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
    indicatorViewYConstraint.isActive = true
    
    tintColorDidChange()
  }
  
  // tabBar items 정한 후 작업
  func reloadViews() {
    indicatorViewYConstraint?.isActive = false
    indicatorViewYConstraint =
      indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -0)
    indicatorViewYConstraint.isActive = true
    
    // 먼저 제대로 삭제해준다.
    for button in buttons() {
      stackView.removeArrangedSubview(button)
      button.removeFromSuperview()
      button.removeTarget(self, action: nil, for: .touchUpInside)
    }
    
    for item in items {
      if let image = item.image {
        addButton(with: image, selected: item.selectedImage!)
      } else {
        addButton(with: UIImage(), selected: UIImage())
      }
    }
  }
  
  private func addButton(with image: UIImage, selected: UIImage) {
    let button = BarButton(image: image, selected: selected)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.selectedColor = tintColor
    button.adjustsImageWhenHighlighted = false
    button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    self.stackView.addArrangedSubview(button)
  }
  
  @objc func buttonTapped(sender: BarButton) {
    if let index = stackView.arrangedSubviews.firstIndex(of: sender) {
      select(at: index)
    }
  }
  
  // indicator 움직이기
  func select(at index: Int) {
    if indicatorViewXConstraint != nil {
      indicatorViewXConstraint.isActive = false
      indicatorViewXConstraint = nil
    }
    
    for (bIndex, button) in buttons().enumerated() {
      button.selectedColor = tintColor
      button.isSelected = bIndex == index
      
      if bIndex == index {
        indicatorViewXConstraint =
          indicatorView.centerXAnchor
          .constraint(equalTo: button.centerXAnchor)
        indicatorViewXConstraint.isActive = true
      }
    }
    
    UIView.animate(withDuration: 0.25) {
      self.layoutIfNeeded()
    }
    
    delegate?.customTabBar(self, didSelectItemAt: index)
    
  }
  // stackView 오토레이아웃
  override func layoutSubviews() {
    super.layoutSubviews()
    stackView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
  }
  
}

