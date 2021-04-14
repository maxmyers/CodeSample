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
  let textSeparator = NSAttributedString.init(string: " | ", attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:UIColor.label])

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

  private func displayBadgeText(_ dictionary:[String : Int]?){
    let badgeText = NSMutableAttributedString()
    if let goldBadgeValue = dictionary?["gold"]{
      badgeText.append(formatBadgeValue(goldBadgeValue, with: GoldColor))
    }
    if let silverBadgeValue = dictionary?["silver"]{
      badgeText.append(textSeparator)
      badgeText.append(formatBadgeValue(silverBadgeValue, with: SilverColor))
    }
    if let bronzeBadgeValue = dictionary?["bronze"]{
      badgeText.append(textSeparator)
      badgeText.append(formatBadgeValue(bronzeBadgeValue, with: BronzeColor))
    }
    badgesLabel.attributedText = badgeText
  }

  private func fetchAndDisplayGravatar(_ profileImage:String?){
    guard let profileImageLink = profileImage,
          let profileImageUrl =  URL(string: profileImageLink) else {
          return
    }
    // Display image place holder and animate
    DispatchQueue.main.async {[weak self] in
      self?.gravatarImageView.image = UIImage(named: "DogPlaceHolder")!
      self?.activityIndicator.startAnimating()
    }
    // Download gravatar
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
  private func formatBadgeValue(_ value:Int, with color:UIColor)->NSAttributedString{
    let text = "•" + " " + String(value)
    return NSAttributedString.init(string: text, attributes: [.font:UIFont.systemFont(ofSize: 18.0),.foregroundColor:color])
  }
  
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
