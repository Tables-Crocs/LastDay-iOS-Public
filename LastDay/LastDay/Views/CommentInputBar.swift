//
//  CommentInputBar.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/22.
//

import UIKit
import MessageInputBar


class CommentInputBar: MessageInputBar {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    inputTextView.backgroundColor = UIColor.white
    inputTextView.placeholderTextColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
    inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
    inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
    inputTextView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
    inputTextView.layer.borderWidth = 1.0
    inputTextView.layer.cornerRadius = 16.0
    inputTextView.layer.masksToBounds = true
    inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    inputTextView.placeholder = "댓글을 입력하세요."
    
    setRightStackViewWidthConstant(to: 38, animated: false)
    setStackViewItems([sendButton, InputBarButtonItem.fixedSpace(2)], forStack: .right, animated: false)
    sendButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
    let image = UIImage(systemName: "paperplane.fill") ?? UIImage()
    sendButton.image = image.withRenderingMode(.alwaysTemplate)
    sendButton.title = nil
    sendButton.tintColor = UIColor.mainTintColor
    textViewPadding.right = -38
    separatorLine.isHidden = true
    backgroundView.backgroundColor = .white
    isTranslucent = true
  }
  
}
