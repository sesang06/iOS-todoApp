//
//  BaseViewController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 16/02/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
class BaseViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setUpViews()
    bind()
  }
  
  func setUpViews(){
    
  }
  func bind(){
    
  }
}
