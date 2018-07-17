//
//  ImagePickerViewProtocol.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

protocol ImagePickerViewProtocol {

  func show(_ error: String)
  func updatePhoto(with data: Data)
}
