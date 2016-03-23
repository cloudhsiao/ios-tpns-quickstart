//
//  ViewController.swift
//  TPNS
//
//  Created by Cloud Hsiao on 3/16/16.
//  Copyright © 2016 ThroughTek. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var bindButton: UIButton!
  
  let textFieldMaxLength = 20
  let disposeBag = DisposeBag()
  var viewModel: ViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let textFieldValid =
      textField.rx_text
        .map { $0.characters.count == 20 }
        .shareReplay(1)
    
    let deviceTokenValid =
      Global.sharedInstance.rx_deviceToken
        .map { $0.characters.count == 64 }
        .shareReplay(1)
    
    Observable
      .combineLatest(textFieldValid, deviceTokenValid) { $0 && $1 }
      .shareReplay(1)
      .bindTo(bindButton.rx_enabled)
      .addDisposableTo(disposeBag)
    
    viewModel = ViewModel(
      deviceToken: Global.sharedInstance.rx_deviceToken,
      text: textField.rx_text.asObservable(),
      buttonTap: bindButton.rx_tap.asObservable(),
      tableItemRemoved: tableView.rx_itemDeleted.asObservable())
    
    viewModel.list.asObservable()
      .bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) { (_, element, cell) in
        cell.textLabel?.text = element
      }
      .addDisposableTo(disposeBag)
  }
}

extension ViewController: UITextFieldDelegate {
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else {
      return true
    }
    let newLength = text.characters.count + string.characters.count - range.length
    return newLength <= textFieldMaxLength
  }
}
