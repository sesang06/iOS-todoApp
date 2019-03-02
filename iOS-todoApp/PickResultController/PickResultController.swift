//
//  PickResultController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 03/03/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit
import RxCocoa
import RxViewController

protocol PickResultInput {
  var viewDidLoad : PublishSubject<Void> { get }
  var filter: PublishSubject<Filter> { get }
}

protocol PickResultOutput {
  
}

class PickResultViewModel {
  
  // input
  let viewDidLoad = PublishSubject<Void>()
  
  let filter = PublishSubject<Filter>()
  
  
}

class PickResultController: BaseViewController {

  override func setUpViews() {
    
  }
}
