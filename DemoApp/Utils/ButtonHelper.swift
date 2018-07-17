//
//  ButtonHelper.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import UIKit

extension UIButton {

  func setRoundCorners() {
    self.clipsToBounds = true
    self.layer.cornerRadius = 2.5
  }
}
