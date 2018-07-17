//
//  PhotoListAdapter.swift
//  ArcBlock
//
//  Created by Cecilia Laitano on 28/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

typealias FetchPhotoLibraryClosure = ((_ isSuccess: Bool, _ error: FetchPhotosError?) -> ())
typealias GetPhotoDataHandler = ((_ imageData: Data?, _ error: FetchPhotosError?) -> ())

enum PhotoType {
  case thumb
  case full
}

enum PhotoSource {
  case library
  case unsplash
}

protocol PhotoListAdapter {

  func getNumberOfPhotos() -> Int
  func fetchPhotos(completion: @escaping FetchPhotoLibraryClosure)
  func getImageData(for row: Int, type: PhotoType, completion: @escaping GetPhotoDataHandler)
  func getSelectedItem(_ selected: Int) -> SelectablePhoto
}
