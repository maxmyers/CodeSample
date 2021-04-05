//
//  User.swift
//  Assessment
//
//  Created by david Myers on 4/4/21.
//

import Foundation

struct User:Decodable {
  var badge_counts:[String:Int]?
  var account_id:Int?
  var is_employee:Bool?
  var last_modified_date:Int?
  var last_access_date:Int?
  var reputation_change_year:Int?
  var reputation_change_quarter:Int?
  var reputation_change_month:Int?
  var reputation_change_week:Int?
  var reputation_change_day:Int?
  var reputation:Int?
  var creation_date:Int?
  var user_type:String?
  var user_id:Int?
  var accept_rate:Int?
  var location:String?
  var website_url:String?
  var link:String?
  var profile_image:String?
  var display_name:String?
}
