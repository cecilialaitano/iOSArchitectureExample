//
//  Photo.swift
//  DemoApp
//
//  Created by Cecilia Laitano on 29/06/2018.
//  Copyright © 2018 cecilialaitano. All rights reserved.
//

import Foundation

struct UnsplashPhoto: Codable {
  var id: String
  var urls: PhotoURL
}

struct PhotoURL: Codable {
  var raw: String
  var full: String
  var regular: String
  var thumb: String
}

extension UnsplashPhoto: SelectablePhoto {

  func getPhotoDataFullSize(completion: @escaping GetSelectedPhoto) {
    let urlString = self.urls.full
    fetchService(with: urlString) { (data, error) in
      completion(data, error)
    }
  }

  func getThumb(completion: @escaping GetSelectedPhoto) {
    let urlString = self.urls.thumb
    fetchService(with: urlString) { (data, error) in
      completion(data, error)
    }
  }

  private func fetchService(with urlString: String, completion: @escaping GetSelectedPhoto) {
    guard let url = URL(string: urlString) else {
      completion(nil, FetchPhotosError.defualt)
      return
    }
    UnsplashService().getOneImageData(from: url, completion: { data, response, error in
      guard let imageData = data else {
        completion(nil, FetchPhotosError.defualt)
        return
      }
      completion(imageData, nil)
    })
  }
}
