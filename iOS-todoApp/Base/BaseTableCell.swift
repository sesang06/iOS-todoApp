//
//  BaseTableCell.swift
//  iOS-todoApp
//
//  Created by 조세상 on 02/03/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit
class BaseTableCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setUpViews()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setUpViews(){
    
  }
}
