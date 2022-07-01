//
//  CancelBag.swift
//  Football
//
//  Created by Denis Svetlakov on 01.07.2022.
//

import Combine

final class CancelBag {
    
  var subscriptions = Set<AnyCancellable>()
    
  func cancel() {
    subscriptions.removeAll()
  }
}

