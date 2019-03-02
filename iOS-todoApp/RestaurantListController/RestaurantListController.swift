//
//  RestaurantListController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 02/03/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import RxDataSources
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

class RestaurantListViewModel {
  // input
  
  let viewDidAppear = PublishSubject<Void>()
  
  // output
  
  lazy var data: Driver<[RestaurantList]> = {
    return viewDidAppear.asObserver()
      .map { sampleData }
      .map { [RestaurantList(items: $0)] }
      .asDriver(onErrorJustReturn: [])
  }()
  
  
}

class RestaurantCell: BaseTableCell {
  let titleLabel: UILabel = {
    let l = UILabel()
    return l
  }()
  
  override func setUpViews() {
    self.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}


struct RestaurantList {
  var items: [Item]
}
extension RestaurantList: SectionModelType {
  typealias Item = Restaurant
  
  init(original: RestaurantList, items: [Item]) {
    self = original
    self.items = items
  }
}

class RestaurantListController: BaseViewController {
  
  typealias ViewModel = RestaurantListViewModel
  let identifier = "tableView"
  
  let tableView: UITableView = {
    let tv = UITableView()
    return tv
  }()
  
  
  let dataSource = RxTableViewSectionedReloadDataSource<RestaurantList>(
    configureCell: { dataSource, tableView, indexPath, item in
      let cell = tableView.dequeueReusableCell(withIdentifier: "tableView", for: indexPath) as! RestaurantCell
      cell.titleLabel.text = "aa"
      return cell
  })
  
  let viewModel = ViewModel()
  
  override func setUpViews() {
    self.view.addSubview(tableView)
    tableView.register(RestaurantCell.self, forCellReuseIdentifier: identifier)
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func bind() {
    self.rx.viewDidAppear
      .asObservable()
      .map { _ in () }
      .bind(to: viewModel.viewDidAppear)
      .disposed(by: disposeBag)
    self.viewModel.data
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: disposeBag)
  }
  
}
