//
//  APIClass.swift
//  Assessment
//
//  Created by david Myers on 4/4/21.
//

import UIKit
import Alamofire
import AlamofireImage

enum FetchUsersError: Error {
    case ResponseError(String)
    case ParseError(String)
}

var imageDownloader = ImageDownloader()

class APIClass: NSObject {

  static var stackExchangeUrl = "https://api.stackexchange.com/2.2/users?site=stackoverflow"

  class func getFrontPageOfStackExchange(completion:@escaping (_ users:[User]?,_ FetchUsersError:Error?)->()){
    let request = AF.request(stackExchangeUrl)
    request.responseDecodable(of: Root.self) { (response) in
      guard let root = response.value else {
        if let responseCode = response.error?.responseCode,
           responseCode != 200{
           completion(nil,FetchUsersError.ResponseError("Error"))
        }else{
          completion(nil,FetchUsersError.ParseError("Error"))
        }
        return
      }
      completion(root.items,nil)
    }
  }
}
