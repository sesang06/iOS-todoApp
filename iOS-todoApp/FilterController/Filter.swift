//
//  Filter.swift
//  iOS-todoApp
//
//  Created by 조세상 on 24/02/2019.
//  Copyright © 2019 조세상. All rights reserved.
//

import Foundation


struct Filter {
  let genre: FilerType<Restaurant.Genre>
}

extension Filter {
  enum PickType {
    case random
  }
}

extension Filter {
  enum FilerType<T> {
    case positive(T)
    case negative(T)
  }
  
}
