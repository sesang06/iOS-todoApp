//
//  MainTabController.swift
//  iOS-todoApp
//
//  Created by 조세상 on 03/03/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation
import UIKit

class MainTabController: UITabBarController{
  override func viewDidLoad() {
    let restuarantListController = RestaurantListController()
    restuarantListController.tabBarItem = UITabBarItem(title: "리스트", image: nil, tag: 0)
    
    let pickResultController = PickResultController()
    pickResultController.tabBarItem = UITabBarItem(title: "선택", image: nil, tag: 1)
    
    
    let postRestuarantController = PostRestaurantController()
    postRestuarantController.tabBarItem = UITabBarItem(title: "생성", image: nil, tag: 2)
    
    self.viewControllers = [restuarantListController, pickResultController, postRestuarantController]
    
  }
}
