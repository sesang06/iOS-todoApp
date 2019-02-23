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

class PostRestaurantViewModel {
  // input
  let titleSubject = PublishSubject<String>()
  
  let detailSubject = PublishSubject<String>()
  
  let genreSubject = PublishSubject<[Restaurant.Genre]>()
  //  let genreSubject =
  //    PublishSubject<
  
  
  // output
  
  init(){
    
    genreSubject.subscribe(onNext: { genreSubject in
      print(genreSubject)
    })
    
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
    stackView.addArrangedSubview(titleTextField)
    stackView.addArrangedSubview(descriptionTextView)
    stackView.addArrangedSubview(genrePickerView)
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
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
  }
}
