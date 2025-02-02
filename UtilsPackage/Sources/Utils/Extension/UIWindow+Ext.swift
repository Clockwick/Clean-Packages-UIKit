//
//  UI.swift
//  Utils
//
//  Created by Paratthakorn Sribunyong on 2/2/2568 BE.
//

import UIKit

public extension UIWindow {
  override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    super.motionEnded(motion, with: event)
    if motion == .motionShake {
      NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
    }
  }
}
