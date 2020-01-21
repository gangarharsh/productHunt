//
//  Encodable.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 22/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import Foundation
extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
