//
//  CodeBlock.swift
//  iOS-todoApp
//
//  Created by 조세상 on 02/12/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
protocol CodeBlock : Equatable {
    var codeBlockName : String { get }
    var codeBlockId : Int { get }
}
extension CodeBlock {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.codeBlockName == rhs.codeBlockName
    }
}

protocol CodeSentence {
    associatedtype T
    var selectedCodeBlocks : Variable<[T]> { get set }
    var candidateCodeBlocks : Variable<[T]> { get }
//    var answerCodeBlocks : [T] { get }
    
}
//
//extension CodeSentence {
//    func isRightSentence() -> Bool {
//        return selectedCodeBlocks.value == answerCodeBlocks
//    }
//
//}

struct EnglishCodeBlock : CodeBlock, Hashable {
    var codeBlockName: String
    
    var codeBlockId: Int
    init(name: String, id : Int){
        self.codeBlockName = name
        self.codeBlockId = id
    }
}

enum EnglishCodeSentenceCollectionViewCellItem {
    case selected(cellViewModel : EnglishCodeBlock)
    case candidate(cellViewModel : EnglishCodeBlock, isSelected : Bool)
}


extension EnglishCodeSentenceCollectionViewCellItem : IdentifiableType, Equatable{
    
    typealias Identity = Int
    var identity : Identity {
        
        switch  self {
        case let .selected(cellViewModel: block):
            return block.codeBlockId
        case let .candidate(block, isSelected):
            return isSelected ? block.codeBlockId : -block.codeBlockId
        }
    }
    static func ==(lhs : EnglishCodeSentenceCollectionViewCellItem, rhs: EnglishCodeSentenceCollectionViewCellItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}
struct EnglishCodeSentenceCollectionViewSectionModel {
    typealias Identity = Int
    typealias Item = EnglishCodeSentenceCollectionViewCellItem
    
    var index : Int
    var items : [Item]
}
extension EnglishCodeSentenceCollectionViewSectionModel : IdentifiableType{
    var identity : Identity {
       return index
    }
    
}
extension EnglishCodeSentenceCollectionViewSectionModel : AnimatableSectionModelType {
    
    init(original: EnglishCodeSentenceCollectionViewSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
    
}
//public struct AnimatableSectionModel<Section: IdentifiableType, ItemType: IdentifiableType & Equatable> {
//    public var model: Section
//    public var items: [Item]
//
//    public init(model: Section, items: [ItemType]) {
//        self.model = model
//        self.items = items
//    }
//
//}
class EnglishCodeSentenceViewModel : CodeSentence {
    var selectedCodeBlocks: Variable<[EnglishCodeSentenceCollectionViewCellItem]>
    var candidateCodeBlocks: Variable<[EnglishCodeSentenceCollectionViewCellItem]>
    var answerCodeBlocks: [EnglishCodeBlock]
    
    private let disposeBag = DisposeBag()
    init(answerCodeBlocks : [EnglishCodeBlock], candidateCodeBlocks : [EnglishCodeBlock]){
        self.answerCodeBlocks = answerCodeBlocks
        self.candidateCodeBlocks = Variable(candidateCodeBlocks.map { EnglishCodeSentenceCollectionViewCellItem.candidate(cellViewModel: $0, isSelected: false)})
        self.selectedCodeBlocks = Variable(EnglishCodeSentenceViewModel.setUpExampleEnglishCodeBlocks().map {
            EnglishCodeSentenceCollectionViewCellItem.selected(cellViewModel: $0)
        })
    }
    convenience init(answerCodeBlocks : [EnglishCodeBlock], candidateCodeBlocks : [EnglishCodeBlock], itemSelected : Driver<IndexPath>){
        self.init(answerCodeBlocks: answerCodeBlocks, candidateCodeBlocks: candidateCodeBlocks)
        itemSelected.drive(onNext: { [unowned self ] indexPath  in
            if (indexPath.section == 0){
                self.selectedCodeBlocks.value.remove(at: indexPath.item)
            }else {
                switch self.candidateCodeBlocks.value[indexPath.item]{
                    case .selected(let _):
                        return
                    case .candidate(let cellViewModel, let isSelected):
                        self.candidateCodeBlocks.value[indexPath.item] = .candidate(cellViewModel: cellViewModel, isSelected: !isSelected)
                    }
            }
        }).disposed(by: disposeBag)
    }
    
    static func setUpExampleEnglishCodeBlocks() -> [EnglishCodeBlock]{
        return [EnglishCodeBlock.init(name: "I", id : 0), EnglishCodeBlock.init(name: "am", id : 1) ,
                EnglishCodeBlock.init(name: "a", id : 2), EnglishCodeBlock.init(name: "boy", id : 3)]
    }
    static func setUpExampleEnglishCandidateCodeBlocks() -> [EnglishCodeBlock]{
        return [EnglishCodeBlock.init(name: "I", id : 4), EnglishCodeBlock.init(name: "am", id : 5) ,
                EnglishCodeBlock.init(name: "a", id : 6), EnglishCodeBlock.init(name: "boy", id : 7)]
    }
}

class EnglishCodeCollectionViewCell : UICollectionViewCell {
    let codeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpViews(){
        self.addSubview(codeLabel)
        codeLabel.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(self)
        }
    }
}
class EnglishCodeViewController : UIViewController, UICollectionViewDelegateFlowLayout {
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private let cellIdentifier = "Cell"
    private let disposeBag = DisposeBag()
    
    var viewModel : EnglishCodeSentenceViewModel!
    let dataSource = RxCollectionViewSectionedAnimatedDataSource<EnglishCodeSentenceCollectionViewSectionModel>(configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            guard let englishCollectionViewCell : EnglishCodeCollectionViewCell = cell as? EnglishCodeCollectionViewCell else{
                return cell
            }
            switch dataSource[indexPath] {
                case let .selected(viewModel):
                    englishCollectionViewCell.codeLabel.text = viewModel.codeBlockName
                    englishCollectionViewCell.codeLabel.backgroundColor = UIColor.white
                case let .candidate(viewModel, isSelected):
                    englishCollectionViewCell.codeLabel.text = viewModel.codeBlockName
                    
                    if (isSelected){
                        englishCollectionViewCell.codeLabel.backgroundColor = UIColor.red
                    }else {
                        englishCollectionViewCell.codeLabel.backgroundColor = UIColor.white
                    }
            }
            return englishCollectionViewCell
        }
    )

    
    override func viewDidLoad() {
        setUpViews()
        setUpViewModels()
        setUpCollectionViewBinding()
    }
    func setUpViewModels(){
        viewModel = EnglishCodeSentenceViewModel.init(answerCodeBlocks: [], candidateCodeBlocks: EnglishCodeSentenceViewModel.setUpExampleEnglishCandidateCodeBlocks(), itemSelected: collectionView.rx.itemSelected.asDriver())
    }
    func setUpViews(){
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.top.leading.trailing.equalTo(self.view)
        }
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.register(EnglishCodeCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
    }
    func setUpCollectionViewBinding(){
        let selected = viewModel.selectedCodeBlocks.asObservable().map { (items) -> EnglishCodeSentenceCollectionViewSectionModel in
          return  EnglishCodeSentenceCollectionViewSectionModel(index: 0, items: items)
        }
        
        let candidate = viewModel.candidateCodeBlocks.asObservable().map { (items) -> EnglishCodeSentenceCollectionViewSectionModel in
            return EnglishCodeSentenceCollectionViewSectionModel(index: 1, items: items)
        }
        
        Observable.combineLatest([selected, candidate])
        .bind(to: collectionView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
    }
}


//        viewModel.selectedCodeBlocks.asObservable()
////            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier)) {  row, element, cell in
////                // = element.codeBlockName
////                guard let englishCollectionViewCell : EnglishCodeCollectionViewCell = cell as! EnglishCodeCollectionViewCell else{
////                    return
////                }
////                englishCollectionViewCell.codeLabel.text = element.codeBlockName
////
////            }
//            .disposed(by: disposeBag)
//       Observable.combineLatest(viewModel.candidateCodeBlocks.asObservable(), viewModel.selectedCodeBlocks.asObservable())
//        .bind(to: collectionView.rx.items(dataSource: viewModel.dataSouce))
//         .disposed(by: disposeBag)
//        let sections : [EnglishCodeSentenceCollectionViewSectionModel] = [
//            viewModel.selectedCodeBlocks.asObservable().map()
//        ]
