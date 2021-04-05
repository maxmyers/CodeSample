//
//  UserCell.swift
//  Assessment
//
//  Created by david Myers on 4/4/21.
//

import UIKit
import Alamofire
import AlamofireImage

class UserCell: UITableViewCell {

  @IBOutlet weak var gravatarImageView: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var badgesLabel: UILabel!

  var requestReceipt:RequestReceipt?
  var user:User?

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
  // MARK: - Setup
  func setUp(_ user:User){
    self.user = user
    fetchAndDisplayGravatar(user.profile_image)
    displayBadgeText(user.badge_counts)
    self.userNameLabel.text = user.display_name ?? "Not Available"
  }

  func displayBadgeText(_ dictionary:[String : Int]?){

    guard dictionary != nil else{
      return
    }
    let attributedText = NSMutableAttributedString()
    if let goldValue = dictionary!["gold"]{
      let text =  "•" + " " + String(goldValue)
      let goldText = NSAttributedString.init(string: text, attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:GoldColor])
      attributedText.append(goldText)
    }
    if let silverValue = dictionary!["silver"]{
      attributedText.append(NSAttributedString.init(string: " | ", attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:UIColor.label]))
      let text =  "•" + " " + String(silverValue)
      let silverText = NSAttributedString.init(string: text, attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:SilverColor])
      attributedText.append(silverText)
    }
    if let bronzeValue = dictionary!["bronze"]{
      attributedText.append(NSAttributedString.init(string: " | ", attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:UIColor.label]))
      let text =  "•" + " " + String(bronzeValue)
      let bronzeText = NSAttributedString.init(string: text, attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:BronzeColor])
      attributedText.append(bronzeText)
    }
    badgesLabel.attributedText = attributedText
  }

  func fetchAndDisplayGravatar(_ profileImage:String?){

    guard let profileImageLink = profileImage,
          let profileImageUrl =  URL(string: profileImageLink) else {
          return
    }
    // Display image place holder and animate
    DispatchQueue.main.async {[weak self] in
      self?.gravatarImageView.image = UIImage(named: "DogPlaceHolder")!
      self?.activityIndicator.startAnimating()
    }

    let urlRequest = URLRequest(url: profileImageUrl)
    requestReceipt = imageDownloader.download(urlRequest, completion:  { response in
      if case .success(let image) = response.result {
        DispatchQueue.main.async {[weak self] in
          self?.activityIndicator.stopAnimating()
          self?.gravatarImageView.image = image
        }
      }
    })
  }

  // MARK: - Helpers
  func clear(){
    badgesLabel.text = nil
    userNameLabel.text = nil
    gravatarImageView.image = nil
  }

  func cancelImageDownload(){
    if let requestReceipt_ = requestReceipt,
      requestReceipt_.request.isFinished == false{
      imageDownloader.cancelRequest(with: requestReceipt_)
    }
  }
}
