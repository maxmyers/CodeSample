//
//  MainViewController.swift
//  Assessment
//
//  Created by david Myers on 4/4/21.
//

import UIKit

class MainViewController: UITableViewController {

    var users:[User] = []

  @IBAction func refreshSelected(_ sender: UIBarButtonItem) {
    loadStackExchangeData()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.separatorStyle = .none
    loadStackExchangeData()
  }

  func loadStackExchangeData(){
    APIClass.getFrontPageOfStackExchange { (userArray, err) in
      guard err == nil else{
        self.showErrorAlert(err)
        return
      }
      if let users_ = userArray{
        self.users = users_
        self.tableView.reloadData()
      }
    }
  }

  // MARK: - Helpers
  func showErrorAlert(_ err:Error?){
    let alert = UIAlertController(title: "Error", message: err?.localizedDescription ?? "Error - Can not get the front page", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }

  // MARK: - Table view delegate

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if let headerView = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as? UIView{
      return headerView
    }
    return nil
  }

  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat(102)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return CGFloat(87)
  }

  override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
    cell.cancelImageDownload()
    cell.clear()
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  // MARK: - Table view data source

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserCell
    let user = users[indexPath.row]
    cell.setUp(user)
    return cell
  }
}
