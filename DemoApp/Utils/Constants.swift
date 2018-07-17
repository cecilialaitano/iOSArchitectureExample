//
//  Constants.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

struct Constants {
  // MARK: - Networking layer
  static let schema = "https"
  static let host = "api.unsplash.com"
  static let pathPhotos = "/photos"
  static let cacheExpiresDate = Date().addingTimeInterval(-30.0 * 60)

  //Unsplash API
  static let unsplashAccessKey = "92a3ff4293e81e6d378425b8b5db8825d5f4d01f7c8054f4a61718fd53e25cd8"
  static let itemsPerPageKey = "per_page"
  static let itemsPerPageValue = "21"
  static let pageNumberKey = "page"

  //Headers
  static let versionHeaderKey = "Accept-Version"
  static let versionHeaderValue = "v1"
  static let authorizationHeaderKey = "Authorization"
  static let authorizationHeaderValue = "Client-ID \(unsplashAccessKey)"

  //MARK: - Photo list View Controller
  static let photoListReuseIdentifier = "PhotoListViewCell"

  //MARK: Segues
  static let segueFromLibrary = "FromLibrary"
  static let segueFromUnsplash = "FromUnsplash"
}
