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


fileprivate let sampleData: [Restaurant] = {
  let dataOne: Restaurant = {
    var a = Restaurant()
    a.location = "hello world"
    a.name = "heelo!!"
    return a
  }()
  let dataTwo: Restaurant = {
    var a = Restaurant()
    a.location = "hello world"
    a.name = "heelo!!"
    return a
  }()
  let dataThree: Restaurant = {
    var a = Restaurant()
    a.location = "hello world"
    a.name = "heelo!!"
    return a
  }()
  return [dataOne, dataTwo, dataThree]
}()


protocol PickResultInput {
  var viewDidLoad : PublishSubject<Void> { get }
  var filter: PublishSubject<Filter> { get }
  var buttonDidTap : PublishSubject<Void> { get }
}

protocol PickResultOutput {
  var result: Driver<Restaurant> { get }
}

class PickResultViewModel: PickResultInput, PickResultOutput{
 
  
  
  // input
  let viewDidLoad = PublishSubject<Void>()
  
  let filter = PublishSubject<Filter>()
  
  let buttonDidTap = PublishSubject<Void>()
  
  // output
  var result: Driver<Restaurant>
  
  
  
  let restaurants = BehaviorRelay<[Restaurant]>(value: [])
  
  init(){
    self.result = Driver<Restaurant>.from(optional: nil)
  }
  
  
}

class PickResultController: BaseViewController {

  let pickButton: UIButton = {
    let b = UIButton()
    b.tintColor = .black
    b.setTitle("뽑기", for: .normal)
    return b
  }()
  
  let resultLabel: UILabel = {
    let label = UILabel()
    label.text = "결과"
    return label
  }()
  override func setUpViews() {
//    rx.viewDidLoad.as
  }
}
