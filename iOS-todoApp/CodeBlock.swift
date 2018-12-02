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
    associatedtype T : CodeBlock
    var selectedCodeBlocks : Variable<[T]> { get set }
    var candidateCodeBlocks : [T] { get }
    var answerCodeBlocks : [T] { get }
    
}

extension CodeSentence {
    func isRightSentence() -> Bool {
        return selectedCodeBlocks.value == answerCodeBlocks
    }
    
}

class EnglishCodeBlock : CodeBlock {
    var codeBlockName: String
    
    var codeBlockId: Int
    init(name: String){
        self.codeBlockName = name
        self.codeBlockId = 0
    }
}

class EnglishCodeSentence : CodeSentence {
    var selectedCodeBlocks: Variable<[EnglishCodeBlock]>
    var candidateCodeBlocks: [EnglishCodeBlock]
    var answerCodeBlocks: [EnglishCodeBlock]
    
    init(answerCodeBlocks : [EnglishCodeBlock], candidateCodeBlocks : [EnglishCodeBlock]){
        self.answerCodeBlocks = answerCodeBlocks
        self.candidateCodeBlocks = candidateCodeBlocks
        self.selectedCodeBlocks = Variable([])
    }
//    insertNewCandidateBlocks : Observer<
    
}

class EnglishCodeCollectionViewCell : UICollectionViewCell {
    let codeLabel : UILabel = {
        let label = UILabel()
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
class EnglishCodeViewController : UIViewController {
    lazy var collectionView : UICollectionView = {
        let cv = UICollectionView()
        return cv
    }()
    private let cellIdentifier = "Cell"
    private let disposeBag = DisposeBag()
    
    var viewModel : EnglishCodeSentence!
    
    override func viewDidLoad() {
        setUpViews()
        setUpCollectionViewBinding()
    }
    func setUpViews(){
        collectionView.register(EnglishCodeCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    func setUpCollectionViewBinding(){
        viewModel.selectedCodeBlocks.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier)) {  row, element, cell in
                // = element.codeBlockName
                guard let englishCollectionViewCell : EnglishCodeCollectionViewCell = cell as! EnglishCodeCollectionViewCell else{
                    return
                }
                englishCollectionViewCell.codeLabel.text = element.codeBlockName
                
            }
        .disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .subscribe(onNext:{ indexPath in
            //your code
            })
            .disposed(by: disposeBag)
    }
}
