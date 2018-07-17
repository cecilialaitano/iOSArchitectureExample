//
//  SelectablePhoto.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 02/07/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

typealias GetSelectedPhoto = ((_ data: Data?, _ error: FetchPhotosError?) -> ())

protocol SelectablePhoto {

  func getPhotoDataFullSize(completion: @escaping GetSelectedPhoto)
  func getThumb(completion: @escaping GetSelectedPhoto)
}
