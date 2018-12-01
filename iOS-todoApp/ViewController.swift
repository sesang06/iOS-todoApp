//
//  ViewController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 25/11/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    let helloWorldLabel : UILabel = {
        let label = UILabel()
        label.text = "Hello World, new Project"
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setUpViews(){
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Hello world, test Title"
        self.view.addSubview(helloWorldLabel)
        helloWorldLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLayoutGuide.snp.bottom)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.leading.trailing.equalTo(view)
        }
    }

}

