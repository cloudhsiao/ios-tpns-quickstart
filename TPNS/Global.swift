//
//  Global.swift
//  TPNS
//
//  Created by Cloud Hsiao on 3/18/16.
//  Copyright © 2016 ThroughTek. All rights reserved.
//

import Foundation
import RxSwift

class Global {
  
  var deviceToken: String? {
    didSet {
      if let token = deviceToken {
        rx_deviceToken.onNext(token)
      }
    }
  }
  
  var rx_deviceToken = BehaviorSubject<String>(value: "")
  
  class var sharedInstance: Global {
    struct Static {
      static let instance: Global = Global()
    }
    return Static.instance
  }
}