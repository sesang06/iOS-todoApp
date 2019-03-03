//
//  RestuarantModel.swift
//  iOS-todoApp
//
//  Created by 조세상 on 16/02/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation

struct Restaurant {
  var name: String = ""
  var location: String = ""
  var description: String = ""
  let pictureURL: [String] = []
  var genre: Genre = .korean
  let menus : [Menu] = []
}

struct Menu {
  var pictureURL: [String] = []
}

extension Restaurant {

  enum Genre: String, CaseIterable {
    case korean = "한식"
    case japanese = "일식"
    case chinese = "중식"
  }
  
  enum FoodGenre: String, CaseIterable {
    case meat = "고기"
    case noodle = "국수"
    case tenpura = "튀김"
  }
}
