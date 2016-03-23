//
//  String+Base64.swift
//  TPNS
//
//  Created by Cloud Hsiao on 3/17/16.
//  Copyright © 2016 ThroughTek. All rights reserved.
//

import Foundation

extension String {
  func base64String() -> String {
    let data = dataUsingEncoding(NSUTF8StringEncoding)
    return data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
  }
}