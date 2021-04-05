//
//  Root.swift
//  Assessment
//
//  Created by david Myers on 4/4/21.
//

import Foundation

struct Root: Decodable {
  var items: [User]?
  var has_more:Bool?
  var quota_max:Int?
  var quota_remaining:Int?
}
