//
//  OnboardingViewController.swift
//  LastDay
//
//  Created by Jinwook Huh on 2021/10/24.
//

import UIKit

class OnboardingViewController: UIViewController {
  
  @IBOutlet weak var onbordingCollectionView: UICollectionView!
  
  @IBOutlet weak var startButton: UIButton!
  let images = [UIImage(named: "tutorial01"), UIImage(named: "tutorial02"), UIImage(named: "tutorial03"), UIImage(named: "tutorial04")]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setDelegates()
    setStartbutton()
  }
  
  private func setDelegates() {
    onbordingCollectionView.delegate = self
    onbordingCollectionView.dataSource = self
  }
  
  
  private func setStartbutton() {

    
    startButton.layer.cornerRadius = startButton.layer.bounds.height / 2
    startButton.layer.backgroundColor = UIColor.mainTintColor.cgColor
    
    startButton.setTitleColor(UIColor.white, for: .normal)
    
    startButton.layer.shadowColor = UIColor.mainTintColor.cgColor
    startButton.layer.shadowOpacity = 1.0
    startButton.layer.shadowOffset = CGSize.zero
  }
  
  
  
  @IBAction func goToLogin(_ sender: Any) {
    UserDefaults.standard.set(true, forKey: UserDefaultKeys.seenOnboarding)

    let storyBoard = UIStoryboard(name: "Login", bundle: nil)
    let vc = storyBoard.instantiateViewController(identifier: "LoginViewController")
    
    guard let window = self.view.window else { return }
    
    window.rootViewController = vc
    
    let options: UIView.AnimationOptions = .transitionCrossDissolve
    let duration: TimeInterval = 0.15
    
    UIView.transition(
      with: window,
      duration: duration,
      options: options,
      animations: {},
      completion: { completed in
      }
    )
    
  }
  
  
  
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = collectionView.bounds.width
    let height: CGFloat = collectionView.bounds.height
    return CGSize(width: width, height: height)
  }

  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
    let img = images[indexPath.row] ?? UIImage()
    cell.setInformation(image: img)
    return cell
  }
}
