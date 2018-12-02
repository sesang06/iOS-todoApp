//
//  TableViewController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 02/12/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TableViewViewModel {
    associatedtype T
    var privateDataSource : Variable<[T]> {
        get
    }
    var dataSource : Observable<[T]> {
        get
    }
}

class SpecificTableViewViewModel : TableViewViewModel {
    typealias T = String
    
    internal var privateDataSource: Variable<[String]> = Variable([])
    let disposeBag = DisposeBag()
    var dataSource: Observable<[String]>
    init(addItemTap : Driver<Void>){
        self.dataSource = privateDataSource.asObservable()
        addItemTap.drive(onNext: { [unowned self ] _  in
            self.privateDataSource.value.append("Item")
            }).disposed(by: disposeBag)
    }
        
}

class TableViewController : UITableViewController {
    private let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    private let cellIdentifier = "Cell"
    private let disposeBag = DisposeBag()
    private var viewModel : SpecificTableViewViewModel!
    //2
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupAddButton()
        setupTableView()
        setupTableViewBinding()
    }
    
    //3
    private func setupAddButton() {
        navigationItem.setRightBarButton(addButton, animated: true)
    }
    
    //4
    private func setupTableView() {
        //This is necessary since the UITableViewController automatically set his tableview delegate and dataSource to self
        tableView.delegate = nil
        tableView.dataSource = nil
        
        tableView.tableFooterView = UIView() //Prevent empty rows
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    private func setupViewModel() {
        self.viewModel = SpecificTableViewViewModel(addItemTap: addButton.rx.tap.asDriver())
    }
    private func setupTableViewBinding(){
        viewModel.dataSource
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) {  row, element, cell in
                cell.textLabel?.text = "\(element) \(row)"
            }
        .disposed(by: disposeBag)
    }
}
