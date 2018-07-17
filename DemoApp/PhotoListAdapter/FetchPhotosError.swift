//
//  FetchPhotosError.swift
//  ArcBlock
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

enum FetchPhotosError: String, Error {
  case accessNotAllowed = "User do not grant access"
  case notDetermined = "Photo Library access not determined yet"
  case defualt = "Some error ocurr."
}
