//
//  DetailArticleViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/09/26.
//

import UIKit
import SnapKit
import MessageInputBar

class DetailArticleViewController: UIViewController {
  
  
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var thumbButton: UIButton!
  @IBOutlet weak var scrapButton: UIButton!
  @IBOutlet weak var articleTextView: UITextView!
  @IBOutlet weak var likesCountLabel: UILabel!
  @IBOutlet weak var commentsCountLabel: UILabel!
  @IBOutlet weak var replyTableView: UITableView!
  
  @IBOutlet weak var reportButton: UIButton!
  
  @IBOutlet weak var articleTextHeight: NSLayoutConstraint!
  @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
  
  

  
  lazy var loadingView: LoadingView = {
    let view = LoadingView()
    view.backgroundColor = UIColor.white
    return view
  }()
  
  lazy var moreButton: UIBarButtonItem = {
    let button = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: #selector(more))
    button.tintColor = .lightGray
    return button
  }()
  
  var communityId: String = ""
  var postId: String = ""
  var postDetail: PostDetailData?
  var commentsInfo: [PostDetailData.CommentsData] = []
  var like: Bool = false
  var scrap: Bool = false
  
  let tableViewHeightConstant: CGFloat = 72
  var loaded:Bool = false {
    didSet {
      if loaded == true {
        loadingView.doneLoading()
      }
    }
  }
  
  
  private let messageInputBar: MessageInputBar
  
  override var inputAccessoryView: UIView? {
    return messageInputBar
  }
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  
  init() {
    self.messageInputBar = CommentInputBar()
    super.init()
    print("init func created")
    
  }
  
  required init?(coder: NSCoder) {
    self.messageInputBar = CommentInputBar()
    super.init(coder: coder)
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setLoadingView()
    setDelegates()
    addKeyboardHideGesture()
    setReplyTableView()
  }
  override func viewDidAppear(_ animated:Bool) {
    super.viewDidAppear(animated)
    getDetailPost()
  }
  
  private func addKeyboardHideGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(resignKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc func resignKeyboard() {
    messageInputBar.inputTextView.resignFirstResponder()
  }
  
  private func setLoadingView() {
    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalToSuperview()
    }
    view.bringSubviewToFront(loadingView)
    loadingView.isLoading()
  }
  
  private func getDetailPost() {
    DispatchQueue.main.async {
      CommunityService.shared.detailPost(postId: self.postId) {
        [weak self] networkResult in
        switch networkResult {
        case .success(let data):
          guard let data = data as? PostDetailData else { return }
          self?.postDetail = data
          self?.commentsInfo = data.comments
          self?.setElements(data: data)
          self?.replyTableView.reloadData()
          self?.setReplyTableViewHeight()
          self?.setArticleTextHeight()
          if data.mine {
            self?.navigationItem.rightBarButtonItem = self?.moreButton
          }
          self?.like = data.like
          self?.scrap = data.scrap
          self?.loaded = true
          
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
          let alertViewController = UIAlertController(title: "삭제된 게시물입니다.", message: "", preferredStyle: .alert)
          let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: { [weak self] (action) in
            self?.navigationController?.popViewController(animated: true)
          })
          alertViewController.addAction(cancelAction)
          self?.present(alertViewController, animated: true, completion: nil)
          
        case .networkFail:
          print("networkFail")
          self?.showNewtorkError()
        }
        
      }
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setReplyTableViewHeight()
    
  }
  
  
  private func setElements(data: PostDetailData) {
    if data.admin {
      usernameLabel.text = "운영자"
      reportButton.isHidden = true
    } else if data.mine {
      usernameLabel.text = "나"
      reportButton.isHidden = true
    } else {
      usernameLabel.text = "익명"
      reportButton.isHidden = false
    }
    titleLabel.text = data.title
    dateLabel.text = data.createdTime
    articleTextView.text = data.content
    likesCountLabel.text = String(data.likesCount)
    commentsCountLabel.text = String(data.commentsCount)
    
    thumbButton.layer.cornerRadius = 6
    thumbButton.layer.borderWidth = 1
    thumbButton.layer.borderColor = UIColor.mainTintColor.cgColor
    scrapButton.layer.cornerRadius = 6
    scrapButton.layer.borderWidth = 1
    scrapButton.layer.borderColor = UIColor.yellowColor.cgColor
    
    
    
    if data.scrap {
      scrapButton.setTitleColor(.white, for: .normal)
      scrapButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      scrapButton.layer.backgroundColor = UIColor.yellowColor.cgColor
    } else {
      scrapButton.setTitleColor(UIColor.yellowColor, for: .normal)
    }
    
    if data.like {
      thumbButton.setTitleColor(.white, for: .normal)
      thumbButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      thumbButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    } else {
      thumbButton.setTitleColor(UIColor.mainTintColor, for: .normal)
    }
    
    thumbButton.addTarget(self, action: #selector(onClickThumbButton), for: .touchUpInside)
    scrapButton.addTarget(self, action: #selector(onClickScrapButton), for: .touchUpInside)
    
    
  }
  
  
  
  @objc private func onClickThumbButton() {
    guard (postDetail?.likesCount) != nil else { return}
    if like == false {
      self.thumbButton.setTitleColor(.white, for: .normal)
      self.thumbButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      self.thumbButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
      let newCount = Int((self.likesCountLabel.text)!)
      CommunityService.shared.addFSL(id: postId, type: "like") { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("like success")
          self?.like = true
          self?.likesCountLabel.text = String(newCount!+1)
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
    } else {
      self.thumbButton.setTitleColor(UIColor.mainTintColor, for: .normal)
      self.thumbButton.layer.backgroundColor = UIColor.white.cgColor
      let newCount = Int((self.likesCountLabel.text)!)
      CommunityService.shared.deleteFSL(id: postId, type: "like") { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("like cancel")
          self?.like = false
          self?.likesCountLabel.text = String(newCount!-1)
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
  }
  
  
  
  @objc private func onClickScrapButton() {
    guard (postDetail?.scrapsCount) != nil else { return}
    if scrap == false {
      self.scrapButton.setTitleColor(.white, for: .normal)
      self.scrapButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
      self.scrapButton.layer.backgroundColor = UIColor.yellowColor.cgColor
      CommunityService.shared.addFSL(id: postId, type: "scrap") { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("scrap success")
          self?.scrap = true
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
          print("networkFail")
          self?.showNewtorkError()
        }
      }
    } else {
      self.scrapButton.setTitleColor(UIColor.yellowColor, for: .normal)
      self.scrapButton.layer.backgroundColor = UIColor.white.cgColor
      CommunityService.shared.deleteFSL(id: postId, type: "scrap") { [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("scrap cancel")
          self?.scrap = false
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
    }  }
  
  private func setArticleTextHeight() {
    let size = CGSize(width: articleTextView.frame.width, height: .infinity)
    let estismatedSize = articleTextView.sizeThatFits(size)
    articleTextHeight.constant = estismatedSize.height
  }
  
  private func setReplyTableViewHeight() {
    if commentsInfo.count == 0 {
      tableViewHeight.constant = 0
    } else {
      tableViewHeight.constant = CGFloat(commentsInfo.count)*tableViewHeightConstant + 50
    }
    
  }
  
  private func setReplyTableView() {
    replyTableView.backgroundColor = .clear
    
  }
  
  
  private func setDelegates() {
    replyTableView.delegate = self
    replyTableView.dataSource = self
    messageInputBar.delegate = self
    
  }
  
  @objc func more() {
    let alertViewController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let modifyAction = UIAlertAction(title: "수정", style: .default, handler: { [weak self] (action) in
      self?.modifyPost()
    })
    alertViewController.addAction(modifyAction)
    
    let deleteAction = UIAlertAction(title: "삭제", style: .default, handler: { [weak self] (action) in
      self?.presentDeleteAlert()
    })
    alertViewController.addAction(deleteAction)
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
    
  }
  
  private func modifyPost() {
    let vc = storyboard?.instantiateViewController(identifier: "NewArticleNavigationViewController") as! NewArticleNavigationViewController
    
    vc.modalPresentationStyle = .fullScreen
    vc.communityId = self.communityId
    vc.postId = postId
    vc.articleTitle = titleLabel.text
    vc.articleText = articleTextView.text
    vc.isNew = false
    
    present(vc, animated: true, completion: nil)
  }
  
  
  
  private func presentDeleteAlert() {
    let alertViewController = UIAlertController(title: "게시물을 삭제하시겠습니까?", message: "", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      self?.callDeletePost()
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  private func callDeletePost() {
    print("delete")
    CommunityService.shared.deletePost(postId: self.postId) {
      [weak self] networkResult in
      switch networkResult {
      case .success:
        self?.navigationController?.popViewController(animated: true)
        print("delete done")
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
  
  private func deleteCommentTapped(postId: String, commentId: String) {
    let alertViewController = UIAlertController(title: "댓글을 삭제하시겠습니까?", message: "", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      self?.deleteComment(postId: postId, commentId: commentId)
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  private func deleteComment(postId: String, commentId: String) {
    CommunityService.shared.deleteComment(postId: postId, commentId: commentId) { [weak self] networkResult in
      switch networkResult {
      case .success:
        self?.getDetailPost()
        print("delete done")
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
  
  private func reportCommentTapped(userId: String) {
    let alertViewController = UIAlertController(title: "댓글을 신고 하시겠습니까?", message: "해당 작성자의 게시물 및 댓글은 모두 차단됩니다.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      self?.report(userId: userId)
    })
    alertViewController.addAction(okAction)
    
    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
    alertViewController.addAction(cancelAction)
    self.present(alertViewController, animated: true, completion: nil)
  }
  
  private func report(userId: String) {
    CommunityService.shared.reportComment(userId: userId) { [weak self] networkResult in
      switch networkResult {
      case .success:
        
        let alertViewController = UIAlertController(title: "신고 접수 되었습니다", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: { [weak self] (action) in
          self?.getDetailPost()
        })
        alertViewController.addAction(cancelAction)
        self?.present(alertViewController, animated: true, completion: nil)
        
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
  
  private func reportPost(userId: String) {
    CommunityService.shared.reportPost(userId: userId) { [weak self] networkResult in
      switch networkResult {
      case .success:
        
        let alertViewController = UIAlertController(title: "신고 접수 되었습니다", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: { [weak self] (action) in
          self?.navigationController?.popViewController(animated: true)
        })
        alertViewController.addAction(cancelAction)
        self?.present(alertViewController, animated: true, completion: nil)
        
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
  

  
  
  @IBAction func reportPost(_ sender: Any) {
    let alertViewController = UIAlertController(title: "게시물을 신고 하시겠습니까?", message: "해당 작성자의 게시물 및 댓글은 모두 차단됩니다.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "확인", style: .default, handler: { [weak self] (action) in
      guard let userId = self?.postDetail?.userId else { return }
      self?.reportPost(userId: userId)
    })
    alertViewController.addAction(okAction)
    
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

extension DetailArticleViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableViewHeightConstant
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.commentsInfo.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyTableViewCell", for: indexPath) as! ReplyTableViewCell
    let data = self.commentsInfo[indexPath.item]
    if data.admin {
      cell.setInfo(userName: "운영자", content: data.content, time: data.createdTime, mine: data.mine)
    } else if data.mine {
      cell.setInfo(userName: "나", content: data.content, time: data.createdTime, mine: data.mine)
    } else if data.postOwner {
      cell.setInfo(userName: "익명(작성자)", content: data.content, time: data.createdTime, mine: data.mine)
    } else {
      cell.setInfo(userName: "익명", content: data.content, time: data.createdTime, mine: data.mine)
    }
    
    cell.delegate = self
    
    return cell
  }
  
  
}

extension DetailArticleViewController: ReplyCellDelegate {
  func btnCTapped(cell: ReplyTableViewCell) {
    let indexPath = self.replyTableView.indexPath(for: cell)
    let data = commentsInfo[indexPath!.row]
    let mine = data.mine
    let commentId = data.id
    let userId = data.userId
    
    if mine {
      deleteCommentTapped(postId: postId, commentId: commentId)
    } else {
      reportCommentTapped(userId: userId)
      
    }
  }
  
  
}

extension DetailArticleViewController: MessageInputBarDelegate {
  
  func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
    // Use to send the message
    //TODO: api connect
    
    let text = messageInputBar.inputTextView.text
    guard let text = text else {
      messageInputBar.inputTextView.text = String()
      return
    }
    DispatchQueue.main.async {
      guard self.postId != "" else {return}
      CommunityService.shared.createComment(postId: self.postId, content: text) {
        [weak self] networkResult in
        switch networkResult {
        case .success(_):
          print("comments created!")
          self?.getDetailPost()
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
    
    messageInputBar.inputTextView.text = String()
    messageInputBar.inputTextView.resignFirstResponder()
    
    
    
    
    
    
    
  }
  
  func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
    // Use to send a typing indicator
  }
  
  func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
    // Use to change any other subview insets
  }
  
}

