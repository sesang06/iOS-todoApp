//
//  PostViewController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 16/02/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
//
//enum Result<T> {
//  case success
//}

class PostRestaurantViewModel {
  
  // input
  let titleSubject = PublishSubject<String>()
  
  let detailSubject = PublishSubject<String>()
  
  let genreSubject = PublishSubject<[Restaurant.Genre]>()
  
  let submit = PublishSubject<Void>()
  //  let genreSubject =
  //    PublishSubject<
  
  
  // output
  
  let model: Driver<Restaurant>
  
  

  
  let disposeBag = DisposeBag()
  init(){
    
    titleSubject.subscribe(onNext: {
      debug_log($0)
    })
    detailSubject.subscribe(onNext: {
      debug_log($0)
    })
    submit.subscribe(onNext: {
      debug_log($0)
    })
    genreSubject.subscribe(onNext: { genreSubject in
      print(genreSubject)
    })
    
    
    
    let b = Observable.zip(titleSubject, detailSubject)
    
    b.subscribe(onNext: { genreSubject in
      print(genreSubject)
    })
    
    submit.withLatestFrom(b) { _, title in
      debug_log(title)
      var resturat = Restaurant()
    }
    
    let event = Observable.combineLatest(titleSubject, detailSubject, genreSubject, submit) { ($0, $1, $2, $3)
    }.share()
    
    let titleValid = event.map { !$0.0.isEmpty }.asDriver(onErrorJustReturn: false)
    let detailValid = event.map { !$0.1.isEmpty }.asDriver(onErrorJustReturn: false)
    
    
    self.model = event
      .map{ (items) in
        debug_log(items)
        var restuarant = Restaurant()
        restuarant.name = items.0
        restuarant.description = items.1
        restuarant.genre = items.2.first ?? .korean
        return restuarant
      }
      .asDriver(onErrorJustReturn: Restaurant())
    
    
  
    
  }
  
}
class PostRestaurantViewController: BaseViewController {
  typealias ViewModel = PostRestaurantViewModel
  
  let viewModel: ViewModel
  let disposeBag = DisposeBag()
  
  let titleTextField: UITextField = {
    let tf = UITextField()
    return tf
  }()
  
  
  let descriptionTextView: UITextView = {
    let tv = UITextView()
    return tv
  }()
  
  let genrePickerView: UIPickerView = {
    let pv = UIPickerView()
    return pv
  }()
  
  let stackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    return sv
  }()
  
  let submitButton: UIBarButtonItem = {
    let bbi = UIBarButtonItem()
    bbi.title = "제출"
    return bbi
  }()
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindViewModel()
  }
  
  override func setUpViews(){
    
    Observable.just(Restaurant.Genre.allCases)
      .bind(to: genrePickerView.rx.itemTitles)  {
        _, item in
        return item.rawValue
      }.disposed(by: disposeBag)
    view.addSubview(stackView)
    self.navigationController?.navigationBar.isTranslucent = false
    stackView.addArrangedSubview(titleTextField)
    stackView.addArrangedSubview(descriptionTextView)
    stackView.addArrangedSubview(genrePickerView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    navigationItem.rightBarButtonItem = submitButton
  }
  
  private func bindViewModel(){
    titleTextField.rx.text.orEmpty
      .asObservable()
      .bind(to: viewModel.titleSubject)
      .disposed(by: disposeBag)
    descriptionTextView.rx.text.orEmpty
      .asObservable()
      .bind(to: viewModel.detailSubject)
      .disposed(by: disposeBag)
    genrePickerView.rx.modelSelected(Restaurant.Genre.self)
      .asObservable()
      .bind(to: viewModel.genreSubject)
      .disposed(by: disposeBag)
    submitButton.rx.tap
      .bind(to: viewModel.submit)
      .disposed(by: disposeBag)
    viewModel.model.asObservable().subscribe(onNext: { model in
      print(model)
      
    }).disposed(by: disposeBag)
    
    Observable.combineLatest(viewModel.titleSubject, viewModel.detailSubject, viewModel.genreSubject, viewModel.submit) { ($0, $1, $2, $3)
      }.subscribe(onNext: {
        debug_log($0)
      })
    
    
  }
}
