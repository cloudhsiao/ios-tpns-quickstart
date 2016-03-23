//
//  ViewModel.swift
//  TPNS
//
//  Created by Cloud Hsiao on 3/17/16.
//  Copyright © 2016 ThroughTek. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import SwiftyJSON

class ViewModel {
  
  private let serverURL = "http://push.iotcplatform.com/tpns"
  private let disposeBag = DisposeBag()
  let list: Variable<[String]>
  
  init(deviceToken: Observable<String>,
    text: Observable<String>,
    buttonTap: Observable<Void>,
    tableItemRemoved: Observable<NSIndexPath>) {
    
    // load uid from UserDefaults
    if let data: [String] = NSUserDefaults.standardUserDefaults().objectForKey("UIDs") as? [String] {
      list = Variable<[String]>(data)
    } else {
      list = Variable<[String]>([])
    }

    deviceToken
      .filter {
        $0.characters.count == 64
      }
      .flatMapLatest { [unowned self] token in
        return self.request(self.serverURL, parameters: ["cmd": "client", "os": "ios", "appid": "com.tutk.cc.samples.tpns.ios", "udid": token, "token": token])
      }
      .observeOn(MainScheduler.instance)
      .subscribeNext {
        print($0)
      }
      .addDisposableTo(disposeBag)
      
    buttonTap
      .flatMapLatest {
        text.take(1)
      }
      .filter { [unowned self] s -> Bool in
        return !self.list.value.contains(s)
      }
      .subscribeNext { [unowned self] uid in
        self.list.value.append(uid)
      }
      .addDisposableTo(disposeBag)
      
    tableItemRemoved
      .map { return $0.row }
      .subscribeNext { [unowned self] idx in
        self.list.value.removeAtIndex(idx)
      }
      .addDisposableTo(disposeBag)
    
    list.asObservable()
      .flatMap { [unowned self] thiz in
        return Observable.combineLatest(deviceToken, self.mapsyncString(thiz)) { ($0, $1) }
      }
      .flatMapLatest { [unowned self] (token, mapsync) in
        return self.request(self.serverURL, parameters: ["cmd": "mapsync", "appid": "com.tutk.cc.samples.tpns.ios", "udid": token, "os": "ios", "map": mapsync.base64String()])
      }
      .observeOn(MainScheduler.instance)
      .subscribeNext {
        NSUserDefaults.standardUserDefaults().setObject(self.list.value, forKey: "UIDs")
        NSUserDefaults.standardUserDefaults().synchronize()
        print($0)
      }
      .addDisposableTo(disposeBag)
  }
  
  func request(url: String, parameters: [String: String]?) -> Observable<String> {
    return RxAlamofire.request(.GET, url, parameters: parameters)
      .flatMapLatest {
        $0
          .validate(statusCode: 200 ..< 300)
          .rx_string()
    }
//      .flatMapLatest { req -> Observable<String> in
//        print("request: \(req.request?.URL?.absoluteString)")
//        return req
//                .validate(statusCode: 200 ..< 300)
//                .rx_string()
//      }
  }

  func mapsyncString(list: [String]) -> Observable<String> {
    let array: NSMutableArray = []
    for uid in list {
      array.addObject(NSMutableDictionary(object: uid, forKey: "uid"))
    }
    
    let json = JSON(array)
    
    if let s = json.rawString() {
      return Observable<String>.just(s)
    } else {
      return Observable<String>.just("[]")
    }
  }
}