//
//  PickViewController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 24/02/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxDataSources
import RxCocoa
import RxSwift

enum MultipleSectionModel {
  case GenreSection(title: String, items: [SectionItem])
  case FoodGenreSection(title: String, items: [SectionItem])
}

enum SectionItem {
  case GenreItem(item: Restaurant.Genre, isChecked: Bool)
  case FoodGenreItem(item: Restaurant.FoodGenre, isChecked: Bool)
}

extension MultipleSectionModel: SectionModelType {
  typealias Item = SectionItem
  
  var items: [SectionItem] {
    switch self {
    case .GenreSection(title: _, items: let items):
      return items.map { $0 }
    case .FoodGenreSection(title: _, items: let items):
      return items.map { $0 }
    }
  }
  
  init(original: MultipleSectionModel, items: [Item]){
    switch original {
    case let .GenreSection(title: title, items: _):
      self = .GenreSection(title: title, items: items)
    case let .FoodGenreSection(title: title, items: _):
      self = .FoodGenreSection(title: title, items: items)
    }
  }
}

extension MultipleSectionModel {
  var title: String {
    switch self {
    case .GenreSection(title: let title, items: _):
      return title
    case .FoodGenreSection(title: let title, items: _):
      return title
    }
  }
}

extension PickerViewController {
  static func dataSource() -> RxCollectionViewSectionedReloadDataSource<MultipleSectionModel> {
    return RxCollectionViewSectionedReloadDataSource<MultipleSectionModel>(
      configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
        
        switch dataSource[indexPath] {
        
        case .GenreItem(let item, let isChecked):
          let cell: GenreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreIdentifer", for: indexPath) as! GenreCell
          cell.label.text = item.rawValue
          if isChecked {
            cell.label.backgroundColor = .red
          } else {
            cell.label.backgroundColor = .white
          }
          return cell
        case .FoodGenreItem(let item, let isChecked):
          let cell: GenreCell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreIdentifer", for: indexPath) as! GenreCell
          cell.label.text = item.rawValue
          if isChecked {
            cell.label.backgroundColor = .red
          } else {
            cell.label.backgroundColor = .white
          }
          return cell
        }
    },
      configureSupplementaryView: { dataSource, collectionView, kind, index in
        let section: GenreCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "section", for: index) as! GenreCell
        section.label.text = dataSource[index.section].title
        return section
    }
    )
  }
}
class GenreCell: UICollectionViewCell {
  let label: UILabel = {
    let l = UILabel()
    return l
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    setUpViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpViews(){
    self.addSubview(label)
    label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}

class PickerViewModel {
  
  let itemSelected = PublishSubject<IndexPath>()
  
  var result: Driver<[MultipleSectionModel]> {
    return dataSource.asDriver()
  }
  let dataSource: BehaviorRelay<[MultipleSectionModel]>
  init(dataSource: [MultipleSectionModel]){
    self.dataSource = BehaviorRelay<[MultipleSectionModel]>(value: dataSource)
    
    itemSelected.subscribe(onNext: { indexPath in
      var newDataSource = self.dataSource.value
      var items = newDataSource[indexPath.section].items
      
      switch items[indexPath.item] {
      case let .FoodGenreItem(item: item, isChecked: isChecked):
        items[indexPath.item] = .FoodGenreItem(item: item, isChecked: !isChecked)
      case let .GenreItem(item: item, isChecked: isChecked):
        items[indexPath.item] = .GenreItem(item: item, isChecked: !isChecked)
     
      }
      
      switch newDataSource[indexPath.section]  {
      case .FoodGenreSection(title: let title, items: _):
        newDataSource[indexPath.section] = .FoodGenreSection(title: title, items: items)
      case .GenreSection(title: let title, items: _):
         newDataSource[indexPath.section] = .GenreSection(title: title, items: items)
      }
      self.dataSource.accept(newDataSource)
    })
    
    
  }
  
  
}

class PickerViewController: BaseViewController {
  typealias ViewModel = PickerViewModel
  let genreIdentifer = "genreIdentifer"
  let sections: [MultipleSectionModel] = [
    .GenreSection(title: "음식점 종류",
                  items: Restaurant.Genre.allCases.map{ SectionItem.GenreItem(item: $0, isChecked: false) }),
    .FoodGenreSection(title: "음식 종류",
                      items: Restaurant.FoodGenre.allCases.map{ SectionItem.FoodGenreItem(item: $0, isChecked: false) } )
  ]
  
  lazy var viewModel = ViewModel(dataSource: sections)
  let titleLabel: UILabel = {
    let l = UILabel()
    l.text = "필터를 골라 주세요."
    return l
  }()
  
  let pickButton: UIButton = {
    let b = UIButton()
    b.setTitle("고르기", for: .normal)
    b.setTitleColor(.black, for: .normal)
    return b
  }()
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
      layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 200)
    let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    cv.backgroundColor = .white
    cv.register(GenreCell.self, forCellWithReuseIdentifier: "genreIdentifer")
    cv.register(GenreCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "section")
    return cv
  }()
  
  let stackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    return sv
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isTranslucent = false
    bindViews()
  }
  
  override func setUpViews() {
    super.setUpViews()
    view.addSubview(stackView)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(collectionView)
    stackView.addArrangedSubview(pickButton)
    
    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(100)
    }
    pickButton.snp.makeConstraints { make in
      make.height.equalTo(100)
    }
    
  }
  
  func bindViews(){
    let dataSource = PickerViewController.dataSource()
    
    
//    Observable.just(sections)
//      .bind(to: collectionView.rx.items(dataSource: dataSource))
//    .disposed(by: disposeBag)
    
    collectionView.rx.itemSelected.bind(to: viewModel.itemSelected)
    
    viewModel.result.drive(collectionView.rx.items(dataSource: dataSource))
    
  }
  
}
